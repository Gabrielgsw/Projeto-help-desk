CREATE DATABASE HelpDesk;
USE HelpDesk;

-- Desabilita a verificação de chaves estrangeiras temporariamente.
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- Table UNIDADE_SUPORTE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS UNIDADE_SUPORTE (
    CNPJ VARCHAR(18) NOT NULL PRIMARY KEY,
    estado VARCHAR(50),
    endereco VARCHAR(255),
    nome VARCHAR(255) NOT NULL,
    Matriz BOOLEAN DEFAULT FALSE,
    razao_social VARCHAR(255) NOT NULL,
    NroFuncionarios INT DEFAULT 0 -- iniciando sem funcionarios
);

-- -----------------------------------------------------
-- Table CLIENTE_PJ
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CLIENTE_PJ (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prioridade VARCHAR(50),
    endereco VARCHAR(255),
    estado VARCHAR(50),
    fone VARCHAR(20),
    email VARCHAR(255),
    cnpj VARCHAR(18) UNIQUE,
    razao_social VARCHAR(255)  
);

-- -----------------------------------------------------
-- Table SUPERVISOR
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SUPERVISOR (
    Matricula INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    CPF VARCHAR(14) UNIQUE,
    email VARCHAR(255) UNIQUE,
    carga_horaria INT,
    unidade VARCHAR(18),    
    FOREIGN KEY (unidade) REFERENCES UNIDADE_SUPORTE (CNPJ)
);

-- -----------------------------------------------------
-- Table TECNICO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TECNICO (
    Matricula INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    CPF VARCHAR(14) UNIQUE,
    email VARCHAR(255) UNIQUE,
    carga_horaria INT,
    no_consertos INT DEFAULT 0,
    dias_trabalhados INT DEFAULT 0,
    no_voltas INT DEFAULT 0,
    matric_supervisor INT,
    data_inicio DATE,
    unidade VARCHAR(18),    
    FOREIGN KEY (matric_supervisor) REFERENCES SUPERVISOR (Matricula),
    FOREIGN KEY (unidade) REFERENCES UNIDADE_SUPORTE (CNPJ)
);

-- -----------------------------------------------------
-- Table KPI
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS KPI (
    matric_tec INT NOT NULL,
    Sequencial INT NOT NULL,
    KPI_1 VARCHAR(100),
    dsc_KPI_1 VARCHAR(255),
    KPI_2 VARCHAR(100),
    dsc_KPI_2 VARCHAR(255),
    PRIMARY KEY (matric_tec, Sequencial),
    FOREIGN KEY (matric_tec) REFERENCES TECNICO (Matricula)
);

-- -----------------------------------------------------
-- Table FATURA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS FATURA (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    n_parcelas INT,
    data_emissao DATE,
    valor_total DECIMAL(10,2),
    status VARCHAR(50), -- -- 'Aberta', 'Paga', 'Atrasada'
    cod_cliente_pj INT,    
    FOREIGN KEY (cod_cliente_pj) REFERENCES CLIENTE_PJ (Cod)
);

-- -----------------------------------------------------
-- Table PARCELA_FATURA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PARCELA_FATURA ( -- Entidade criada para armazenar as parcelas de uma fatura
    parcela_id INT NOT NULL AUTO_INCREMENT,
    cod_fatura INT NOT NULL,
    numero_parcela INT NOT NULL,
    valor_parcela DECIMAL(10,2),
    data_vencimento DATE NOT NULL,
    data_pagamento DATE, -- NULL se ainda não foi paga
    status_parcela VARCHAR(50) NOT NULL DEFAULT 'Aberta', -- 'Aberta', 'Paga', 'Atrasada'
    PRIMARY KEY (parcela_id),
    UNIQUE (cod_fatura, numero_parcela), -- Garante unicidade de parcela por fatura
    FOREIGN KEY (cod_fatura) REFERENCES FATURA (cod)
);

-- -----------------------------------------------------
-- Table CHAMADO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CHAMADO (
    Seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Prioridade VARCHAR(50),
    Complexidade VARCHAR(50),
    descricao TEXT,
    status VARCHAR(50), -- 'Pendente', 'Em demanda', 'Resolvido'
    tipo VARCHAR(50),
    cod_plano VARCHAR(50), -- Assumindo que cod_plano seja um código externo ou não referenciado aqui
    mat_supervisor INT,
    mat_tec INT,
    cod_cliente_pj INT,
    data DATE,    
    FOREIGN KEY (mat_supervisor) REFERENCES SUPERVISOR (Matricula),
    FOREIGN KEY (mat_tec) REFERENCES TECNICO (Matricula),
    FOREIGN KEY (cod_cliente_pj) REFERENCES CLIENTE_PJ (Cod)
);

-- -----------------------------------------------------
-- Table ORCAMENTO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ORCAMENTO (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_abertura DATE,
    dt_emissao DATE,
    descricao TEXT,
    validade_n_dias INT,
    ultima_data DATE    
);

-- -----------------------------------------------------
-- Table ORDEM_SERVICO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ORDEM_SERVICO (
    numero INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(50), -- Esse status deve ser atualizado conforme atualização no status do chamado
    data_criacao DATE,
    prazo_em_dias INT,
    dt_devida DATE,
    cod_orcamento INT,
    cod_fatura INT,
    cod_chamado INT,    
    FOREIGN KEY (cod_orcamento) REFERENCES ORCAMENTO (cod),
    FOREIGN KEY (cod_fatura) REFERENCES FATURA (cod),
    FOREIGN KEY (cod_chamado) REFERENCES CHAMADO (Seq)
);

-- -----------------------------------------------------
-- Table TIPO_SERVICO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TIPO_SERVICO (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255)    
);

-- -----------------------------------------------------
-- Table SERVICO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SERVICO (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT,
    status VARCHAR(50),
    valor DECIMAL(10,2),
    cod_tipo_servico INT,
    num_serv INT, 
    nivel_urgencia VARCHAR(50),   
    FOREIGN KEY (cod_tipo_servico) REFERENCES TIPO_SERVICO (cod),
    FOREIGN KEY (num_serv) REFERENCES ORDEM_SERVICO (numero)
);

-- -----------------------------------------------------
-- Table CONTRATO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CONTRATO (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dt_fim DATE,
    status VARCHAR(50),
    dt_inicio DATE,
    periodo_contrato_em_dias INT,
    cod_cliente_pj INT NOT NULL,
    cod_unidade VARCHAR(18) NOT NULL,        
    UNIQUE (cod_cliente_pj, cod_unidade),
    FOREIGN KEY (cod_cliente_pj) REFERENCES CLIENTE_PJ (Cod),
    FOREIGN KEY (cod_unidade) REFERENCES UNIDADE_SUPORTE (CNPJ)
);

-- -----------------------------------------------------
-- Table COMPUTADOR
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS COMPUTADOR (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50),
    fabricante VARCHAR(255),
    data_entrada DATE,
    setor VARCHAR(255),
    descricao TEXT,
    historico TEXT,
    bios_fabric VARCHAR(255),
    versao_bios VARCHAR(50),
    nome_so VARCHAR(255),
    versao_so VARCHAR(50),
    end_IP VARCHAR(15),
    tipo VARCHAR(50),
    cod_contrato INT,    
    FOREIGN KEY (cod_contrato) REFERENCES CONTRATO (cod)
);

-- -----------------------------------------------------
-- Table IMPRESSORA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS IMPRESSORA (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50),
    fabricante VARCHAR(255),
    data_entrada DATE,
    setor VARCHAR(255),
    descricao TEXT,
    historico TEXT,
    modelo VARCHAR(255),
    cod_contrato INT,   
	FOREIGN KEY (cod_contrato) REFERENCES CONTRATO (cod)
);

-- -----------------------------------------------------
-- Table DRIVER_IMPRESSORA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS DRIVER_IMPRESSORA (
    cod_impressora INT NOT NULL,
    cod_driver INT NOT NULL,
    Versao VARCHAR(50),
    Caminho VARCHAR(255),
    PRIMARY KEY (cod_impressora, cod_driver),
    FOREIGN KEY (cod_impressora) REFERENCES IMPRESSORA (cod)
);

-- -----------------------------------------------------
-- Table COMPONENTE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS COMPONENTE (
    cod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    onboard BOOLEAN,
    tipo VARCHAR(50),
    modelo VARCHAR(255),
    fabricante VARCHAR(255)   
);

-- -----------------------------------------------------
-- Table DRIVER (do COMPONENTE)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS DRIVER (
    cod_componente INT NOT NULL,
    Sequencial INT NOT NULL,
    Caminho VARCHAR(255),
    PRIMARY KEY (cod_componente, Sequencial),
    FOREIGN KEY (cod_componente) REFERENCES COMPONENTE (cod)
);

-- -----------------------------------------------------
-- Relacionamento N:N entre COMPUTADOR e COMPONENTE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Possui_computador_componente (
    cod_comp INT NOT NULL,
    cod_componente INT NOT NULL,
    PRIMARY KEY (cod_comp, cod_componente),
    FOREIGN KEY (cod_comp) REFERENCES COMPUTADOR (cod),
    FOREIGN KEY (cod_componente) REFERENCES COMPONENTE (cod)
);

-- -----------------------------------------------------
-- Relacionamento N:N entre COMPUTADOR e ORDEM_SERVICO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Envolveu_Ordem_Servico_Computador (
    cod_comp INT NOT NULL,
    cod_num_ordem INT NOT NULL, -- O nome do campo na ORDEM_SERVICO é 'numero'
    PRIMARY KEY (cod_comp, cod_num_ordem),
    FOREIGN KEY (cod_comp) REFERENCES COMPUTADOR (cod),
    FOREIGN KEY (cod_num_ordem) REFERENCES ORDEM_SERVICO (numero)
);

-- -----------------------------------------------------
-- Relacionamento N:N entre IMPRESSORA e ORDEM_SERVICO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Envolveu_Ordem_Servico_Impressora (
    cod_impressora INT NOT NULL,
    cod_num_ordem INT NOT NULL, -- O nome do campo na ORDEM_SERVICO é 'numero'
    PRIMARY KEY (cod_impressora, cod_num_ordem),
    FOREIGN KEY (cod_impressora) REFERENCES IMPRESSORA (cod),
    FOREIGN KEY (cod_num_ordem) REFERENCES ORDEM_SERVICO (numero)
);

-- Reabilita a verificação de chaves estrangeiras.
SET FOREIGN_KEY_CHECKS = 1;


