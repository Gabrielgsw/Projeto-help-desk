USE HelpDesk;

DELIMITER //


CREATE TRIGGER trigger_updt_tecnicos -- Atualização de técnicos
AFTER INSERT ON TECNICO
FOR EACH ROW
BEGIN
    UPDATE UNIDADE_SUPORTE
    SET NroFuncionarios = COALESCE(NroFuncionarios, 0) + 1 -- incrementa numero de funcionarios
    WHERE CNPJ = NEW.unidade;
END //


CREATE TRIGGER trigger_del_tecnicos -- Deletar técnicos
AFTER DELETE ON TECNICO
FOR EACH ROW
BEGIN
    UPDATE UNIDADE_SUPORTE
    SET NroFuncionarios = COALESCE(NroFuncionarios, 0) - 1 -- decrementa funcionários
    WHERE CNPJ = OLD.unidade;
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


 -- DROP TRIGGER trigger_kpi_chamados
DELIMITER //

CREATE TRIGGER trigger_kpi_chamados
AFTER UPDATE ON SERVICO
FOR EACH ROW
BEGIN
    DECLARE v_matric_tec INT;
    DECLARE v_kpi_sequencial INT; -- Sequencial para "Chamados Fechados"

    -- Verifica se o status do serviço mudou para 'CONCLUIDO'
    IF OLD.status != 'Concluído' AND NEW.status = 'Concluído' THEN
        -- Obtém a matrícula do técnico responsável por este serviço
        SELECT T.Matricula
        INTO v_matric_tec
        FROM TECNICO AS T
        JOIN CHAMADO AS C ON T.Matricula = C.mat_tec
        JOIN ORDEM_SERVICO AS OS ON C.Seq = OS.cod_chamado
        WHERE OS.numero = NEW.num_serv LIMIT 1;
        
        SELECT Sequencial INTO v_kpi_sequencial
        FROM KPI
        WHERE matric_tec = v_matric_tec AND KPI_1 = 'Chamados Fechados' LIMIT 1;

        -- Se o KPI foi encontrado e o tecnico existe
        IF v_matric_tec IS NOT NULL AND v_kpi_sequencial IS NOT NULL THEN
            -- atualiza valor correspondente 
            UPDATE VALOR_KPI
            SET valor_kpi_numerico = valor_kpi_numerico + 1
            WHERE matric_tec = v_matric_tec
              AND kpi_sequencial = v_kpi_sequencial
              AND data_registro = CURDATE(); -- Se o KPI for por dia, por exemplo

            -- Se não atualizou nenhuma linha (ou seja, não existe registro para hoje), insere
            IF ROW_COUNT() = 0 THEN
                INSERT INTO VALOR_KPI (matric_tec, kpi_sequencial, data_registro, valor_kpi_numerico)
                VALUES (v_matric_tec, v_kpi_sequencial, CURDATE(), 1);
            END IF;
        END IF;
    END IF;
END //

DELIMITER ;

-- início teste trigger kpi

SELECT * FROM VALOR_KPI WHERE matric_tec = 101 AND kpi_sequencial = 2;

UPDATE SERVICO
SET status = 'Concluído'
WHERE num_serv = 1;

SELECT * FROM SERVICO WHERE num_serv = 1

-- fim do teste trigger kpi


-- Trigger para atualizar dt_Devida

DELIMITER ;

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
