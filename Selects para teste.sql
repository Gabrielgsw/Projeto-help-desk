-- Selects para teste

-- Registrar um chamado:
INSERT INTO Chamado (titulo, descricao, data_abertura, status_id, sla_id, tipo_servico_id, subtipo_id, solicitante_id, tecnico_id)
VALUES ('Sistema com erro', 'Meu sistema está com erro quando tento abrir o aplicativo da empresa.', CURDATE(), 1, 1, 1, 1, 1, NULL);


-- Enviar um comentário:
INSERT INTO Comentario (chamado_id, usuario_id, conteudo, data_comentario)
VALUES (5, 1, 'Primeiro comentário do João como cliente.', NOW());

-- Dar Feedback para um chamado
INSERT INTO Feedback (chamado_id, nota, comentario, data_feedback)
VALUES (1, 9, 'Gostei do atendimento.', NOW());


SELECT * FROM Chamado;

SELECT chamado_id, titulo, sla_id 
FROM Chamado
ORDER BY chamado_id DESC
LIMIT 5;


-- Consultar os dados
SELECT * FROM Usuario WHERE usuario_id = 3;

-- Consultar a base de conhecimento
SELECT * FROM BaseConhecimento;

-- SELECTS PARA USO GERAL
-- Seleção para a tabela Estado
SELECT * FROM Estado;
SELECT nome, sigla FROM Estado WHERE sigla = 'PE';

-- Seleção para a tabela Cidade
SELECT * FROM Cidade;
SELECT nome FROM Cidade WHERE estado_id = 1;
SELECT cidade_id, nome, estado_id FROM Cidade ORDER BY nome LIMIT 2;

-- Seleção para a tabela Bairro
SELECT * FROM Bairro;
SELECT nome FROM Bairro WHERE cidade_id = 1;
SELECT bairro_id, nome FROM Bairro WHERE nome LIKE '%Centro%';

-- Seleção para a tabela Logradouro
SELECT * FROM Logradouro;
SELECT rua, numero FROM Logradouro WHERE bairro_id = 1;

-- Seleção para a tabela EmpresaSolicitante
SELECT * FROM EmpresaSolicitante;
SELECT nome, cnpj FROM EmpresaSolicitante WHERE empresa_id = 1;

-- Seleção para a tabela Usuario
SELECT * FROM Usuario;
SELECT nome, email, telefone FROM Usuario WHERE data_cadastro = CURDATE();
SELECT usuario_id, nome FROM Usuario ORDER BY nome ASC LIMIT 2;

-- Seleção para a tabela PermissaoUsuario
SELECT * FROM PermissaoUsuario;
SELECT descricao, nivel_acesso FROM PermissaoUsuario WHERE usuario_id = 1;

-- Seleção para a tabela Solicitante
SELECT * FROM Solicitante;
SELECT usuario_id, empresa_id FROM Solicitante WHERE solicitante_id = 1;

-- Seleção para a tabela Cargo
SELECT * FROM Cargo;
SELECT nome FROM Cargo WHERE cargo_id = 1;

-- Seleção para a tabela Departamento
SELECT * FROM Departamento;
SELECT nome, descricao FROM Departamento WHERE departamento_id = 1;

-- Seleção para a tabela AreaAtuacao
SELECT * FROM AreaAtuacao;
SELECT descricao FROM AreaAtuacao WHERE area_atuacao_id = 1;

-- Seleção para a tabela Tecnico
SELECT * FROM Tecnico;
SELECT usuario_id, departamento_id FROM Tecnico WHERE tecnico_id = 1;

-- Seleção para a tabela TipoServico
SELECT * FROM TipoServico;
SELECT nome FROM TipoServico WHERE tipo_servico_id = 1;

-- Seleção para a tabela SubtipoServico
SELECT * FROM SubtipoServico;
SELECT nome FROM SubtipoServico WHERE tipo_servico_id = 1;

-- Seleção para a tabela SLA
SELECT * FROM SLA;
SELECT tempo_resposta, tempo_solucao FROM SLA WHERE sla_id = 1;

-- Seleção para a tabela StatusChamado
SELECT * FROM StatusChamado;
SELECT descricao FROM StatusChamado WHERE status_id = 1;
SELECT * FROM StatusChamado ORDER BY status_id DESC;

-- Seleção para a tabela Chamado
SELECT * FROM Chamado;
SELECT titulo, data_abertura, status_id FROM Chamado WHERE solicitante_id = 1;
SELECT chamado_id, titulo, descricao FROM Chamado WHERE status_id = 1 ORDER BY data_abertura DESC;

-- Seleção para a tabela Comentario
SELECT * FROM Comentario;
SELECT conteudo, data_comentario FROM Comentario WHERE chamado_id = 1;

-- Seleção para a tabela Feedback
SELECT * FROM Feedback;
SELECT nota, comentario FROM Feedback WHERE chamado_id = 3;
SELECT chamado_id, nota FROM Feedback WHERE nota >= 8;

-- Seleção para a tabela Historico
SELECT * FROM Historico;
SELECT descricao, data_alteracao FROM Historico WHERE chamado_id = 1;

-- Seleção para a tabela Auditoria
SELECT * FROM Auditoria;
SELECT acao, data_acao FROM Auditoria WHERE usuario_id = 2;

-- Seleção para a tabela LogAtividades
SELECT * FROM LogAtividades;
SELECT descricao, data FROM LogAtividades WHERE auditoria_id = 1;

-- Seleção para a tabela TempoAtividade
SELECT * FROM TempoAtividade;
SELECT tempo_gasto FROM TempoAtividade WHERE log_id = 1;

-- Seleção para a tabela BaseConhecimento
SELECT * FROM BaseConhecimento;
SELECT titulo, conteudo FROM BaseConhecimento WHERE tecnico_id = 1;

-- Seleção para a tabela PalavraChave
SELECT * FROM PalavraChave;
SELECT palavra FROM PalavraChave WHERE base_id = 1;


-- Selects para funções

-- Listar a quantidade de chamados por empresa 
SELECT QtdChamadosPorEmpresa(1) AS total_chamados_empresa1;

-- tempo total de atividade por chamado
SELECT TempoTotalAtividadePorChamado(1) AS tempo_total_minutos;

-- baseado nas funções, criar um chamado e tentar, com essa função, filtrar a quantidade de chamado por status
SELECT QtdChamadosPorStatus('Aberto') AS chamados_abertos;



