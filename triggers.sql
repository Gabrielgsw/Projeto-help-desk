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
