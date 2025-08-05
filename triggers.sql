USE HelpDesk;


-- Trigger 1

 -- DROP TRIGGER trigger_kpi_chamados
DELIMITER //

CREATE TRIGGER trigger_kpi_chamados
AFTER UPDATE ON SERVICO
FOR EACH ROW
BEGIN
    -- Declara variável para guardar a matrícula do técnico
    DECLARE v_matric_tec INT;

    -- Declara variável para guardar o código do KPI "Chamados Fechados"
    DECLARE v_kpi_sequencial INT;

    -- Verifica se o status do serviço foi alterado para 'Concluído'
    IF OLD.status != 'Concluído' AND NEW.status = 'Concluído' THEN

        -- Busca a matrícula do técnico responsável pelo serviço concluído
        SELECT T.Matricula
        INTO v_matric_tec
        FROM TECNICO AS T
        JOIN CHAMADO AS C ON T.Matricula = C.mat_tec
        JOIN ORDEM_SERVICO AS OS ON C.Seq = OS.cod_chamado
        WHERE OS.numero = NEW.num_serv
        LIMIT 1;

        -- Busca o sequencial do KPI "Chamados Fechados" para esse técnico
        SELECT Sequencial
        INTO v_kpi_sequencial
        FROM KPI
        WHERE matric_tec = v_matric_tec
          AND KPI_1 = 'Chamados Fechados'
        LIMIT 1;

        -- Se encontrou tanto o técnico quanto o KPI
        IF v_matric_tec IS NOT NULL AND v_kpi_sequencial IS NOT NULL THEN

            -- Tenta atualizar o valor atual do KPI, somando 1
            UPDATE VALOR_KPI
            SET valor_kpi_numerico = valor_kpi_numerico + 1
            WHERE matric_tec = v_matric_tec
              AND kpi_sequencial = v_kpi_sequencial;

            -- Se nenhuma linha foi atualizada (não havia registro para o dia), insere novo registro
            IF ROW_COUNT() = 0 THEN
                INSERT INTO VALOR_KPI (matric_tec, kpi_sequencial, data_registro, valor_kpi_numerico)
                VALUES (v_matric_tec, v_kpi_sequencial, CURDATE(), 1);
            END IF;

        END IF; -- Fim verificação técnico e KPI existentes

    END IF; -- Fim verificação status = 'Concluído'

END //

DELIMITER ;

-- Trigger 2

DELIMITER //

-- Trigger que é acionado após a inserção de um novo técnico
CREATE TRIGGER trigger_updt_tecnicos -- Atualização de técnicos
AFTER INSERT ON TECNICO
FOR EACH ROW
BEGIN
    -- Atualiza a tabela UNIDADE_SUPORTE:
    -- Incrementa o campo NroFuncionarios da unidade associada ao novo técnico
    UPDATE UNIDADE_SUPORTE
    SET NroFuncionarios = COALESCE(NroFuncionarios, 0) + 1 
    WHERE CNPJ = NEW.unidade; -- Usa a unidade da nova linha inserida para identificar qual unidade atualizar
END //

-- Trigger que é acionado após a exclusão de um técnico
CREATE TRIGGER trigger_del_tecnicos -- Deletar técnicos
AFTER DELETE ON TECNICO
FOR EACH ROW
BEGIN
    -- Atualiza a tabela UNIDADE_SUPORTE:
    -- Decrementa o campo NroFuncionarios da unidade associada ao técnico removido
    UPDATE UNIDADE_SUPORTE
    SET NroFuncionarios = COALESCE(NroFuncionarios, 0) - 1 -- Garante que, se NroFuncionarios for NULL, considere como 0 e subtraia 1
    WHERE CNPJ = OLD.unidade; -- Usa o campo "unidade" da linha excluída para identificar qual unidade atualizar
END //



CREATE TRIGGER trigger_updt_supervisores -- Atualizar supervisores
AFTER INSERT ON SUPERVISOR
FOR EACH ROW
BEGIN
    UPDATE UNIDADE_SUPORTE
    SET NroFuncionarios = COALESCE(NroFuncionarios, 0) + 1
    WHERE CNPJ = NEW.unidade;
END //


CREATE TRIGGER trigger_del_supervisores -- Deletar supervisores
AFTER DELETE ON SUPERVISOR
FOR EACH ROW
BEGIN
    UPDATE UNIDADE_SUPORTE
    SET NroFuncionarios = COALESCE(NroFuncionarios, 0) - 1
    WHERE CNPJ = OLD.unidade;
END //

DELIMITER ;

-- Trigger 3

-- DROP TRIGGER IF EXISTS trigger_updt_dt_devida; 
DELIMITER //

CREATE TRIGGER trigger_updt_dt_devida
BEFORE INSERT ON ORDEM_SERVICO
FOR EACH ROW
BEGIN
    IF NEW.data_criacao IS NOT NULL AND NEW.prazo_em_dias IS NOT NULL THEN -- verifica se data_criacao e prazo_em_dias não são NULL
        SET NEW.dt_devida = DATE_ADD(NEW.data_criacao, INTERVAL NEW.prazo_em_dias DAY); -- dt_devida = data_criacao + prazo_em_dias
    END IF; 
END;
//

DELIMITER ;



-- Teste trigger 1

SELECT * FROM VALOR_KPI WHERE matric_tec = 101 AND kpi_sequencial = 2 AND id_valor_kpi = 2;

SELECT * FROM SERVICO WHERE num_serv = 1;

UPDATE SERVICO
SET status = 'Concluído'
WHERE num_serv = 1;




SELECT * FROM CHAMADO WHERE seq = 2;


SELECT * FROM ORDEM_SERVICO WHERE cod_chamado = 2;




-- fim teste trigger 1

-- Teste trigger 2

SELECT * FROM UNIDADE_SUPORTE;

INSERT INTO TECNICO (login, senha, nome, CPF, email, matric_supervisor, data_inicio, unidade)
VALUES ('tecnico12345', 'senhaqualquer123345', 'Gabriel Germano', '822.999.000-21','gabriel@ufrpe.br', 2, '2023-02-15', '00.000.000/0001-01');

DELETE FROM TECNICO
WHERE login = 'tecnico12345'
  AND CPF = '828.999.000-21'
  AND email = 'gabriel@ufrpe.br';

-- fim teste trigger 2


-- Teste trigger 3


SELECT * FROM ORDEM_SERVICO WHERE cod_chamado = 1;


INSERT INTO ORDEM_SERVICO (status, data_criacao, prazo_em_dias, cod_chamado)
VALUES ('Aberta', '2024-06-29', 25, 1);


-- fim teste trigger 3




