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

-- Grants for Supervisor Role
GRANT SELECT, UPDATE ON UNIDADE_SUPORTE TO 'supervisor';
GRANT SELECT, UPDATE ON SUPERVISOR TO 'supervisor';
GRANT SELECT, UPDATE ON KPI TO 'supervisor';
GRANT SELECT, UPDATE ON CLIENTE_PJ TO 'supervisor';
GRANT SELECT, UPDATE ON FATURA TO 'supervisor';
GRANT SELECT, UPDATE ON PARCELA_FATURA TO 'supervisor';
GRANT SELECT, INSERT, UPDATE, DELETE ON CHAMADO TO 'supervisor'; -- C, R, U, D
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDEM_SERVICO TO 'supervisor'; -- C, R, U, D
GRANT SELECT, INSERT, UPDATE, DELETE ON SERVICO TO 'supervisor'; -- C, R, U, D
GRANT SELECT, UPDATE ON TIPO_SERVICO TO 'supervisor';
GRANT SELECT, UPDATE ON ORCAMENTO TO 'supervisor';
GRANT SELECT, UPDATE ON COMPUTADOR TO 'supervisor';
GRANT SELECT, UPDATE ON IMPRESSORA TO 'supervisor';
GRANT SELECT, UPDATE ON DRIVER_IMPRESSORA TO 'supervisor';
GRANT SELECT, UPDATE ON COMPONENTE TO 'supervisor';
GRANT SELECT, UPDATE ON CONTRATO TO 'supervisor';
GRANT SELECT, INSERT, UPDATE ON Possui_computador_componente TO 'supervisor'; -- C, R, U
GRANT SELECT, INSERT, UPDATE ON Envolveu_Ordem_Servico_Computador TO 'supervisor'; -- C, R, U
GRANT SELECT, INSERT, UPDATE ON Envolveu_Ordem_Servico_Impressora TO 'supervisor'; -- C, R, U
GRANT SELECT, INSERT, UPDATE ON TECNICO TO 'supervisor'; -- C, R, U
GRANT SELECT, INSERT, UPDATE, DELETE ON VALOR_KPI TO 'supervisor'; -- C, R, U, D

-- Grants for TECNICO Role
GRANT SELECT ON UNIDADE_SUPORTE TO 'tecnico';
GRANT SELECT ON SUPERVISOR TO 'tecnico';
GRANT SELECT ON KPI TO 'tecnico';
GRANT SELECT ON CLIENTE_PJ TO 'tecnico';
GRANT SELECT ON FATURA TO 'tecnico';
GRANT SELECT ON PARCELA_FATURA TO 'tecnico';
GRANT SELECT, INSERT, UPDATE ON CHAMADO TO 'tecnico'; -- C, R, U
GRANT SELECT, INSERT, UPDATE ON ORDEM_SERVICO TO 'tecnico'; -- C, R, U
GRANT SELECT, INSERT, UPDATE ON SERVICO TO 'tecnico'; -- C, R, U
GRANT SELECT ON TIPO_SERVICO TO 'tecnico';
GRANT SELECT ON ORCAMENTO TO 'tecnico';
GRANT SELECT, UPDATE ON COMPUTADOR TO 'tecnico'; -- R, U
GRANT SELECT, UPDATE ON IMPRESSORA TO 'tecnico'; -- R, U
GRANT SELECT, UPDATE ON DRIVER_IMPRESSORA TO 'tecnico'; -- R, U
GRANT SELECT, UPDATE ON COMPONENTE TO 'tecnico'; -- R, U
GRANT SELECT ON CONTRATO TO 'tecnico';
GRANT SELECT, INSERT, UPDATE ON Possui_computador_componente TO 'tecnico'; -- C, R, U
GRANT SELECT, INSERT, UPDATE ON Envolveu_Ordem_Servico_Computador TO 'tecnico'; -- C, R, U
GRANT SELECT, INSERT, UPDATE ON Envolveu_Ordem_Servico_Impressora TO 'tecnico'; -- C, R, U
GRANT SELECT ON VALOR_KPI TO 'tecnico'; -- R

-- Grants for CLIENTE_PJ Role
GRANT SELECT ON CLIENTE_PJ TO 'cliente_pj';
GRANT SELECT ON FATURA TO 'cliente_pj';
GRANT SELECT ON PARCELA_FATURA TO 'cliente_pj';
GRANT SELECT, INSERT, UPDATE ON CHAMADO TO 'cliente_pj'; -- C, R, U
GRANT SELECT ON ORDEM_SERVICO TO 'cliente_pj';
GRANT SELECT ON ORCAMENTO TO 'cliente_pj';
GRANT SELECT ON CONTRATO TO 'cliente_pj';

GRANT EXECUTE ON PROCEDURE GerarKPIParaTecnicoPorPeriodo TO 'tecnico', 'supervisor', 'admin';
GRANT EXECUTE ON PROCEDURE InserirImpressorasViaCursor TO 'tecnico', 'supervisor', 'admin';
GRANT EXECUTE ON PROCEDURE InserirDriversViaCursor TO 'tecnico', 'supervisor', 'admin';
GRANT EXECUTE ON PROCEDURE InserirComputadoresViaCursor TO 'tecnico', 'supervisor', 'admin';
GRANT EXECUTE ON PROCEDURE InserirImpressorasViaCursor TO 'tecnico', 'supervisor', 'admin';
GRANT EXECUTE ON PROCEDURE procedure_atualizar_os_concluidas TO 'supervisor', 'admin'; -- Assuming it's a callable procedure

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
