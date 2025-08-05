USE HelpDesk;

-- Procedure 1

--                                                                             GERAR KPI PARA TÉCNICO POR PERÍODO
DELIMITER //

CREATE PROCEDURE GerarKPIParaTecnicoPorPeriodo(
    IN p_matricula_tec INT,
    IN p_dt_inicio DATE,
    IN p_dt_fim DATE
)
BEGIN
    DECLARE v_nome_tec VARCHAR(255);
    DECLARE v_chamados_fechados INT;
    DECLARE v_servicos_concluidos INT;
    DECLARE v_proximo_sequencial INT;

    -- Obter o nome do técnico
    SELECT nome INTO v_nome_tec
    FROM TECNICO
    WHERE Matricula = p_matricula_tec;

    -- Se o técnico não for encontrado, podemos sair ou gerar um erro
    IF v_nome_tec IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Técnico não encontrado com a matrícula fornecida.';
    END IF;

    -- Calcular o número de chamados fechados para o técnico no período
    SELECT COUNT(*)
    INTO v_chamados_fechados
    FROM CHAMADO
    WHERE mat_tec = p_matricula_tec
      AND status = 'Resolvido'
      AND data BETWEEN p_dt_inicio AND p_dt_fim;

    -- Calcular o número de serviços concluídos para o técnico no período
    SELECT COUNT(DISTINCT S.cod)
    INTO v_servicos_concluidos
    FROM SERVICO S
    INNER JOIN ORDEM_SERVICO OS ON S.num_serv = OS.numero
    INNER JOIN CHAMADO C ON OS.cod_chamado = C.Seq
    WHERE C.mat_tec = p_matricula_tec
      AND S.status = 'Concluído'
      AND OS.data_criacao BETWEEN p_dt_inicio AND p_dt_fim;

    -- Obter o próximo Sequencial disponível para este técnico
    SELECT COALESCE(MAX(Sequencial), 0) + 1
    INTO v_proximo_sequencial
    FROM KPI
    WHERE matric_tec = p_matricula_tec;

    INSERT INTO KPI (matric_tec, Sequencial, KPI_1, dsc_KPI_1, KPI_2, dsc_KPI_2)
    VALUES (
        p_matricula_tec,
        v_proximo_sequencial,
        'Chamados Fechados',
        CONCAT('Número de chamados fechados pelo técnico ', v_nome_tec, ' de ', p_dt_inicio, ' a ', p_dt_fim, ': ', v_chamados_fechados),
        'Serviços Concluídos',
        CONCAT('Número de serviços finalizados pelo técnico ', v_nome_tec, ' de ', p_dt_inicio, ' a ', p_dt_fim, ': ', v_servicos_concluidos)
    );

END //

DELIMITER ;

CALL GerarKPIParaTecnicoPorPeriodo(101, '2025-07-01', '2025-07-31');
CALL GerarKPIParaTecnicoPorPeriodo(102, '2025-07-01', '2025-07-31');
CALL GerarKPIParaTecnicoPorPeriodo(103, '2025-07-01', '2025-07-31');



-- SELECTS PARA VERACIDADE DAS INFORMAÇÕES PRESTADAS:
SELECT
    Seq AS 'Sequencial do Chamado',
    Prioridade,
    descricao AS 'Descrição do Chamado',
    status,
    data AS 'Data do Chamado',
    T.nome AS 'Nome do Técnico'
FROM
    CHAMADO C
JOIN
    TECNICO T ON C.mat_tec = T.Matricula
WHERE
    C.status = 'Resolvido';

-- VERIFICAR SERVIÇOS CONCLUÍDOS POR UM TÉCNICO:
SELECT
    T.nome AS 'Nome do Técnico',
    TS.descricao AS 'Tipo de Serviço',
    S.descricao AS 'Descrição do Serviço',
    S.status AS 'Status do Serviço',
    S.valor AS 'Valor do Serviço',
    OS.data_criacao AS 'Data da Ordem de Serviço'
FROM
    SERVICO S
JOIN
    TIPO_SERVICO TS ON S.cod_tipo_servico = TS.cod
JOIN
    ORDEM_SERVICO OS ON S.num_serv = OS.numero
JOIN
    CHAMADO C ON OS.cod_chamado = C.Seq
JOIN
    TECNICO T ON C.mat_tec = T.Matricula
WHERE
    S.status = 'Concluído'
    AND T.Matricula = 101;


SELECT *
FROM KPI
WHERE matric_tec = 101;

SELECT *
FROM KPI;

-- Procedure 2

--                                                                                          PARA IMPRESSORA

CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Impressora_Cliente (
    temp_cod INT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50),
    fabricante VARCHAR(255),
    data_entrada DATE,
    setor VARCHAR(255),
    descricao TEXT,
    historico TEXT,
    modelo VARCHAR(255),
    cod_contrato INT
);


INSERT INTO Temp_Impressora_Cliente (estado, fabricante, data_entrada, setor, descricao, historico, modelo, cod_contrato) VALUES
('Em uso', 'Canon', '2025-01-01', 'Marketing', 'Impressora a jato de tinta para grandes volumes.', NULL, 'Pixma G3110', 7),
('Em uso', 'HP', '2025-02-10', 'RH', 'Impressora laser monocromática.', 'Toner trocado em Jun/2025.', 'LaserJet Pro MFP M28w', 8),
('Em reparo', 'Epson', '2025-03-05', 'Contabilidade', 'Impressora matricial.', 'Problema no cabeçote de impressão.', 'FX-890II', 7);

DELIMITER $$

CREATE PROCEDURE InserirImpressorasViaCursor()
BEGIN

    DECLARE v_estado VARCHAR(50);
    DECLARE v_fabricante VARCHAR(255);
    DECLARE v_data_entrada DATE;
    DECLARE v_setor VARCHAR(255);
    DECLARE v_descricao TEXT;
    DECLARE v_historico TEXT;
    DECLARE v_modelo VARCHAR(255);
    DECLARE v_cod_contrato INT;
    

    DECLARE done INT DEFAULT FALSE;

    DECLARE impressora_cursor CURSOR FOR 
        SELECT estado, fabricante, data_entrada, setor, descricao, historico, modelo, cod_contrato
        FROM Temp_Impressora_Cliente;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    START TRANSACTION;

    OPEN impressora_cursor;

    read_loop: LOOP
        FETCH impressora_cursor INTO v_estado, v_fabricante, v_data_entrada, v_setor, v_descricao, v_historico, v_modelo, v_cod_contrato;

        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO IMPRESSORA (estado, fabricante, data_entrada, setor, descricao, historico, modelo, cod_contrato) VALUES
        (v_estado, v_fabricante, v_data_entrada, v_setor, v_descricao, v_historico, v_modelo, v_cod_contrato);

    END LOOP;

    CLOSE impressora_cursor;

    COMMIT;

    SELECT 'Inserção de impressoras concluída com sucesso!' AS Mensagem;

END $$

DELIMITER ;


CALL InserirImpressorasViaCursor();
SELECT * FROM IMPRESSORA;
DROP TEMPORARY TABLE IF EXISTS Temp_Impressora_Cliente;

--                                                                                        PARA COMPUTADOR


CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Computador_Cliente (
    temp_cod INT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50),
    fabricante VARCHAR(255),
    data_entrada DATE,
    setor VARCHAR(255),
    descricao TEXT,
    historico TEXT,
    bios_fabric VARCHAR(255),
    versao_bios VARCHAR(50),
    nome_so VARCHAR(255),
    versao_so VARCHAR(50),
    end_IP VARCHAR(15),
    tipo VARCHAR(50),
    cod_contrato INT
);

INSERT INTO Temp_Computador_Cliente (estado, fabricante, data_entrada, setor, descricao, historico, bios_fabric, versao_bios, nome_so, versao_so, end_IP, tipo, cod_contrato) VALUES
('Em uso', 'Apple', '2024-11-01', 'Engenharia', 'Desktop para CAD.', 'Nenhuma manutenção registrada.', 'AMI', 'F.01', 'Windows', '10 Pro', '192.168.1.106', 'Desktop', 7),
('Em uso', 'Positivo', '2024-12-15', 'Marketing', 'Notebook leve para viagens.', 'Limpeza interna em mai/2025.', 'Insyde', '2.00', 'Windows 11', '11 Home', '192.168.1.107', 'Notebook', 8),
('Em reparo', 'LG', '2025-01-20', 'Design', 'Workstation para renderização.', 'Placa de vídeo com defeito.', 'Dell', 'A05', 'Linux Mint', '21', '192.168.1.108', 'Workstation', 10);

DELIMITER $$

CREATE PROCEDURE InserirComputadoresViaCursor()
BEGIN
    DECLARE v_estado VARCHAR(50);
    DECLARE v_fabricante VARCHAR(255);
    DECLARE v_data_entrada DATE;
    DECLARE v_setor VARCHAR(255);
    DECLARE v_descricao TEXT;
    DECLARE v_historico TEXT;
    DECLARE v_bios_fabric VARCHAR(255);
    DECLARE v_versao_bios VARCHAR(50);
    DECLARE v_nome_so VARCHAR(255);
    DECLARE v_versao_so VARCHAR(50);
    DECLARE v_end_IP VARCHAR(15);
    DECLARE v_tipo VARCHAR(50);
    DECLARE v_cod_contrato INT;
    
    DECLARE done INT DEFAULT FALSE;


    DECLARE computador_cursor CURSOR FOR 
        SELECT estado, fabricante, data_entrada, setor, descricao, historico, bios_fabric, versao_bios, nome_so, versao_so, end_IP, tipo, cod_contrato
        FROM Temp_Computador_Cliente;


    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    START TRANSACTION;

    OPEN computador_cursor;

    read_loop: LOOP
        FETCH computador_cursor INTO v_estado, v_fabricante, v_data_entrada, v_setor, v_descricao, v_historico, v_bios_fabric, v_versao_bios, v_nome_so, v_versao_so, v_end_IP, v_tipo, v_cod_contrato;

        IF done THEN
            LEAVE read_loop;
        END IF;


        INSERT INTO COMPUTADOR (estado, fabricante, data_entrada, setor, descricao, historico, bios_fabric, versao_bios, nome_so, versao_so, end_IP, tipo, cod_contrato) VALUES
        (v_estado, v_fabricante, v_data_entrada, v_setor, v_descricao, v_historico, v_bios_fabric, v_versao_bios, v_nome_so, v_versao_so, v_end_IP, v_tipo, v_cod_contrato);

    END LOOP;

    CLOSE computador_cursor;


    COMMIT;

    SELECT 'Inserção de computadores concluída com sucesso!' AS Mensagem;

END $$

DELIMITER ;

CALL InserirComputadoresViaCursor();
SELECT * FROM COMPUTADOR;
DROP TEMPORARY TABLE IF EXISTS Temp_Computador_Cliente;

--                                                                            TABELA DE DRIVER

CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Driver_Componente (
    temp_id INT AUTO_INCREMENT PRIMARY KEY,
    cod_componente INT NOT NULL,
    Sequencial INT NOT NULL,
    Caminho VARCHAR(255)
);


INSERT INTO Temp_Driver_Componente (cod_componente, Sequencial, Caminho) VALUES
(1, 2, '/drivers/motherboard/ASUS/B450m_latest.zip'), -- Exemplo para componente 1 (Placa Mãe)
(3, 1, '/drivers/ram/asgarg/asgard_firmware.bin'),   -- Exemplo para componente 3 (Memória RAM)
(7, 1, '/drivers/audio/realtek/ALC1200_audio.exe');    -- Exemplo para componente 7 (Placa de Áudio)

DELIMITER $$

CREATE PROCEDURE InserirDriversViaCursor()
BEGIN
    DECLARE v_cod_componente INT;
    DECLARE v_Sequencial INT;
    DECLARE v_Caminho VARCHAR(255);
    

    DECLARE done INT DEFAULT FALSE;

    DECLARE driver_cursor CURSOR FOR 
        SELECT cod_componente, Sequencial, Caminho
        FROM Temp_Driver_Componente;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    START TRANSACTION;

    OPEN driver_cursor;

    read_loop: LOOP
        FETCH driver_cursor INTO v_cod_componente, v_Sequencial, v_Caminho;

        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO DRIVER (cod_componente, Sequencial, Caminho) VALUES
        (v_cod_componente, v_Sequencial, v_Caminho);

    END LOOP;

    CLOSE driver_cursor;

    COMMIT;

    SELECT 'Inserção de drivers concluída com sucesso!' AS Mensagem;

END $$

DELIMITER ;

CALL InserirDriversViaCursor();
SELECT * FROM DRIVER;
DROP TEMPORARY TABLE IF EXISTS Temp_Driver_Componente;

--                                                                                    TABELA DE COMPONENTE

CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Componente_Novo (
    temp_id INT AUTO_INCREMENT PRIMARY KEY,
    onboard BOOLEAN,
    tipo VARCHAR(50),
    modelo VARCHAR(255),
    fabricante VARCHAR(255)
);

INSERT INTO Temp_Componente_Novo (onboard, tipo, modelo, fabricante) VALUES
(FALSE, 'Placa de Som', 'Sound Blaster Z', 'Creative'),
(TRUE, 'Placa de Vídeo Integrada', 'Iris Xe Graphics', 'Intel'),
(FALSE, 'Fonte de Alimentação', 'RM750e', 'Corsair');

DELIMITER $$

CREATE PROCEDURE InserirComponentesViaCursor()
BEGIN

    DECLARE v_onboard BOOLEAN;
    DECLARE v_tipo VARCHAR(50);
    DECLARE v_modelo VARCHAR(255);
    DECLARE v_fabricante VARCHAR(255);
    
    DECLARE done INT DEFAULT FALSE;

    DECLARE componente_cursor CURSOR FOR 
        SELECT onboard, tipo, modelo, fabricante
        FROM Temp_Componente_Novo;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    START TRANSACTION;

    OPEN componente_cursor;

    read_loop: LOOP
        FETCH componente_cursor INTO v_onboard, v_tipo, v_modelo, v_fabricante;

        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO COMPONENTE (onboard, tipo, modelo, fabricante) VALUES
        (v_onboard, v_tipo, v_modelo, v_fabricante);

    END LOOP;

    CLOSE componente_cursor;

    COMMIT;

    SELECT 'Inserção de componentes concluída com sucesso!' AS Mensagem;

END $$

DELIMITER ;

CALL InserirComponentesViaCursor();
SELECT * FROM COMPONENTE;
DROP TEMPORARY TABLE IF EXISTS Temp_Componente_Novo;

-- Procedure 3
-- DROP PROCEDURE procedure_atualizar_os_concluidas
DELIMITER //


CREATE PROCEDURE procedure_atualizar_os_concluidas()
BEGIN
    -- Declaração de variáveis auxiliares
    DECLARE os_concluida INT DEFAULT FALSE;        -- Flag para controle do cursor (usada para saber quando parar)
    DECLARE codigo_Fatura INT;                     -- Código da fatura da OS
    DECLARE codigo_chamado INT;                    -- Código do chamado da OS
    DECLARE os_status VARCHAR(50);                 -- Status do chamado
    DECLARE fat_status VARCHAR(50);                -- Status da fatura associada

    -- Declaração do cursor que seleciona as OS com chamado resolvido e fatura ainda não paga
    DECLARE cursor_os_concluidas CURSOR FOR
        SELECT
            OS.cod_fatura,
            OS.cod_chamado,
            C.status,
            F.status
        FROM
            ORDEM_SERVICO AS OS
        JOIN
            CHAMADO AS C ON OS.cod_chamado = C.Seq
        JOIN
            FATURA AS F ON OS.cod_fatura = F.cod
        WHERE
            C.status = 'Resolvido'         -- Apenas chamados que já foram resolvidos
            AND F.status != 'Paga';        -- Considera somente faturas que ainda não estão pagas

   
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET os_concluida = TRUE;

  
    START TRANSACTION;

    
    OPEN cursor_os_concluidas;

    -- Loop de leitura das linhas retornadas pelo cursor
    read_loop: LOOP
        -- Lê os dados da próxima linha do cursor nas variáveis
        FETCH cursor_os_concluidas INTO codigo_Fatura, codigo_chamado, os_status, fat_status;

        -- Verifica se chegou ao fim do cursor
        IF os_concluida THEN
            LEAVE read_loop; -- Sai do loop se não há mais registros
        END IF;

        -- Verifica se a fatura ainda não está paga (checagem redundante, mas segura)
        IF fat_status != 'Paga' THEN
            -- Atualiza o status da fatura para 'Paga'
            UPDATE FATURA
            SET status = 'Paga'
            WHERE cod = codigo_Fatura;
        END IF;

    END LOOP;

    -- Fecha o cursor após o uso
    CLOSE cursor_os_concluidas;

    -- Confirma todas as atualizações feitas
    COMMIT;

END //

DELIMITER ;


-- Teste procedure 3

-- Inserir faturas
INSERT INTO FATURA (cod, cod_cliente_pj, valor_total, data_emissao, status)
VALUES
  (1000, 1, 500.00, '2025-07-01','Em aberto'),
  (1001, 1, 700.00, '2025-07-02','Em aberto'),
  (1002, 1, 800.00, '2025-07-03','Paga');  -- já paga, não deve ser alterada

-- Inserir chamados
INSERT INTO CHAMADO (Seq, status)
VALUES
  (2000, 'Resolvido'),
  (2001, 'Aberto'),
  (2002, 'Resolvido');

UPDATE CHAMADO 
SET status = 'Resolvido'
WHERE Seq = 2001;

-- Inserir ordens de serviço
INSERT INTO ORDEM_SERVICO (numero, cod_fatura, cod_chamado, status, data_criacao, prazo_em_dias)
VALUES
  (88, 1000, 2000, 'Concluída', '2025-07-01', 5),  -- deve ser atualizada
  (89, 1001, 2001, 'Concluída', '2025-07-01', 5),  -- chamado não resolvido → não atualiza
  (90, 1002, 2002, 'Concluída', '2025-07-01', 5); 


CALL procedure_atualizar_os_concluidas();
SELECT * FROM FATURA WHERE cod IN (1000, 1001, 1002);


