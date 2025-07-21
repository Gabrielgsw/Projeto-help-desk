-- Listar as empresas e seus solicitantes
DELIMITER $$
CREATE PROCEDURE ListarEmpresasESolicitantes()
BEGIN
    SELECT e.nome AS empresa, u.nome AS solicitante, u.email
    FROM EmpresaSolicitante e
    JOIN Solicitante s ON e.empresa_id = s.empresa_id
    JOIN Usuario u ON s.usuario_id = u.usuario_id;
END$$
DELIMITER ;

-- Fechar um chamado quando for igual a fechado
DELIMITER $$
CREATE PROCEDURE FecharChamado(IN p_chamado_id INT)
BEGIN
    DECLARE v_status_id INT;

    -- Busca o ID do status 'Fechado'
    SELECT status_id INTO v_status_id
    FROM StatusChamado
    WHERE descricao = 'Fechado'
    LIMIT 1;

    -- Atualiza o chamado apenas se o status atual for 'Fechado'
    UPDATE Chamado
    SET data_encerramento = CURDATE()
    WHERE chamado_id = p_chamado_id
      AND status_id = v_status_id;
END$$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CriarChamado(
    IN p_titulo VARCHAR(100),
    IN p_descricao TEXT,
    IN p_status_id INT,
    IN p_sla_id INT,
    IN p_tipo_servico_id INT,
    IN p_subtipo_id INT,
    IN p_solicitante_id INT,
    IN p_tecnico_id INT
)
BEGIN
    INSERT INTO Chamado (
        titulo,
        descricao,
        data_abertura,
        status_id,
        sla_id,
        tipo_servico_id,
        subtipo_id,
        solicitante_id,
        tecnico_id
    )
    VALUES (
        p_titulo,
        p_descricao,
        CURDATE(),
        p_status_id,
        p_sla_id,
        p_tipo_servico_id,
        p_subtipo_id,
        p_solicitante_id,
        p_tecnico_id
    );
END$$

DELIMITER ;

-- Remover um chamado do sistema
DELIMITER $$
CREATE PROCEDURE RemoverChamado(IN p_chamado_id INT)
BEGIN
    DELETE FROM Feedback WHERE chamado_id = p_chamado_id;
    DELETE FROM Historico WHERE chamado_id = p_chamado_id;
    DELETE FROM Auditoria WHERE chamado_id = p_chamado_id;
    DELETE FROM Comentario WHERE chamado_id = p_chamado_id;
    DELETE FROM Chamado WHERE chamado_id = p_chamado_id;
END$$
DELIMITER ;

-- Buscar na base de conhecimento por uma palavra chave
DELIMITER $$
CREATE PROCEDURE BuscarBasePorPalavra(IN palavra_busca VARCHAR(100))
BEGIN
    SELECT b.titulo, b.conteudo
    FROM BaseConhecimento b
    JOIN PalavraChave p ON b.base_id = p.base_id
    WHERE p.palavra = palavra_busca;
END$$
DELIMITER ;

-- Atualizar o status de um chamado
DELIMITER $$
CREATE PROCEDURE AtualizarStatusChamado(
    IN id_chamado INT,
    IN novo_status_id INT,
    IN descricao_historico TEXT
)
BEGIN
    UPDATE Chamado
    SET status_id = novo_status_id
    WHERE chamado_id = id_chamado;

    INSERT INTO Historico (chamado_id, descricao, data_alteracao)
    VALUES (id_chamado, descricao_historico, NOW());
END$$
DELIMITER ;

-- Listar os chamados de acordo com o solicitante que deseja
DELIMITER $$
CREATE PROCEDURE ListarChamadosPorSolicitante(IN id_solicitante INT)
BEGIN
    SELECT c.chamado_id, c.titulo, c.data_abertura, s.descricao AS status
    FROM Chamado c
    JOIN StatusChamado s ON c.status_id = s.status_id
    WHERE c.solicitante_id = id_solicitante;
END$$
DELIMITER ;

-- Editar um usuário no nosso sistema
DELIMITER $$
CREATE PROCEDURE EditarUsuario(
    IN id_usuario INT,
    IN novo_nome VARCHAR(100),
    IN novo_email VARCHAR(100),
    IN nova_senha VARCHAR(100),
    IN novo_telefone VARCHAR(15)
)
BEGIN
    UPDATE Usuario
    SET 
        nome = novo_nome,
        email = novo_email,
        senha = nova_senha,
        telefone = novo_telefone
    WHERE usuario_id = id_usuario;
END$$
DELIMITER ;

-- Adicionar um usuário no nosso sistema
DELIMITER $$
CREATE PROCEDURE InserirUsuarioNoSistema(
    IN nome_ VARCHAR(100),
    IN email_ VARCHAR(100),
    IN senha_ VARCHAR(100),
    IN telefone_ VARCHAR(15)
)
BEGIN
    INSERT INTO Usuario (nome, email, senha, telefone, data_cadastro)
    VALUES (nome_, email_, senha_, telefone_, CURDATE());
END$$
DELIMITER ;

-- Remover um usuário no nosso sistema
DELIMITER $$
CREATE PROCEDURE RemoverUsuario(IN id_usuario INT)
BEGIN
    DELETE FROM Usuario WHERE usuario_id = id_usuario;
END$$
DELIMITER ;

-- listar um chamado no nosso sistema baseado no seu status se quiser todos os chamados status x
DELIMITER $$
CREATE PROCEDURE ListarChamadosPorStatus(IN status_nome VARCHAR(50))
BEGIN
    SELECT c.chamado_id, c.titulo, s.descricao AS status
    FROM Chamado c
    JOIN StatusChamado s ON c.status_id = s.status_id
    WHERE s.descricao = status_nome;
END$$
DELIMITER ;




