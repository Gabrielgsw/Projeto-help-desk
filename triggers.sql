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
