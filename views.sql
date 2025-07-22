USE help_desk;
CREATE VIEW view_solicitantes AS
SELECT 
    s.solicitante_id,
    
    u.usuario_id,
    u.nome AS nome_usuario,
    u.email,
    u.telefone,
    
    e.empresa_id,
    e.nome AS nome_empresa,
    e.cnpj
FROM 
    Solicitante s
JOIN 
    Usuario u ON s.usuario_id = u.usuario_id
JOIN 
    EmpresaSolicitante e ON s.empresa_id = e.empresa_id;


CREATE VIEW view_departamentos AS
SELECT 
    departamento_id,
    nome,
    descricao
FROM 
    Departamento;


CREATE VIEW view_chamados AS
SELECT 
    ch.chamado_id,
    ch.titulo,
    ch.descricao,
    ch.data_abertura,
    ch.data_encerramento,
    
    st.status_id,
    st.descricao AS status,

    sla.sla_id,
    sla.tempo_resposta,
    sla.tempo_solucao,

    ts.tipo_servico_id,
    ts.nome AS tipo_servico,

    sub.subtipo_id,
    sub.nome AS subtipo_servico,

    sol.solicitante_id,
    tec.tecnico_id

FROM 
    Chamado ch
JOIN 
    StatusChamado st ON ch.status_id = st.status_id
JOIN 
    SLA sla ON ch.sla_id = sla.sla_id
JOIN 
    TipoServico ts ON ch.tipo_servico_id = ts.tipo_servico_id
JOIN 
    SubtipoServico sub ON ch.subtipo_id = sub.subtipo_id
JOIN 
    Solicitante sol ON ch.solicitante_id = sol.solicitante_id
JOIN 
    Tecnico tec ON ch.tecnico_id = tec.tecnico_id
JOIN 
    Usuario u ON tec.usuario_id = u.usuario_id;  


CREATE VIEW view_tecnicos AS
SELECT 
    t.tecnico_id,
    u.usuario_id,
    u.nome AS nome_usuario,
    c.cargo_id,
    c.nome AS nome_cargo,
    d.departamento_id,
    d.nome AS nome_departamento,
    a.area_atuacao_id,
    a.descricao AS nome_area_atuacao
FROM 
    Tecnico t
JOIN 
    Usuario u ON t.usuario_id = u.usuario_id
JOIN 
    Cargo c ON t.cargo_id = c.cargo_id
JOIN 
    Departamento d ON t.departamento_id = d.departamento_id
JOIN 
    AreaAtuacao a ON t.area_atuacao_id = a.area_atuacao_id;



CREATE VIEW view_empresas AS
SELECT
    e.empresa_id,
    e.nome AS empresa_nome,
    e.cnpj AS empresa_cnpj,
    e.logradouro_id AS empresa_endereco
FROM EmpresaSolicitante e;

CREATE VIEW view_empresas_solicitantes AS
SELECT 
    e.empresa_id,
    e.nome AS nome_empresa,
    e.cnpj,
    
    l.logradouro_id,
    l.rua,
    l.numero,
    l.bairro_id
FROM 
    EmpresaSolicitante e
JOIN 
    Logradouro l ON e.logradouro_id = l.logradouro_id;


-- Relatórios

SELECT *
FROM view_chamados;
-- WHERE data_abertura BETWEEN '2025-01-01' AND '2025-07-01';
-- Relatório chamados encerrados por tipo de serviço;

SELECT sla_id, tempo_resposta, tempo_solucao FROM SLA;

SELECT
    vc.tipo_servico AS tipo_de_servico,
    COUNT(vc.chamado_id) AS total_chamados,
    COUNT(CASE WHEN vc.data_encerramento IS NOT NULL THEN 1 END) AS chamados_encerrados
FROM
    view_chamados vc
GROUP BY
    vc.tipo_servico
ORDER BY
    total_chamados DESC;
-- Relatório de todos os chamados agrupados por tipo de serviço
CREATE VIEW view_chamados_por_tipo_servico AS
SELECT
    tipo_servico_id,
    tipo_servico,
    COUNT(chamado_id) AS total_chamados
FROM
    view_chamados
GROUP BY
    tipo_servico_id,
    tipo_servico;

-- Relatório de técnicos por departamento
SELECT
    d.departamento_id,
    d.nome AS nome_departamento,

    t.tecnico_id,
    t.nome_usuario AS nome_tecnico,
    t.nome_cargo,
    t.nome_area_atuacao

FROM
    view_tecnicos t
JOIN
    view_departamentos d ON t.departamento_id = d.departamento_id
ORDER BY
    d.nome, t.nome_usuario;
-- Relatório de chamados por solicitante

SELECT
    s.solicitante_id,
    s.nome_usuario AS nome_solicitante,
    s.email,
    s.telefone,
    s.nome_empresa,
    s.cnpj,

    COUNT(c.chamado_id) AS total_chamados,
    COUNT(CASE WHEN c.data_encerramento IS NOT NULL THEN 1 END) AS chamados_encerrados,
    COUNT(CASE WHEN c.data_encerramento IS NULL THEN 1 END) AS chamados_abertos

FROM
    view_chamados c
JOIN
    view_solicitantes s ON c.solicitante_id = s.solicitante_id

GROUP BY
    s.solicitante_id,
    s.nome_usuario,
    s.email,
    s.telefone,
    s.nome_empresa,
    s.cnpj

ORDER BY
    total_chamados DESC;
    
    SELECT
    c.chamado_id,
    c.titulo,
    c.descricao,
    c.data_abertura,
    c.data_encerramento,
    sc.descricao AS status_chamado,
    u_sol.nome AS solicitante,
    u_tec.nome AS tecnico
FROM
    Chamado c
JOIN
    StatusChamado sc ON c.status_id = sc.status_id
JOIN
    Solicitante s ON c.solicitante_id = s.solicitante_id
JOIN
    Usuario u_sol ON s.usuario_id = u_sol.usuario_id
LEFT JOIN -- LEFT JOIN caso um técnico não esteja atribuído ou o ID seja inválido
    Tecnico t ON c.tecnico_id = t.tecnico_id
LEFT JOIN
    Usuario u_tec ON t.usuario_id = u_tec.usuario_id
WHERE
    sc.descricao = 'Fechado';
