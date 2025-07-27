USE HelpDesk;
-- -----------------------------------------------------
-- 1. Criação de Papéis (Roles)
-- -----------------------------------------------------
-- Papel para Administradores do Sistema
CREATE ROLE IF NOT EXISTS 'admin';

-- Papel para Supervisores
CREATE ROLE IF NOT EXISTS 'supervisor';

-- Papel para Técnicos
CREATE ROLE IF NOT EXISTS 'tecnico';

-- Papel para Clientes (Pessoa Jurídica)
CREATE ROLE IF NOT EXISTS 'cliente_pj';

-- -----------------------------------------------------
-- 2. Concessão de Permissões aos Papéis
-- -----------------------------------------------------

-- Concessão de TODOS os privilégios para o papel 'admin'
GRANT ALL PRIVILEGES ON HelpDesk.* TO 'admin';


-- Para a função 'verificar_contrato_em_dia'
-- Técnico (RU -> E), Supervisor (RU -> E), Cliente_PJ (R -> E)
GRANT EXECUTE ON FUNCTION verificar_contrato_em_dia TO 'tecnico';
GRANT EXECUTE ON FUNCTION verificar_contrato_em_dia TO 'supervisor';
GRANT EXECUTE ON FUNCTION verificar_contrato_em_dia TO 'cliente_pj';

-- Para a função 'verificar_fatura_criada'
-- Técnico (RU -> E), Supervisor (RU -> E), Cliente_PJ (R -> E)
GRANT EXECUTE ON FUNCTION verificar_fatura_criada TO 'tecnico';
GRANT EXECUTE ON FUNCTION verificar_fatura_criada TO 'supervisor';
GRANT EXECUTE ON FUNCTION verificar_fatura_criada TO 'cliente_pj';

-- Para a função 'verificar_pagamentos_em_dia'
-- Técnico (RU -> E), Supervisor (RU -> E), Cliente_PJ (R -> E)
GRANT EXECUTE ON FUNCTION verificar_pagamentos_em_dia TO 'tecnico';
GRANT EXECUTE ON FUNCTION verificar_pagamentos_em_dia TO 'supervisor';
GRANT EXECUTE ON FUNCTION verificar_pagamentos_em_dia TO 'cliente_pj';

-- Para a stored procedure 'sp_gerar_kpi_para_tecnico_especifico'
-- Técnico (RU -> E), Supervisor (RU -> E)
GRANT EXECUTE ON PROCEDURE sp_gerar_kpi_para_tecnico_especifico TO 'tecnico';
GRANT EXECUTE ON PROCEDURE sp_gerar_kpi_para_tecnico_especifico TO 'supervisor';

-- Para a stored procedure 'procedure_atualizar_os_concluidas'
-- Técnico (RU -> E), Supervisor (RU -> E)
GRANT EXECUTE ON PROCEDURE procedure_atualizar_os_concluidas TO 'tecnico'; -- O grant anterior do tecnico tinha essa SP, mas a planilha não mostra. Ajustando conforme a planilha.
GRANT EXECUTE ON PROCEDURE procedure_atualizar_os_concluidas TO 'supervisor';


-- -----------------------------------------------------
-- Concessão de Permissões para Views (Relatórios)
-- As views são sempre consultadas com permissões de SELECT (Read).
-- Na planilha, 'R' indica SELECT.
-- -----------------------------------------------------

-- Para a view 'chamados encerrados por tipo de serviço'
-- Técnico (R), Supervisor (R), Cliente_PJ (R)
GRANT SELECT ON view_chamados_encerrados_por_tipo_servico TO 'tecnico'; -- Assumindo o nome completo da view
GRANT SELECT ON view_chamados_encerrados_por_tipo_servico TO 'supervisor';
GRANT SELECT ON view_chamados_encerrados_por_tipo_servico TO 'cliente_pj';

-- Para a view 'todos os chamados agrupados por tipo de serviço'
-- Técnico (R), Supervisor (R), Cliente_PJ (R)
GRANT SELECT ON view_chamados_por_tipo_servico TO 'tecnico';
GRANT SELECT ON view_chamados_por_tipo_servico TO 'supervisor';
GRANT SELECT ON view_chamados_por_tipo_servico TO 'cliente_pj';

-- Para a view 'técnicos por departamento'
-- Técnico (R), Supervisor (R), Cliente_PJ (R)
GRANT SELECT ON view_tecnicos_por_departamento TO 'tecnico'; -- Assumindo o nome completo da view
GRANT SELECT ON view_tecnicos_por_departamento TO 'supervisor';
GRANT SELECT ON view_tecnicos_por_departamento TO 'cliente_pj';

-- Para a view 'chamados por solicitante'
-- Técnico (R), Supervisor (R), Cliente_PJ (R)
GRANT SELECT ON view_chamados_por_solicitante TO 'tecnico'; -- Assumindo o nome completo da view
GRANT SELECT ON view_chamados_por_solicitante TO 'supervisor';
GRANT SELECT ON view_chamados_por_solicitante TO 'cliente_pj';

-- -----------------------------------------------------
-- Concessão de Permissões DML para Disparar Triggers
-- -----------------------------------------------------

-- Permissões para o papel 'supervisor'
-- Já possui C,R,U,D em UNIDADE_SUPORTE e CHAMADO.
-- Já possui C,R,U em TECNICO, SUPERVISOR, ORDEM_SERVICO, SERVICO, KPI, VALOR_KPI.
-- Estas permissões já cobrem os disparos de triggers relacionados a essas tabelas.
GRANT SELECT, INSERT, UPDATE, DELETE ON UNIDADE_SUPORTE TO 'supervisor';
GRANT SELECT, INSERT, UPDATE ON SUPERVISOR TO 'supervisor';
GRANT SELECT, INSERT, UPDATE ON TECNICO TO 'supervisor';
GRANT SELECT, INSERT, UPDATE ON KPI TO 'supervisor';
GRANT SELECT, INSERT, UPDATE ON VALOR_KPI TO 'supervisor';
GRANT SELECT, INSERT, UPDATE, DELETE ON CHAMADO TO 'supervisor';
GRANT SELECT, INSERT, UPDATE ON ORDEM_SERVICO TO 'supervisor';
GRANT SELECT, INSERT, UPDATE ON SERVICO TO 'supervisor';
-- Adicionei as permissões de SELECT para as demais tabelas para o supervisor,
-- conforme a lógica de que ele precisa visualizar a maioria dos dados.
GRANT SELECT ON CLIENTE_PJ TO 'supervisor';
GRANT SELECT ON FATURA TO 'supervisor';
GRANT SELECT ON PARCELA_FATURA TO 'supervisor';
GRANT SELECT ON ORCAMENTO TO 'supervisor';
GRANT SELECT ON TIPO_SERVICO TO 'supervisor';
GRANT SELECT ON CONTRATO TO 'supervisor';
GRANT SELECT ON COMPUTADOR TO 'supervisor';
GRANT SELECT ON IMPRESSORA TO 'supervisor';
GRANT SELECT ON DRIVER_IMPRESSORA TO 'supervisor';
GRANT SELECT ON COMPONENTE TO 'supervisor';
GRANT SELECT ON DRIVER TO 'supervisor';
GRANT SELECT ON Possui_computador_componente TO 'supervisor';
GRANT SELECT ON Envolveu_Ordem_Servico_Computador TO 'supervisor';
GRANT SELECT ON Envolveu_Ordem_Servico_Impressora TO 'supervisor';


-- Permissões para o papel 'tecnico'
-- Já possui SELECT, UPDATE em TECNICO, CHAMADO, ORDEM_SERVICO, SERVICO.
-- Estas permissões já cobrem os disparos de triggers relacionados a essas tabelas.
GRANT SELECT, UPDATE ON TECNICO TO 'tecnico';
GRANT SELECT, UPDATE ON CHAMADO TO 'tecnico';
GRANT SELECT, UPDATE ON ORDEM_SERVICO TO 'tecnico';
GRANT SELECT, UPDATE ON SERVICO TO 'tecnico';
-- Adicionei as permissões de SELECT para as demais tabelas para o técnico,
-- conforme a lógica de que ele precisa visualizar dados para seu trabalho.
GRANT SELECT ON UNIDADE_SUPORTE TO 'tecnico';
GRANT SELECT ON CLIENTE_PJ TO 'tecnico';
GRANT SELECT ON SUPERVISOR TO 'tecnico';
GRANT SELECT ON KPI TO 'tecnico';
GRANT SELECT ON VALOR_KPI TO 'tecnico';
GRANT SELECT ON FATURA TO 'tecnico';
GRANT SELECT ON PARCELA_FATURA TO 'tecnico';
GRANT SELECT ON ORCAMENTO TO 'tecnico';
GRANT SELECT ON TIPO_SERVICO TO 'tecnico';
GRANT SELECT ON CONTRATO TO 'tecnico';
GRANT SELECT ON COMPUTADOR TO 'tecnico';
GRANT SELECT ON IMPRESSORA TO 'tecnico';
GRANT SELECT ON DRIVER_IMPRESSORA TO 'tecnico';
GRANT SELECT ON COMPONENTE TO 'tecnico';
GRANT SELECT ON DRIVER TO 'tecnico';
GRANT SELECT ON Possui_computador_componente TO 'tecnico';
GRANT SELECT ON Envolveu_Ordem_Servico_Computador TO 'tecnico';
GRANT SELECT ON Envolveu_Ordem_Servico_Impressora TO 'tecnico';


-- Permissões para o papel 'cliente_pj'
-- Para 'trigger_kpi_chamados':
-- A planilha indica 'C' (Create/Insert) e 'U' (Update) para CLIENTE_PJ em CHAMADO.
-- 'INSERT' já estava presente. Adicionando 'UPDATE' para cobrir o 'U' implícito.
GRANT SELECT, INSERT, UPDATE ON CHAMADO TO 'cliente_pj';

-- As demais permissões para CLIENTE_PJ
GRANT SELECT ON CLIENTE_PJ TO 'cliente_pj';
GRANT SELECT ON FATURA TO 'cliente_pj';
GRANT SELECT ON PARCELA_FATURA TO 'cliente_pj';
GRANT SELECT ON ORDEM_SERVICO TO 'cliente_pj';
GRANT SELECT ON CONTRATO TO 'cliente_pj';
GRANT SELECT ON COMPUTADOR TO 'cliente_pj';
GRANT SELECT ON IMPRESSORA TO 'cliente_pj';

-- -----------------------------------------------------
-- 3. Criação de Usuários e Atribuição de Papéis
-- -----------------------------------------------------

-- Exemplo: Criar um usuário administrador e atribuir o 'admin_role'
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'senhaadmin123';
GRANT 'admin' TO 'admin_user'@'localhost';
SET DEFAULT ROLE 'admin' TO 'admin_user'@'localhost';

-- Exemplo: Criar um usuário supervisor e atribuir o 'supervisor_role'
CREATE USER IF NOT EXISTS 'supervisor_user'@'localhost' IDENTIFIED BY 'senhasupervisor123';
GRANT 'supervisor' TO 'supervisor_user'@'localhost';
SET DEFAULT ROLE 'supervisor' TO 'supervisor_user'@'localhost';

-- Exemplo: Criar um usuário técnico e atribuir o 'tecnico_role'
CREATE USER IF NOT EXISTS 'tecnico_user'@'localhost' IDENTIFIED BY 'senhatecnico123';
GRANT 'tecnico' TO 'tecnico_user'@'localhost';
SET DEFAULT ROLE 'tecnico' TO 'tecnico_user'@'localhost';

-- Exemplo: Criar um usuário cliente e atribuir o 'cliente_pj_role'
CREATE USER IF NOT EXISTS 'cliente_pj_user'@'localhost' IDENTIFIED BY 'senhacliente123';
GRANT 'cliente_pj' TO 'cliente_pj_user'@'localhost';
SET DEFAULT ROLE 'cliente_pj' TO 'cliente_pj_user'@'localhost';

-- -----------------------------------------------------
-- 4. Aplicar as Alterações de Permissões
-- -----------------------------------------------------
FLUSH PRIVILEGES;
