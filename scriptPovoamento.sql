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

-- -----------------------------------------------------
-- População da Tabela PARCELA_FATURA
-- -----------------------------------------------------
INSERT INTO PARCELA_FATURA (cod_fatura, numero_parcela, valor_parcela, data_vencimento, data_pagamento, status_parcela) VALUES
(1, 1, 500.00, '2025-07-01', NULL, 'Paga'),
(1, 2, 500.00, '2025-08-01', NULL, 'Aberta'),
(1, 3, 500.00, '2025-09-01', NULL, 'Aberta'),
(2, 1, 500.00, '2025-05-15', '2024-05-10', 'Paga'),
(3, 1, 375.00, '2025-08-05', NULL, 'Aberta'),
(3, 2, 375.00, '2025-09-05', NULL, 'Aberta'),
(4, 1, 500.00, '2025-07-26', NULL, 'Aberta'),
(4, 2, 500.00, '2025-08-20', NULL, 'Aberta'),
(4, 3, 500.00, '2025-09-20', NULL, 'Aberta'),
(4, 4, 500.00, '2025-10-20', NULL, 'Aberta'),
(5, 1, 300.00, '2025-07-01', '2024-06-28', 'Paga'),
(6, 1, 400.00, '2025-08-10', NULL, 'Aberta'),
(6, 2, 400.00, '2025-09-10', NULL, 'Aberta'),
(6, 3, 400.00, '2025-10-10', NULL, 'Aberta'),
(7, 1, 450.00, '2024-07-23', NULL, 'Atrasada'), -- Considerando que hoje é 24 de julho de 2025, esta parcela está atrasada
(7, 2, 450.00, '2025-08-25', NULL, 'Aberta');

-- -----------------------------------------------------
-- População da Tabela CHAMADO
-- -----------------------------------------------------
INSERT INTO CHAMADO (Seq, Prioridade, Complexidade, descricao, status, tipo, cod_plano, mat_supervisor, mat_tec, cod_cliente_pj, data) VALUES
(1, 'Alta', 'Média', 'Problema de conexão com a rede principal.', 'Em demanda', 'Rede', 'PLANO_EMP_A_01', 1, 101, 1, '2025-07-20'),
(2, 'Média', 'Baixa', 'Instalação de novo software de gestão.', 'Pendente', 'Software', 'PLANO_EMP_B_01', 1, 102, 2, '2025-07-22'),
(3, 'Baixa', 'Média', 'Manutenção preventiva em servidores.', 'Resolvido', 'Hardware', 'PLANO_EMP_C_01', 2, 103, 3, '2025-07-18'),
(4, 'Alta', 'Alta', 'Falha crítica no sistema de backup.', 'Em demanda', 'Segurança', 'PLANO_EMP_D_01', 2, 104, 4, '2025-07-23'),
(5, 'Média', 'Baixa', 'Configuração de impressora de rede.', 'Pendente', 'Periféricos', 'PLANO_EMP_E_01', 1, 101, 5, '2025-07-24'),
(6,'Alta', 'Média', 'Servidor de arquivos apresentando lentidão excessiva.', 'Pendente', 'Hardware', 'PLANO_EMP_B_02', 2, 103, 2, '2025-07-24'),
(7,'Baixa', 'Baixa', 'Instalação de pacote Office para novo funcionário.', 'Resolvido', 'Software', 'PLANO_EMP_C_02', 1, 102, 3, '2025-07-23'),
(8,'Alta', 'Alta', 'Ataque de ransomware detectado em estação de trabalho.', 'Em demanda', 'Segurança', 'PLANO_EMP_D_02', 2, 104, 4, '2025-07-24'),
(9,'Média', 'Média', 'Impressora de produção não reconhecida na rede.', 'Em demanda', 'Periféricos', 'PLANO_EMP_E_02', 1, 101, 5, '2025-07-24'),
(10,'Baixa', 'Baixa', 'Solicitação de nova conta de e-mail.', 'Pendente', 'Software', 'PLANO_EMP_F_01', 2, 103, 6, '2025-07-23'),
(11,'Média', 'Alta', 'Falha no backup diário do banco de dados.', 'Em demanda', 'Dados', 'PLANO_EMP_G_01', 1, 102, 7, '2025-07-24'),
(12,'Alta', 'Média', 'Tela azul em computador do setor de engenharia.', 'Pendente', 'Hardware', 'PLANO_EMP_A_03', 1, 101, 1, '2025-07-24'),
(13,'Média', 'Baixa', 'Erro ao abrir aplicativo específico de vendas.', 'Resolvido', 'Software', 'PLANO_EMP_B_03', 2, 104, 2, '2025-07-22'),
(14,'Baixa', 'Média', 'Configuração de VPN para acesso remoto.', 'Em demanda', 'Rede', 'PLANO_EMP_C_03', 1, 103, 3, '2025-07-24'),
(15,'Alta', 'Alta', 'Servidor web offline, site indisponível.', 'Em demanda', 'Servidor', 'PLANO_EMP_D_03', 2, 104, 4, '2025-07-24'),
(16,'Média', 'Baixa', 'Teclado e mouse sem fio não funcionam.', 'Pendente', 'Periféricos', 'PLANO_EMP_E_03', 1, 101, 5, '2025-07-24');

-- -----------------------------------------------------
-- População da Tabela ORCAMENTO
-- -----------------------------------------------------
INSERT INTO ORCAMENTO (cod, data_abertura, dt_emissao, descricao, validade_n_dias, ultima_data) VALUES
(1, '2024-07-10', '2024-07-12', 'Orçamento para substituição de hardware de servidor.', 30, '2024-07-12'),
(2, '2024-07-15', '2024-07-16', 'Orçamento para upgrade de sistema operacional.', 15, '2024-07-16'),
(3, '2024-07-20', '2024-07-21', 'Orçamento para consultoria de segurança de rede.', 45, '2024-07-21'),
(4,'2025-07-07', '2025-07-08', 'Orçamento para consultoria de otimização de banco de dados.', 30, '2025-07-08'),
(5,'2025-07-09', '2025-07-10', 'Orçamento para substituição de 5 computadores antigos.', 20, '2025-07-10'),
(6,'2025-07-11', '2025-07-12', 'Orçamento para contrato de manutenção preventiva mensal de servidores.', 90, '2025-07-12'),
(7,'2025-07-13', '2025-07-14', 'Orçamento para treinamento de equipe em nova ferramenta de gestão.', 25, '2025-07-14'),
(8,'2025-07-15', '2025-07-16', 'Orçamento para instalação de sistema de vigilância por câmeras IP.', 60, '2025-07-16'),
(9,'2025-07-17', '2025-07-18', 'Orçamento para upgrade de roteador principal da rede.', 30, '2025-07-18'),
(10,'2025-07-19', '2025-07-20', 'Orçamento para desenvolvimento de aplicação web personalizada.', 120, '2025-07-20'),
(11,'2025-07-21', '2025-07-22', 'Orçamento para consultoria de segurança da informação e pentest.', 45, '2025-07-22'),
(12,'2025-07-23', '2025-07-24', 'Orçamento para implementação de solução de VoIP.', 90, '2025-07-24'),
(13,'2025-07-25', '2025-07-26', 'Orçamento para compra e instalação de nobreak para sala de servidores.', 30, '2025-07-26'),
(14,'2025-07-27', '2025-07-28', 'Orçamento para serviço de migração de e-mails para nova plataforma.', 20, '2025-07-28'),
(15,'2025-07-29', '2025-07-30', 'Orçamento para auditoria de rede e segurança interna.', 40, '2025-07-30');

-- -----------------------------------------------------
-- População da Tabela ORDEM_SERVICO
-- -----------------------------------------------------
INSERT INTO ORDEM_SERVICO (status, data_criacao, prazo_em_dias, dt_devida, cod_orcamento, cod_fatura, cod_chamado) VALUES
('Em Andamento', '2025-07-21', 5, '2025-07-26', 1, 1, 1), -- Chamado 1: Problema de conexão com a rede principal
('Aberta', '2025-07-23', 7, '2025-07-30', 2, 3, 2), -- Chamado 2: Instalação de novo software de gestão
('Concluída', '2025-07-19', 3, '2025-07-22', NULL, NULL, 3), -- Chamado 3: Manutenção preventiva (já resolvido, pode não ter fatura/orcamento direto)
('Em Andamento', '2025-07-24', 10, '2025-08-03', 3, NULL, 4), -- Chamado 4: Falha crítica no sistema de backup
('Aberta', '2025-07-24', 2, '2025-07-26', NULL, 5, 5), -- Chamado 5: Configuração de impressora de rede
('Em Andamento', '2025-07-25', 8, '2025-08-02', 4, NULL, 6), -- Chamado 6: Servidor de arquivos lentidão
('Concluída', '2025-07-24', 1, '2025-07-25', NULL, NULL, 7), -- Chamado 7: Instalação Office
('Aberta', '2025-07-25', 15, '2025-08-09', 5, NULL, 8), -- Chamado 8: Ataque de ransomware
('Em Andamento', '2025-07-25', 3, '2025-07-28', NULL, NULL, 9), -- Chamado 9: Impressora de produção não reconhecida
('Aberta', '2025-07-24', 2, '2025-07-26', NULL, NULL, 10), -- Chamado 10: Solicitação de nova conta de e-mail
('Em Andamento', '2025-07-25', 7, '2025-08-01', 6, NULL, 11), -- Chamado 11: Falha no backup diário
('Aberta', '2025-07-25', 4, '2025-07-29', NULL, NULL, 12), -- Chamado 12: Tela azul em computador
('Concluída', '2025-07-23', 1, '2025-07-24', NULL, NULL, 13), -- Chamado 13: Erro ao abrir aplicativo (já resolvido)
('Em Andamento', '2025-07-25', 5, '2025-07-30', NULL, NULL, 14), -- Chamado 14: Configuração de VPN
('Aberta', '2025-07-25', 12, '2025-08-06', 7, NULL, 15), -- Chamado 15: Servidor web offline
('Pendente', '2025-07-25', 3, '2025-07-28', NULL, NULL, 16); -- Chamado 16: Teclado e mouse sem fio

-- -----------------------------------------------------
-- População da Tabela TIPO_SERVICO
-- -----------------------------------------------------
INSERT INTO TIPO_SERVICO (descricao) VALUES
('Instalação de Software'),
('Manutenção Corretiva de Hardware'),
('Manutenção Preventiva de Hardware'),
('Configuração de Rede'),
('Suporte a Sistemas Operacionais'),
('Remoção de Vírus/Malware'),
('Configuração de Periféricos (Impressoras, Scanners, etc.)'),
('Recuperação de Dados'),
('Consultoria em TI'),
('Treinamento de Usuários'),
('Atualização de Software/Sistema'),
('Otimização de Desempenho (Hardware/Software)'),
('Backup e Restauração de Dados'),
('Segurança da Informação (Firewall, Antivírus)'),
('Suporte a E-mail'),
('Configuração de Acesso Remoto (VPN)');

-- -----------------------------------------------------
-- População da Tabela SERVICO
-- -----------------------------------------------------
INSERT INTO SERVICO (descricao, status, valor, cod_tipo_servico, num_serv, nivel_urgencia) VALUES
('Diagnóstico e reparo de conectividade de rede do cliente.', 'Concluído', 150.00, 4, 1, 'Alta'),   -- Referencia ORDEM_SERVICO.numero = 1 (cod_chamado 1)
('Instalação e configuração do software de gestão ERP.', 'Em Execução', 300.00, 1, 2, 'Média'),  -- Referencia ORDEM_SERVICO.numero = 2 (cod_chamado 2)
('Check-up completo em servidores, limpeza e otimização.', 'Concluído', 450.00, 3, 3, 'Baixa'),  -- Referencia ORDEM_SERVICO.numero = 3 (cod_chamado 3)
('Análise de segurança e remediação de ameaça de ransomware.', 'Pendente', 800.00, 6, 4, 'Alta'),   -- Referencia ORDEM_SERVICO.numero = 4 (cod_chamado 4)
('Configuração de drivers e ajustes na impressora de rede.', 'Concluído', 120.00, 7, 5, 'Média'),  -- Referencia ORDEM_SERVICO.numero = 5 (cod_chamado 5)
('Verificação de lentidão no servidor e otimização de recursos.', 'Em Execução', 350.00, 2, 6, 'Alta'),   -- Referencia ORDEM_SERVICO.numero = 6 (cod_chamado 6)
('Instalação do pacote Microsoft Office 365.', 'Concluído', 100.00, 1, 7, 'Baixa'),  -- Referencia ORDEM_SERVICO.numero = 7 (cod_chamado 7)
('Investigação e remoção de software malicioso.', 'Em Execução', 600.00, 6, 8, 'Alta'),   -- Referencia ORDEM_SERVICO.numero = 8 (cod_chamado 8)
('Reinstalação de drivers da impressora e testes de impressão.', 'Pendente', 180.00, 7, 9, 'Média'),  -- Referencia ORDEM_SERVICO.numero = 9 (cod_chamado 9)
('Criação e configuração de nova conta de e-mail corporativo.', 'Concluído', 80.00, 15, 10, 'Baixa'), -- Referencia ORDEM_SERVICO.numero = 10 (cod_chamado 10)
('Análise de falha no sistema de backup e restauração de dados.', 'Em Execução', 700.00, 13, 11, 'Alta'),  -- Referencia ORDEM_SERVICO.numero = 11 (cod_chamado 11)
('Diagnóstico de tela azul e testes de memória RAM.', 'Pendente', 200.00, 2, 12, 'Média'),  -- Referencia ORDEM_SERVICO.numero = 12 (cod_chamado 12)
('Reparo de erro no aplicativo de vendas e teste funcional.', 'Concluído', 250.00, 5, 13, 'Média'), -- Referencia ORDEM_SERVICO.numero = 13 (cod_chamado 13)
('Configuração de cliente VPN e testes de conexão remota.', 'Em Execução', 170.00, 16, 14, 'Média'), -- Referencia ORDEM_SERVICO.numero = 14 (cod_chamado 14)
('Diagnóstico e reativação de servidor web.', 'Pendente', 550.00, 2, 15, 'Alta'),   -- Referencia ORDEM_SERVICO.numero = 15 (cod_chamado 15)
('Testes e diagnóstico de periféricos sem fio.', 'Pendente', 90.00, 7, 16, 'Média'); -- Referencia ORDEM_SERVICO.numero = 16 (cod_chamado 16)

-- -----------------------------------------------------
-- População da Tabela CONTRATO
-- -----------------------------------------------------
INSERT INTO CONTRATO (dt_fim, status, dt_inicio, periodo_contrato_em_dias, cod_cliente_pj, cod_unidade) VALUES
('2026-12-31', 'Ativo', '2025-01-01', 730, 3, '00.000.000/0001-00'),
('2027-06-30', 'Ativo', '2025-07-01', 730, 4, '00.000.000/0002-00'),
('2025-09-30', 'Ativo', '2025-04-01', 183, 5, '00.000.000/0001-00'), 
('2028-01-31', 'Ativo', '2025-01-01', 1096, 6, '00.000.000/0002-00'),
('2026-03-31', 'Ativo', '2025-03-01', 396, 7, '00.000.000/0001-00'); 

SELECT * FROM CONTRATO;

-- -----------------------------------------------------
-- População da Tabela COMPUTADOR
-- -----------------------------------------------------
INSERT INTO COMPUTADOR (cod, estado, fabricante, data_entrada, setor, descricao, historico, bios_fabric, versao_bios, nome_so, versao_so, end_IP, tipo, cod_contrato) VALUES
(1, 'Em uso', 'Dell', '2023-05-10', 'Administrativo', 'Desktop para uso geral.', 'Manutenção preventiva em jan/2024. Troca de HD em mar/2024.', 'Phoenix', 'A12', 'Windows', '10 Pro', '192.168.1.101', 'Desktop', 7),
(2, 'Em uso', 'HP', '2023-06-20', 'Financeiro', 'Notebook para contabilidade.', 'Bateria trocada em fev/2024.', 'HP', 'F.05', 'Windows', '10 Enterprise', '192.168.1.102', 'Notebook', 7),
(3, 'Em uso', 'Lenovo', '2023-07-01', 'Desenvolvimento', 'Estação de trabalho de alta performance.', 'Instalação de RAM adicional em abr/2024.', 'Lenovo', 'L-V1.0', 'Ubuntu', '22.04 LTS', '192.168.1.103', 'Workstation', 8),
(4, 'Em uso', 'Acer', '2024-01-15', 'Vendas', 'Notebook para apresentações.', NULL, 'Acer', '1.05', 'Windows', '11 Home', '192.168.1.104', 'Notebook', 10),
(5, 'Em manutenção', 'Apple', '2024-03-01', 'Design', 'MacBook Pro para edição de vídeo.', 'Problema na tela em mai/2024.', 'Apple', '10.15', 'macOS', 'Sonoma', '192.168.1.105', 'Notebook', 8);

-- -----------------------------------------------------
-- População da Tabela IMPRESSORA
-- -----------------------------------------------------
INSERT INTO IMPRESSORA (cod, estado, fabricante, data_entrada, setor, descricao, historico, modelo, cod_contrato) VALUES
(101, 'Em uso', 'Epson', '2023-08-01', 'Administrativo', 'Impressora multifuncional a jato de tinta.', 'Manutenção de rotina em abr/2024.', 'EcoTank L3150', 7),
(102, 'Em uso', 'Brother', '2023-09-15', 'Financeiro', 'Impressora a laser colorida.', NULL, 'HL-L3270CDW', 7),
(103, 'Em uso', 'HP', '2024-02-01', 'Recepção', 'Impressora de etiquetas.', 'Troca de rolo em jun/2024.', 'LaserJet Pro M15w', 8),
(104, 'Em Manutenção', 'Samsung', '2024-04-10', 'Produção', 'Impressora de grande formato.', 'Problema de alimentação de papel.', 'MultiXpress X4300LX', 10);

-- -----------------------------------------------------
-- População da Tabela DRIVER_IMPRESSORA
-- -----------------------------------------------------
INSERT INTO DRIVER_IMPRESSORA (cod_impressora, cod_driver, Versao, Caminho) VALUES
(101, 1, '2.10', '/drivers/epson/L3150_v2.10.exe'),
(101, 2, '1.50', '/drivers/epson/L3150_scan_v1.50.zip'),
(102, 1, '3.0.1', '/drivers/brother/HL3270CDW_v3.0.1.dmg'),
(103, 1, '1.0.5', '/drivers/hp/M15w_install.exe');

-- -----------------------------------------------------
-- População da Tabela COMPONENTE
-- -----------------------------------------------------
INSERT INTO COMPONENTE (cod, onboard, tipo, modelo, fabricante) VALUES
(1, TRUE, 'Placa Mãe', 'B450 AORUS M', 'Gigabyte'),
(2, FALSE, 'Processador', 'Ryzen 5 3600', 'AMD'),
(3, FALSE, 'Memória RAM', 'HyperX Fury DDR4 16GB', 'Kingston'),
(4, FALSE, 'Placa de Vídeo', 'GeForce RTX 3060', 'NVIDIA'),
(5, FALSE, 'SSD', 'WD Black SN750 1TB', 'Western Digital'),
(6, TRUE, 'Placa de Rede', 'Intel I211-AT', 'Intel'),
(7, TRUE, 'Placa de Áudio', 'Realtek ALC1200', 'Realtek');

-- -----------------------------------------------------
-- População da Tabela DRIVER (do COMPONENTE)
-- -----------------------------------------------------
INSERT INTO DRIVER (cod_componente, Sequencial, Caminho) VALUES
(1, 1, '/drivers/motherboard/gigabyte/B450_bios_F60.zip'),
(2, 1, '/drivers/cpu/amd/chipset_drivers_v2.0.exe'),
(4, 1, '/drivers/gpu/nvidia/472.12_desktop_win10.exe'),
(5, 1, '/drivers/ssd/wd/dashboard_v3.2.exe'),
(6, 1, '/drivers/network/intel/LAN_driver_25.0.exe');

-- -----------------------------------------------------
-- População da Tabela Possui_computador_componente
-- -----------------------------------------------------
INSERT INTO Possui_computador_componente (cod_comp, cod_componente) VALUES
(1, 1), -- Desktop Dell tem Placa Mãe Gigabyte
(1, 2), -- Desktop Dell tem Processador AMD
(1, 3), -- Desktop Dell tem Memória RAM Kingston
(1, 5), -- Desktop Dell tem SSD Western Digital
(2, 6), -- Notebook HP tem Placa de Rede Intel (onboard)
(3, 1), -- Workstation Lenovo tem Placa Mãe Gigabyte (exemplo, pode variar)
(3, 2), -- Workstation Lenovo tem Processador AMD
(3, 3), -- Workstation Lenovo tem Memória RAM Kingston
(3, 4), -- Workstation Lenovo tem Placa de Vídeo NVIDIA
(3, 5); -- Workstation Lenovo tem SSD Western Digital

-- -----------------------------------------------------
-- População da Tabela Envolveu_Ordem_Servico_Computador
-- -----------------------------------------------------
INSERT INTO Envolveu_Ordem_Servico_Computador (cod_comp, cod_num_ordem) VALUES
(1, 1), -- Computador 1 envolvido na OS 1
(2, 2), -- Computador 2 envolvido na OS 2
(3, 3), -- Computador 3 envolvido na OS 3
(4, 4), -- Computador 4 envolvido na OS 4
(5, 5), -- Computador 5 envolvido na OS 5
(2, 6), -- Computador 2 envolvido na OS 6 (Exemplo de reuso)
(1, 7), -- Computador 1 envolvido na OS 7
(3, 8), -- Computador 3 envolvido na OS 8
(4, 9), -- Computador 4 envolvido na OS 9
(5, 10), -- Computador 5 envolvido na OS 10
(1, 11), -- Computador 1 envolvido na OS 11
(2, 12), -- Computador 2 envolvido na OS 12
(3, 13), -- Computador 3 envolvido na OS 13
(4, 14), -- Computador 4 envolvido na OS 14
(5, 15), -- Computador 5 envolvido na OS 15
(1, 16); -- Computador 1 envolvido na OS 16

-- -----------------------------------------------------
-- População da Tabela Envolveu_Ordem_Servico_Impressora
-- -----------------------------------------------------
INSERT INTO Envolveu_Ordem_Servico_Impressora (cod_impressora, cod_num_ordem) VALUES
(101, 5), -- Impressora 101 envolvida na OS 5
(102, 9), -- Impressora 102 envolvida na OS 9
(103, 10), -- Impressora 103 envolvida na OS 10
(104, 16), -- Impressora 104 envolvida na OS 16
(101, 13); -- Impressora 101 envolvida na OS 13

-- Selecionar todos os dados da tabela UNIDADE_SUPORTE
SELECT * FROM UNIDADE_SUPORTE;

-- Selecionar todos os dados da tabela CLIENTE_PJ
SELECT * FROM CLIENTE_PJ;

-- Selecionar todos os dados da tabela SUPERVISOR
SELECT * FROM SUPERVISOR;

-- Selecionar todos os dados da tabela TECNICO
SELECT * FROM TECNICO;

-- Selecionar todos os dados da tabela KPI
SELECT * FROM KPI;

-- Selecionar todos os dados da tabela FATURA
SELECT * FROM FATURA;

-- Selecionar todos os dados da tabela PARCELA_FATURA
SELECT * FROM PARCELA_FATURA;

-- Selecionar todos os dados da tabela CHAMADO
SELECT * FROM CHAMADO;

-- Selecionar todos os dados da tabela ORCAMENTO
SELECT * FROM ORCAMENTO;

-- Selecionar todos os dados da tabela ORDEM_SERVICO
SELECT * FROM ORDEM_SERVICO;

-- Selecionar todos os dados da tabela TIPO_SERVICO
SELECT * FROM TIPO_SERVICO;

-- Selecionar todos os dados da tabela SERVICO
SELECT * FROM SERVICO;

-- Selecionar todos os dados da tabela CONTRATO
SELECT * FROM CONTRATO;

-- Selecionar todos os dados da tabela COMPUTADOR
SELECT * FROM COMPUTADOR;

-- Selecionar todos os dados da tabela IMPRESSORA
SELECT * FROM IMPRESSORA;

-- Selecionar todos os dados da tabela DRIVER_IMPRESSORA
SELECT * FROM DRIVER_IMPRESSORA;

-- Selecionar todos os dados da tabela COMPONENTE
SELECT * FROM COMPONENTE;

-- Selecionar todos os dados da tabela DRIVER
SELECT * FROM DRIVER;

-- Selecionar todos os dados da tabela Possui_computador_componente
SELECT * FROM Possui_computador_componente;

-- Selecionar todos os dados da tabela Envolveu_Ordem_Servico_Computador
SELECT * FROM Envolveu_Ordem_Servico_Computador;

-- Selecionar todos os dados da tabela Envolveu_Ordem_Servico_Impressora
SELECT * FROM Envolveu_Ordem_Servico_Impressora;
