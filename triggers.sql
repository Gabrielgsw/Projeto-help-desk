USE help_desk;
DELIMITER $$

CREATE TRIGGER trigger_atribuir_chamado -- atribuir um chamado a um técnico existente
BEFORE INSERT ON Chamado
FOR EACH ROW
BEGIN
    DECLARE id_tecnico INT;
    
    SELECT tecnico_id INTO id_tecnico
    FROM Tecnico
    WHERE usuario_id = 2 LIMIT 1; 
        
    IF NEW.tecnico_id IS NULL THEN
        SET NEW.tecnico_id = id_tecnico;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trigger_historico_chamado -- adicionar um chamado ao histórico de chamados
AFTER INSERT ON Chamado
FOR EACH ROW
BEGIN
    INSERT INTO Historico (chamado_id, descricao, data_alteracao)
    VALUES (
        NEW.chamado_id,
        CONCAT('Chamado adicionado: "', NEW.titulo, '"'),
        NOW()
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trigger_atualizar_numero_funcionarios
AFTER INSERT ON Departamento
FOR EACH ROW
BEGIN
    DECLARE num_funcionarios INT;

    SELECT COUNT(*) INTO num_funcionarios
    FROM Usuario
    WHERE departamento_id = NEW.departamento_id;

    UPDATE Departamento
    SET numero_funcionarios = num_funcionarios
    WHERE departamento_id = NEW.departamento_id;
END$$


DELIMITER ;

DELIMITER $$

CREATE TRIGGER set_sla_automatica
BEFORE INSERT ON Chamado
FOR EACH ROW
BEGIN
    IF NEW.sla_id IS NULL THEN
        -- Supondo que cada tipo de serviço tem um SLA padrão
        SET NEW.sla_id = (
            SELECT MIN(sla_id)
            FROM SLA
            WHERE tempo_resposta <= 60 AND tempo_solucao <= 240
            LIMIT 1
        );
    END IF;
END$$

DELIMITER ;



