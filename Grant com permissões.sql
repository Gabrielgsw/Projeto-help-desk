-- Use o banco de dados HelpDesk
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
-- Permissões para 'admin_role'
-- Controle total sobre o banco de dados HelpDesk
GRANT ALL PRIVILEGES ON HelpDesk.* TO 'admin';

-- Permissões para 'supervisor_role'
-- Acesso de leitura à maioria das tabelas para monitoramento e relatórios
GRANT SELECT ON HelpDesk.* TO 'supervisor';

-- Permissões de UPDATE específicas
-- Supervisores podem atualizar atribuições/status de chamados
GRANT UPDATE ON HelpDesk.CHAMADO TO 'supervisor';
-- Supervisores podem gerenciar técnicos (criar, atualizar, excluir)
GRANT INSERT, UPDATE, DELETE ON HelpDesk.TECNICO TO 'supervisor';
-- Supervisores podem gerenciar KPIs (criar, atualizar, excluir)
GRANT INSERT, UPDATE, DELETE ON HelpDesk.KPI TO 'supervisor';
-- Supervisores podem atualizar seu próprio perfil
GRANT UPDATE ON HelpDesk.SUPERVISOR TO 'supervisor';

-- Permissões para 'tecnico_role'
-- Acesso de leitura a tabelas relevantes para a resolução de chamados
GRANT SELECT ON HelpDesk.CHAMADO TO 'tecnico';
GRANT SELECT ON HelpDesk.ORDEM_SERVICO TO 'tecnico';
GRANT SELECT ON HelpDesk.SERVICO TO 'tecnico';
GRANT SELECT ON HelpDesk.TIPO_SERVICO TO 'tecnico';
GRANT SELECT ON HelpDesk.ORCAMENTO TO 'tecnico';
GRANT SELECT ON HelpDesk.COMPUTADOR TO 'tecnico';
GRANT SELECT ON HelpDesk.IMPRESSORA TO 'tecnico';
GRANT SELECT ON HelpDesk.DRIVER_IMPRESSORA TO 'tecnico';
GRANT SELECT ON HelpDesk.COMPONENTE TO 'tecnico';
GRANT SELECT ON HelpDesk.DRIVER TO 'tecnico';
GRANT SELECT ON HelpDesk.Possui_computador_componente TO 'tecnico';
GRANT SELECT ON HelpDesk.Envolveu_Ordem_Servico_Computador TO 'tecnico';
GRANT SELECT ON HelpDesk.Envolveu_Ordem_Servico_Impressora TO 'tecnico';
GRANT SELECT ON HelpDesk.UNIDADE_SUPORTE TO 'tecnico';
GRANT SELECT ON HelpDesk.CLIENTE_PJ TO 'tecnico';
GRANT SELECT ON HelpDesk.FATURA TO 'tecnico';
GRANT SELECT ON HelpDesk.PARCELA_FATURA TO 'tecnico';
-- Acesso de leitura ao perfil do técnico
GRANT SELECT ON HelpDesk.TECNICO TO 'tecnico';

-- Permissões de UPDATE específicas
-- Técnicos podem atualizar o status do chamado e suas próprias métricas
GRANT UPDATE ON HelpDesk.CHAMADO TO 'tecnico';
-- Permissão para atualizar colunas específicas no perfil do técnico
GRANT UPDATE (no_consertos, dias_trabalhados, no_voltas) ON HelpDesk.TECNICO TO 'tecnico';

-- Permissões para 'cliente_pj_role'
-- Clientes podem inserir novos chamados
GRANT INSERT ON HelpDesk.CHAMADO TO 'cliente_pj';

-- Clientes podem selecionar e atualizar seus próprios chamados (a lógica da aplicação filtraria por client_id)
GRANT SELECT, UPDATE ON HelpDesk.CHAMADO TO 'cliente_pj';

-- Clientes podem selecionar e atualizar seu próprio perfil
GRANT SELECT, UPDATE ON HelpDesk.CLIENTE_PJ TO 'cliente_pj';

-- Clientes podem visualizar suas faturas e parcelas de pagamento
GRANT SELECT ON HelpDesk.FATURA TO 'cliente_pj';
GRANT SELECT ON HelpDesk.PARCELA_FATURA TO 'cliente_pj';

-- Clientes podem visualizar seus computadores, impressoras e contratos registrados
GRANT SELECT ON HelpDesk.COMPUTADOR TO 'cliente_pj';
GRANT SELECT ON HelpDesk.IMPRESSORA TO 'cliente_pj';
GRANT SELECT ON HelpDesk.CONTRATO TO 'cliente_pj';

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
