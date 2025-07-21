USE help_desk;
-- Aqui nessa função, retorna a quantidade de chamados por empresa, ou seja, basicamente passamos o id da empresa, e ele retorna a quantidade de chamados.
DELIMITER $$

CREATE FUNCTION QtdChamadosPorEmpresa(p_empresa_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_chamados INT;

    SELECT COUNT(*) INTO total_chamados
    FROM Chamado c
    JOIN Solicitante s ON c.solicitante_id = s.solicitante_id
    WHERE s.empresa_id = p_empresa_id;

    RETURN total_chamados;
END$$

DELIMITER ;

-- retorna o tempo total gasto em atividades registradas para um chamado, passando o id dele
DELIMITER $$

CREATE FUNCTION TempoTotalAtividadePorChamado(p_chamado_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_tempo INT;

    SELECT SUM(t.tempo_gasto) INTO total_tempo
    FROM TempoAtividade t
    JOIN LogAtividades l ON t.log_id = l.log_id
    JOIN Auditoria a ON l.auditoria_id = a.auditoria_id
    WHERE a.chamado_id = p_chamado_id;

    RETURN IFNULL(total_tempo, 0);
END$$

DELIMITER ;

-- quantidade de chamado por status
DELIMITER $$

CREATE FUNCTION QtdChamadosPorStatus(p_status_nome VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE qtd INT;

    SELECT COUNT(*) INTO qtd
    FROM Chamado c
    JOIN StatusChamado s ON c.status_id = s.status_id
    WHERE s.descricao = p_status_nome;

    RETURN qtd;
END$$

DELIMITER ;



