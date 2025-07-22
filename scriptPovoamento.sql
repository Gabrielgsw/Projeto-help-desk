USE help_desk;

-- Estado, Cidade e Bairro
INSERT INTO Estado (nome, sigla) VALUES ('Pernambuco', 'PE');
INSERT INTO Estado (nome, sigla) VALUES ('Rio de Janeiro', 'RJ');
INSERT INTO Estado (nome, sigla) VALUES ('São Paulo', 'SP');

INSERT INTO Cidade (nome, estado_id) VALUES 
('Recife', 1),
('Olinda', 1), 
('Caruaru', 1), 
('Niterói', 2),        
('Rio de Janeiro', 2), 
('Petrópolis', 2), 
('Campinas', 3),
('São Paulo', 3), 
('Santos', 3); 

INSERT INTO Bairro (nome, cidade_id) VALUES 
('Arruda', 1), 
('Boa Viagem', 1), 
('Casa Amarela', 1);

INSERT INTO Bairro (nome, cidade_id) VALUES 
('Icaraí', 4), 
('Centro', 4), 
('Santa Rosa', 4);

INSERT INTO Bairro (nome, cidade_id) VALUES 
('Cambuí', 7), 
('Barão Geraldo', 7), 
('Centro', 7);

-- Logradouro e Empresa
INSERT INTO Logradouro (rua, numero, bairro_id) VALUES ('Rua das Flores', '456', 1),  
('Avenida Central', '789', 4), 
('Rua do Comércio', '321', 7); 

INSERT INTO EmpresaSolicitante (nome, cnpj, logradouro_id) VALUES 
('Tech Solutions', '23456789000188', 1),
('Inova Sistemas', '34567890000177', 3),
('Alpha Tecnologia', '45678900000166', 2); 

-- Usuários
INSERT INTO Usuario (nome, email, senha, telefone, data_cadastro) VALUES 
('João Silva', 'joao@email.com', '1234', '999999999', CURDATE()),
('Maria Oliveira', 'maria@email.com', 'abcd', '988888888', CURDATE()),
('Carlos Mendes', 'carlos@email.com', 'efgh', '977777777', CURDATE()),
('Fernanda Lima', 'fernanda@email.com', 'ijkl', '966666666', CURDATE());


INSERT INTO PermissaoUsuario (usuario_id, descricao, nivel_acesso) VALUES (1, 'Administrador', 10),
(2, 'Usuário Comum', 1),
(3, 'Solicitante', 2),
(4, 'Técnico', 5);


-- Solicitante e Técnico
INSERT INTO Solicitante (usuario_id, empresa_id) VALUES (1, 1);
INSERT INTO Solicitante (usuario_id, empresa_id) VALUES (2, 2);
INSERT INTO Solicitante (usuario_id, empresa_id) VALUES (3, 3);


INSERT INTO Cargo (nome, descricao) VALUES ('Analista', 'Responsável por suporte');
INSERT INTO Departamento (nome, descricao) VALUES ('TI', 'Tecnologia da Informação');
INSERT INTO AreaAtuacao (descricao) VALUES ('Infraestrutura');

INSERT INTO Tecnico (usuario_id, cargo_id, departamento_id, area_atuacao_id)
VALUES (1, 1, 1, 1);

-- Serviços e SLA
INSERT INTO TipoServico (nome) VALUES ('Manutenção');
INSERT INTO SubtipoServico (tipo_servico_id, nome) VALUES (1, 'Reparo de impressora');

INSERT INTO SLA (tempo_resposta, tempo_solucao) VALUES (60, 240);
INSERT INTO SLA (tempo_resposta, tempo_solucao) VALUES (30, 120); -- Este pode ter ID 2
INSERT INTO SLA (tempo_resposta, tempo_solucao) VALUES (120, 480); -- Este pode ter ID 3

INSERT INTO StatusChamado (descricao) VALUES ('Aberto'),('Em espera'),('Em andamento'),('Fechado');

-- Chamado
INSERT INTO Chamado (titulo, descricao, data_abertura, status_id, sla_id, tipo_servico_id, subtipo_id, solicitante_id, tecnico_id)
VALUES ('Impressora não funciona', 'A impressora do setor está com erro.', CURDATE(), 1, 1, 1, 1, 1, 1),
('Internet lenta', 'Conexão muito lenta na sala de reuniões.', CURDATE(), 1, 1, 1, 1, 1, 1), 
('Monitor piscando', 'Monitor está com oscilação na imagem.', CURDATE(), 1, 1, 1, 1, 1, 1),
('Computador não liga', 'O equipamento não está iniciando.', CURDATE(), 1, 1, 1, 1, 1, 1),
('Erro no sistema ERP', 'Mensagem de erro ao tentar gerar relatório.', CURDATE(), 2, 1, 1, 1, 1, 1),
('Problema com e-mail', 'Usuário não consegue acessar e-mails.', CURDATE(), 3, 1, 1, 1, 1, 1),
('Impressora sem conexão', 'A impressora não aparece na rede.', CURDATE(), 1, 1, 1, 1, 1, 1),
('Lentidão na rede', 'Rede muito lenta no setor financeiro.', CURDATE(), 2, 1, 1, 1, 1, 1),
('Troca de monitor', 'Monitor com imagem tremida, precisa troca.', CURDATE(), 1, 1, 1, 1, 1, 1),
('Instalação de software', 'Solicitação para instalar antivírus.', CURDATE(), 3, 1, 1, 1, 1, 1),
('Atualização de sistema', 'Solicitação de update do Windows.', CURDATE(), 2, 1, 1, 1, 1, 1),
('Problema com teclado', 'Teclado com falhas nas teclas.', CURDATE(), 1, 1, 1, 1, 1, 1);  



-- Feedback
INSERT INTO Feedback (nota, comentario, data_feedback, chamado_id) VALUES ( 10, 'Ótimo atendimento!', '2025-06-24', 3),( 7, 'Atendente demorou a responder', '2025-06-25', 1),(9, 'Rápido e eficiente', '2025-06-26', 2),
(8, 'Problema resolvido, mas levou algum tempo.', '2025-06-27', 4),
(10, 'Atendimento excelente, técnico muito educado.', '2025-06-28', 5),
(6, 'Resolveram, mas tive que ligar duas vezes.', '2025-06-29', 6);


-- Historico
INSERT INTO Historico (chamado_id, descricao, data_alteracao)
VALUES (1, 'Status alterado de Aberto para Em Atendimento.', NOW()),
(2, 'Chamado atribuído ao técnico.', NOW()),
(3, 'Status alterado de Em espera para Em andamento.', NOW()),
(4, 'Chamado encerrado com sucesso.', NOW());

-- Auditoria

INSERT INTO Auditoria (chamado_id, usuario_id, acao, data_acao)
VALUES (1, 2, 'Atualizou status do chamado.', NOW());

-- Log

INSERT INTO LogAtividades (auditoria_id, descricao, data)
VALUES (1, 'Troca de cabo de energia', NOW());

-- Tempo de atividade

INSERT INTO TempoAtividade (log_id, tempo_gasto)
VALUES (1, 35); -- tempo em minutos

-- Base de conhecimento
INSERT INTO BaseConhecimento (titulo, conteudo, tecnico_id)
VALUES ('Computador não liga - solução comum', 'Verificar cabo, fonte e botão de energia.', 1);

-- PALAVRA-CHAVE
INSERT INTO PalavraChave (base_id, palavra)
VALUES (1, 'energia'), (1, 'computador'), (1, 'hardware');