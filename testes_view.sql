INSERT INTO Chamado(Prioridade,Descricao,data,cod_cliente_pj)
VALUES 
(1,'Meu pc n liga','2025-07-25',1),
(3,'Meu pc n da video','2025-07-11',2),
(2,'Meu pc nao pega teclado','2025-07-23',3),
(1,'Minha impressora nao recarrega a tinta','2025-07-10',4),
(5,'Minha impressora nao imprime','2025-07-24',5),
(2,'Minha impressora nao liga','2025-07-12',6);

INSERT INTO ordem_servico(status, cod_chamado)
VALUES
("Concluida",1),
("Em andamento",2),
("Em andamento",3),
("Em andamento",4),
("Em andamento",5),
("Em andamento",6);

INSERT INTO computador(descricao)
VALUES
('i5 5005u 4gbram'),
('ryzen 5 5600 gt 16gbram'),
('ryzen 5 5600x 16gbram');

INSERT INTO impressora(descricao)
VALUES
('HP ink tank 1200'),
('HP eco tank 1200'),
('Edson eco tank 3100');

INSERT INTO envolveu_ordem_servico_computador(cod_comp, cod_num_ordem)
VALUES
(1,1),
(2,2),
(3,3);

INSERT INTO envolveu_ordem_servico_impressora(cod_impressora, cod_num_ordem)
VALUES
(1,4),
(2,5),
(3,6);



SELECT * FROM view_relatorio_resumido where data BETWEEN '2025-07-10' AND '2025-07-12';

SELECT * FROM view_relatorio_contrato_equipamento WHERE data_entrada BETWEEN '2024-01-01' AND '2024-12-31';
SELECT valor_total, COUNT(*) AS qtd_faturas, SUM(valor_servico) AS total_servicos FROM view_relatorio_tecnico_chamado_servico_fatura
WHERE data_emissao BETWEEN '2024-01-01' AND '2024-12-31' GROUP BY valor_total;



