USE help_desk;

-- Criação das roles
CREATE ROLE 'cliente_pj';
CREATE ROLE 'supervisor';
CREATE ROLE 'tecnico';

-- Criação de usuários fictícios
CREATE USER 'user_cliente'@'%' IDENTIFIED BY 'senha123';
CREATE USER 'user_supervisor'@'%' IDENTIFIED BY 'senha123';
CREATE USER 'user_tecnico'@'%' IDENTIFIED BY 'senha123';

-- Atribuindo roles
GRANT 'cliente_pj' TO 'user_cliente'@'%';
GRANT 'supervisor' TO 'user_supervisor'@'%';
GRANT 'tecnico' TO 'user_tecnico'@'%';

-- Definindo como padrão
SET DEFAULT ROLE 'cliente_pj' TO 'user_cliente'@'%';
SET DEFAULT ROLE 'supervisor' TO 'user_supervisor'@'%';
SET DEFAULT ROLE 'tecnico' TO 'user_tecnico'@'%';


-- Cliente_pj
GRANT SELECT, INSERT, UPDATE ON HelpDesk.CLIENTE_PJ TO 'cliente_pj';
GRANT SELECT ON HelpDesk.KPI TO 'cliente_pj';
GRANT SELECT, INSERT ON HelpDesk.CHAMADO TO 'cliente_pj';
GRANT SELECT ON HelpDesk.PARCELA_FATURA TO 'cliente_pj';
GRANT SELECT ON HelpDesk.FATURA TO 'cliente_pj';
GRANT SELECT ON HelpDesk.SERVICO TO 'cliente_pj';
GRANT SELECT ON HelpDesk.ORDEM_SERVICO TO 'cliente_pj';
GRANT SELECT ON HelpDesk.COMPUTADOR TO 'cliente_pj';
GRANT SELECT ON HelpDesk.IMPRESSORA TO 'cliente_pj';
GRANT SELECT ON HelpDesk.CONTRATO TO 'cliente_pj';
GRANT SELECT ON HelpDesk.Envolveu_Ordem_Servico_Computador TO 'cliente_pj';
GRANT SELECT ON HelpDesk.Envolveu_Ordem_Servico_Impressora TO 'cliente_pj';



-- Supervisor
GRANT SELECT, UPDATE ON HelpDesk.UNIDADE_SUPORTE TO 'supervisor';
GRANT SELECT ON HelpDesk.TECNICO TO 'supervisor';
GRANT SELECT ON HelpDesk.CLIENTE_PJ TO 'supervisor';
GRANT SELECT ON HelpDesk.KPI TO 'supervisor';
GRANT SELECT, UPDATE ON HelpDesk.CHAMADO TO 'supervisor';
GRANT SELECT ON HelpDesk.PARCELA_FATURA TO 'supervisor';
GRANT SELECT ON HelpDesk.FATURA TO 'supervisor';
GRANT SELECT ON HelpDesk.ORCAMENTO TO 'supervisor';
GRANT SELECT ON HelpDesk.ORDEM_SERVICO TO 'supervisor';
GRANT SELECT ON HelpDesk.SERVICO TO 'supervisor';
GRANT SELECT ON HelpDesk.TIPO_SERVICO TO 'supervisor';
GRANT SELECT ON HelpDesk.CONTRATO TO 'supervisor';
GRANT SELECT ON HelpDesk.COMPUTADOR TO 'supervisor';
GRANT SELECT ON HelpDesk.IMPRESSORA TO 'supervisor';
GRANT SELECT ON HelpDesk.COMPONENTE TO 'supervisor';
GRANT SELECT ON HelpDesk.Possui_computador_componente TO 'supervisor';
GRANT SELECT ON HelpDesk.Envolveu_Ordem_Servico_Computador TO 'supervisor';
GRANT SELECT ON HelpDesk.Envolveu_Ordem_Servico_Impressora TO 'supervisor';


-- Técnico
GRANT SELECT, UPDATE ON HelpDesk.CHAMADO TO 'tecnico';
GRANT SELECT ON HelpDesk.KPI TO 'tecnico';
GRANT SELECT ON HelpDesk.SERVICO TO 'tecnico';
GRANT SELECT ON HelpDesk.CONTRATO TO 'tecnico';
GRANT SELECT ON HelpDesk.FATURA TO 'tecnico';
GRANT SELECT ON HelpDesk.PARCELA_FATURA TO 'tecnico';
GRANT SELECT ON HelpDesk.COMPUTADOR TO 'tecnico';
GRANT SELECT ON HelpDesk.IMPRESSORA TO 'tecnico';
GRANT SELECT ON HelpDesk.DRIVER_IMPRESSORA TO 'tecnico';
GRANT SELECT ON HelpDesk.COMPONENTE TO 'tecnico';
GRANT SELECT ON HelpDesk.Possui_computador_componente TO 'tecnico';
GRANT SELECT ON HelpDesk.Envolveu_Ordem_Servico_Computador TO 'tecnico';
GRANT SELECT ON HelpDesk.Envolveu_Ordem_Servico_Impressora TO 'tecnico';

-- 
