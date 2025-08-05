USE HelpDesk;

 -- Relatório 1
 CREATE OR REPLACE VIEW view_relatorio_resumido AS
SELECT
c.razao_social AS razao_social,

ch.prioridade AS prioridade_chamado,
ch.descricao AS descricao_chamado,
ch.data,

os.numero AS no_os,
os.status AS status_os,

pc.descricao AS equipamento

FROM
	cliente_pj c
JOIN
	chamado ch ON c.cod = ch.cod_cliente_pj
JOIN
	ordem_servico os ON os.cod_chamado = ch.seq
JOIN
	envolveu_ordem_servico_computador eosc ON eosc.cod_num_ordem = os.numero
JOIN
	computador pc ON eosc.cod_comp = pc.cod
    
UNION

SELECT
c.razao_social AS razao_social,

ch.prioridade AS prioridade_chamado,
ch.descricao AS descricao_chamado,
ch.data,

os.numero AS no_os,
os.status AS status_os,

imp.descricao as equipamento

FROM
	cliente_pj c
JOIN
	chamado ch ON c.cod = ch.cod_cliente_pj
JOIN
	ordem_servico os ON os.cod_chamado = ch.seq
JOIN
	envolveu_ordem_servico_impressora eosi ON eosi.cod_num_ordem = os.numero
JOIN
	impressora imp ON eosi.cod_impressora = imp.cod;

-- Relatório 2
CREATE OR REPLACE VIEW view_relatorio_cliente_os_servico AS
SELECT
	c.razao_social,
    c.prioridade AS prioridade_razao,
    c.endereco,
    c.fone,
    
    os.status AS status_OS,
    os.data_criacao,
    os.prazo_em_dias,
	
    ts.descricao AS tipo_servico,
    
    s.descricao,
    s.valor
    
FROM
	chamado ch
JOIN 
	ordem_servico os ON ch.Seq = os.cod_chamado
JOIN
	cliente_pj c ON ch.cod_cliente_pj = c.cod
JOIN
	servico s ON os.numero = s.num_serv
JOIN
	tipo_servico ts ON s.cod_tipo_servico = ts.cod;
 
 -- Relatório 3
 CREATE OR REPLACE VIEW Vw_Relatorio_Equipamentos_Contrato AS
SELECT
    us.nome AS Nome_Unidade_Suporte,
    us.CNPJ AS CNPJ_Unidade,
    cpj.razao_social AS Cliente,
    ct.cod AS Codigo_Contrato,
    ct.dt_inicio AS Data_Inicio_Contrato,
    ct.status AS Status_Contrato,
    eq.Tipo_Equipamento,
    eq.Codigo_Equipamento,
    eq.Descricao_Equipamento,
    eq.Data_Entrada_Equipamento,
    ct.cod_cliente_pj,
    ct.cod_unidade
FROM
    CONTRATO AS ct
JOIN
    UNIDADE_SUPORTE AS us ON ct.cod_unidade = us.CNPJ
JOIN
    CLIENTE_PJ AS cpj ON ct.cod_cliente_pj = cpj.Cod
JOIN
    (
        -- Seleciona todos os computadores
        SELECT
            cod_contrato,
            'Computador' AS Tipo_Equipamento,
            cod AS Codigo_Equipamento,
            CONCAT(fabricante, ' - ', tipo) AS Descricao_Equipamento,
            data_entrada AS Data_Entrada_Equipamento
        FROM
            COMPUTADOR
        UNION ALL
        -- Seleciona todas as impressoras
        SELECT
            cod_contrato,
            'Impressora' AS Tipo_Equipamento,
            cod AS Codigo_Equipamento,
            CONCAT(fabricante, ' - ', modelo) AS Descricao_Equipamento,
            data_entrada AS Data_Entrada_Equipamento
        FROM
            IMPRESSORA
    ) AS eq ON ct.cod = eq.cod_contrato;


-- Relatório 4
CREATE OR REPLACE VIEW Vw_Relatorio_Faturamento_Tecnico AS
SELECT
    F.cod AS Codigo_Fatura,
    F.valor_total AS Valor_Total_Fatura,
    F.data_emissao AS Data_Emissao_Fatura,
    F.status AS Status_Fatura,
    OS.numero AS Numero_OS,
    OS.status AS Status_OS,
    T.nome AS Nome_Tecnico,
    T.Matricula AS Matricula_Tecnico,
    C.Seq AS Codigo_Chamado,
    C.tipo AS Tipo_Chamado,
    -- Agrega a descrição de todos os serviços da OS em um único campo de texto
    GROUP_CONCAT(S.descricao SEPARATOR '; ') AS Servicos_Realizados,
    -- Soma o valor de todos os serviços da OS
    SUM(S.valor) AS Soma_Valor_Servicos
FROM
    ORDEM_SERVICO AS OS
LEFT JOIN
    FATURA AS F ON OS.cod_fatura = F.cod
LEFT JOIN
    CHAMADO AS C ON OS.cod_chamado = C.Seq
LEFT JOIN
    TECNICO AS T ON C.mat_tec = T.Matricula
LEFT JOIN
    SERVICO AS S ON OS.numero = S.num_serv
-- Agrupa por ordem de serviço
GROUP BY
    OS.numero, F.cod, C.Seq, T.Matricula;
 


 -- Teste relatório 1
 SELECT * FROM view_relatorio_resumido where data BETWEEN '2025-01-10' AND '2025-08-12'; 
  
 -- Teste relatório 2
SELECT * FROM view_relatorio_cliente_os_servico where data_criacao BETWEEN '2025-07-25' AND '2025-07-27';

-- Teste relatório 3

SELECT  * FROM Vw_Relatorio_Equipamentos_Contrato WHERE  
    Data_Inicio_Contrato BETWEEN '2024-01-01' AND '2025-12-31'
ORDER BY
    Nome_Unidade_Suporte,
    Cliente,
    Tipo_Equipamento;

-- Teste relatório 4

SELECT * FROM Vw_Relatorio_Faturamento_Tecnico WHERE    
    Data_Emissao_Fatura BETWEEN '2024-01-01' AND '2025-12-30'
    AND Valor_Total_Fatura IS NOT NULL 
ORDER BY    
    Valor_Total_Fatura DESC;
