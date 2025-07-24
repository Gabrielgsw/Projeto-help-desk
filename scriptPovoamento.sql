USE HelpDesk;

-- Desabilita a verificação de chaves estrangeiras temporariamente.
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- População da Tabela UNIDADE_SUPORTE
-- -----------------------------------------------------
INSERT INTO UNIDADE_SUPORTE (CNPJ, estado, endereco, nome, Matriz, razao_social, NroFuncionarios) VALUES
('00.000.000/0001-00', 'Recife', 'Rua do Bom Jesus, 10, Centro', 'HelpDesk Recife Storm', TRUE, 'HelpDesk Soluções Ltda.', 5),
('00.000.000/0002-00', 'São Paulo', 'Av. Paulista, 1500, Bela Vista', 'HelpDesk SãoPaulo Storm', FALSE, 'HelpDesk Soluções Ltda.', 10);

-- -----------------------------------------------------
-- População da Tabela CLIENTE_PJ
-- -----------------------------------------------------
INSERT INTO CLIENTE_PJ (cod, prioridade, endereco, estado, fone, email, cnpj, razao_social) VALUES
(1, 'Alta', 'Av. Boa Viagem, 100, Boa Viagem', 'Recife', '81999990001', 'contato@empresaA.com.br', '11.111.111/0001-11', 'Empresa A Soluções Digitais Ltda.'),
(2, 'Média', 'Rua Augusta, 52, Consolação', 'São Paulo', '11988880002', 'sac@empresaB.com.br', '22.222.222/0001-22', 'Empresa B Consultoria S.A.'),
(3, 'Baixa', 'Rua Copacabana, 34, Copacabana', 'Rio de Janeiro', '21977770003', 'atendimento@empresaC.com.br', '33.333.333/0001-33', 'Empresa C Serviços LTDA'),
(4, 'Alta', 'Av. Afonso Pena, 100, Centro', 'Belo Horizonte', '31966660004', 'info@empresaD.com.br', '44.444.444/0001-44', 'Empresa D Tecnologia S.A.'),
(5, 'Média', 'Rua 7 de Setembro, 123, Centro', 'Porto Alegre', '51955550005', 'comercial@empresaE.com.br', '55.555.555/0001-55', 'Empresa E Software Ltda.'),
(6, 'Alta', 'Rua XV de Novembro, 200, Centro', 'Curitiba', '41944440006', 'suporte@empresaF.com.br', '66.666.666/0001-66', 'Empresa F Soluções em TI Ltda.'),
(7, 'Baixa', 'Av. Beira Mar, 50, Centro', 'Florianópolis', '48933330007', 'vendas@empresaG.com.br', '77.777.777/0001-77', 'Empresa G Consultoria e Sistemas S.A.');

-- -----------------------------------------------------
-- População da Tabela SUPERVISOR
-- -----------------------------------------------------
INSERT INTO SUPERVISOR (Matricula, login, senha, nome, CPF, email, carga_horaria, unidade) VALUES
(1, 'supervisorA.storm', 'senha123', 'Bryan Luna', '111.111.111-11', 'bryan.luna@helpstorm.com', 40, '00.000.000/0001-00'),
(2, 'supervisorB.storm', 'senha456', 'Erick Santos', '222.222.222-22', 'erick.santos@helpstorm.com', 40, '00.000.000/0002-00');

-- -----------------------------------------------------
-- População da Tabela TECNICO
-- -----------------------------------------------------
INSERT INTO TECNICO (Matricula, login, senha, nome, CPF, email, carga_horaria, no_consertos, dias_trabalhados, no_voltas, matric_supervisor, data_inicio, unidade) VALUES
(101, 'tec.joao', 'tec123', 'João Pereira', '333.333.333-33', 'joao.pereira@helpstorm.com', 40, 15, 200, 2, 1, '2023-02-15', '00.000.000/0001-00'),
(102, 'tec.maria', 'tec456', 'Maria Oliveira', '444.444.444-44', 'maria.oliveira@helpstorm.com', 40, 20, 220, 1, 1, '2024-05-17', '00.000.000/0001-00'),
(103, 'tec.pedro', 'tec789', 'Pedro Santos', '555.555.555-55', 'pedro.santos@helpstorm.com', 40, 10, 180, 0, 2, '2024-08-13', '00.000.000/0002-00'),
(104, 'tec.ana', 'tec010', 'Ana Costa', '666.666.666-66', 'ana.costa@helpstorm.com', 40, 12, 190, 1, 1, '2024-01-12', '00.000.000/0002-00');

-- -----------------------------------------------------
-- População da Tabela KPI
-- -----------------------------------------------------
INSERT INTO KPI (matric_tec, Sequencial, KPI_1, dsc_KPI_1, KPI_2, dsc_KPI_2) VALUES
(101, 1, 'Tempo Médio de Resposta', 'Média de tempo para primeira resposta', 'Taxa de Resolução', 'Porcentagem de chamados resolvidos'),
(102, 1, 'Satisfação do Cliente', 'Pesquisa de nível de satisfação pós-atendimento', 'Tempo Médio de Atendimento', 'Média de tempo para fechar um chamado'),
(101, 2, 'Chamados Fechados', 'Número de chamados fechados pelo técnico', 'Taxa de Reabertura', 'Porcentagem de chamados reabertos após fechamento'),
(104, 1, 'Produtividade Diária', 'Número de chamados resolvidos por dia', 'Qualidade do Atendimento', 'Avaliação média dos clientes'),
(103, 1, 'Eficiência de Resolução', 'Percentual de chamados resolvidos no primeiro contato', 'Conformidade com SLAs', 'Percentual de chamados atendidos dentro do SLA');

-- -----------------------------------------------------
-- População da Tabela FATURA
-- -----------------------------------------------------
INSERT INTO FATURA (cod, n_parcelas, data_emissao, valor_total, status, cod_cliente_pj) VALUES
(1, 3, '2024-06-01', 1500.00, 'Aberta', 1),
(2, 1, '2024-05-15', 500.00, 'Paga', 2),
(3, 2, '2024-07-05', 750.00, 'Aberta', 3),
(4, 4, '2024-06-20', 2000.00, 'Aberta', 4),
(5, 1, '2024-07-01', 300.00, 'Paga', 5),
(6, 3, '2024-07-10', 1200.00, 'Aberta', 6),
(7, 2, '2024-06-25', 900.00, 'Atrasada', 7);

SELECT * FROM KPI;
SELECT * FROM FATURA;
SELECT * FROM SUPERVISOR;
SELECT * FROM TECNICO;
SELECT * FROM CLIENTE_PJ;