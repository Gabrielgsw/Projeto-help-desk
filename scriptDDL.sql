USE help_desk;

CREATE TABLE Estado (
    estado_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    sigla CHAR(2)
);

CREATE TABLE Cidade (
    cidade_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    estado_id INT,
    FOREIGN KEY (estado_id) REFERENCES Estado(estado_id)
);

CREATE TABLE Bairro (
    bairro_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    cidade_id INT,
    FOREIGN KEY (cidade_id) REFERENCES Cidade(cidade_id)
);

CREATE TABLE Logradouro (
    logradouro_id INT PRIMARY KEY AUTO_INCREMENT,
    rua VARCHAR(100),
    numero VARCHAR(10),
    bairro_id INT,
    FOREIGN KEY (bairro_id) REFERENCES Bairro(bairro_id)
);

CREATE TABLE EmpresaSolicitante (
    empresa_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cnpj CHAR(20),
    logradouro_id INT,
    FOREIGN KEY (logradouro_id) REFERENCES Logradouro(logradouro_id)
);

CREATE TABLE Usuario (
    usuario_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100),
    senha VARCHAR(100),
    telefone VARCHAR(15),
    data_cadastro DATE
);

CREATE TABLE PermissaoUsuario (
    permissao_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    descricao VARCHAR(50),
    nivel_acesso INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

CREATE TABLE Solicitante (
    solicitante_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    empresa_id INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id),
    FOREIGN KEY (empresa_id) REFERENCES EmpresaSolicitante(empresa_id)
);

CREATE TABLE Cargo (
    cargo_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    descricao TEXT
);

CREATE TABLE Departamento (
    departamento_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    descricao TEXT
);

CREATE TABLE AreaAtuacao (
    area_atuacao_id INT PRIMARY KEY AUTO_INCREMENT,
    descricao TEXT
);

CREATE TABLE Tecnico (
    tecnico_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    cargo_id INT,
    departamento_id INT,
    area_atuacao_id INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id),
    FOREIGN KEY (cargo_id) REFERENCES Cargo(cargo_id),
    FOREIGN KEY (departamento_id) REFERENCES Departamento(departamento_id),
    FOREIGN KEY (area_atuacao_id) REFERENCES AreaAtuacao(area_atuacao_id)
);

CREATE TABLE TipoServico (
    tipo_servico_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100)
);

CREATE TABLE SubtipoServico (
    subtipo_id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_servico_id INT,
    nome VARCHAR(100),
    FOREIGN KEY (tipo_servico_id) REFERENCES TipoServico(tipo_servico_id)
);

CREATE TABLE SLA (
    sla_id INT PRIMARY KEY AUTO_INCREMENT,
    tempo_resposta INT,
    tempo_solucao INT
);

CREATE TABLE StatusChamado (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(50)
);

CREATE TABLE Chamado (
    chamado_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100),
    descricao TEXT,
    data_abertura DATE,
    data_encerramento DATE,
    status_id INT,
    sla_id INT,
    tipo_servico_id INT,
    subtipo_id INT,
    solicitante_id INT,
    tecnico_id INT,
    FOREIGN KEY (status_id) REFERENCES StatusChamado(status_id),
    FOREIGN KEY (sla_id) REFERENCES SLA(sla_id),
    FOREIGN KEY (tipo_servico_id) REFERENCES TipoServico(tipo_servico_id),
    FOREIGN KEY (subtipo_id) REFERENCES SubtipoServico(subtipo_id),
    FOREIGN KEY (solicitante_id) REFERENCES Solicitante(solicitante_id),
    FOREIGN KEY (tecnico_id) REFERENCES Tecnico(tecnico_id)
);

CREATE TABLE Comentario (
    comentario_id INT PRIMARY KEY AUTO_INCREMENT,
    chamado_id INT,
    usuario_id INT,
    conteudo TEXT,
    data_comentario DATETIME,
    FOREIGN KEY (chamado_id) REFERENCES Chamado(chamado_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    chamado_id INT,
    nota INT CHECK (nota BETWEEN 0 AND 10),
    comentario TEXT,
    data_feedback DATETIME,
    FOREIGN KEY (chamado_id) REFERENCES Chamado(chamado_id)
);

CREATE TABLE Historico (
    historico_id INT PRIMARY KEY AUTO_INCREMENT,
    chamado_id INT,
    descricao TEXT,
    data_alteracao DATETIME,
    FOREIGN KEY (chamado_id) REFERENCES Chamado(chamado_id)
);

CREATE TABLE Auditoria (
    auditoria_id INT PRIMARY KEY AUTO_INCREMENT,
    chamado_id INT,
    usuario_id INT,
    acao TEXT,
    data_acao DATETIME,
    FOREIGN KEY (chamado_id) REFERENCES Chamado(chamado_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

CREATE TABLE LogAtividades (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    auditoria_id INT,
    descricao TEXT,
    data DATETIME,
    FOREIGN KEY (auditoria_id) REFERENCES Auditoria(auditoria_id)
);

CREATE TABLE TempoAtividade (
    tempo_id INT PRIMARY KEY AUTO_INCREMENT,
    log_id INT,
    tempo_gasto INT,
    FOREIGN KEY (log_id) REFERENCES LogAtividades(log_id)
);

CREATE TABLE BaseConhecimento (
    base_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100),
    conteudo TEXT,
    tecnico_id INT,
    FOREIGN KEY (tecnico_id) REFERENCES Tecnico(tecnico_id)
);

CREATE TABLE PalavraChave (
    palavra_id INT PRIMARY KEY AUTO_INCREMENT,
    base_id INT,
    palavra VARCHAR(100),
    FOREIGN KEY (base_id) REFERENCES BaseConhecimento(base_id)
);
