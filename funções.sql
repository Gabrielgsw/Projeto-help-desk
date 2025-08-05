USE HelpDesk;

-- Função 1

DELIMITER //
 -- DROP FUNCTION IF EXISTS verificar_contrato_em_dia;
-- Função para retornar contrato em dia
CREATE FUNCTION verificar_contrato_em_dia(cod_cliente INT)
RETURNS BOOLEAN
READS SQL DATA -- Indica que a função lê dados, mas não os modifica
DETERMINISTIC -- Indica que a função sempre retorna o mesmo resultado para os mesmos inputs
BEGIN
    DECLARE contrato_em_dia BOOLEAN DEFAULT FALSE;
    DECLARE data_atual DATE;
    
    SET data_atual = CURDATE();

    -- Verifica se existe algum contrato "ativo" para o cliente
    -- cuja data atual esteja dentro do período de vigência.
    SELECT TRUE INTO contrato_em_dia
    FROM CONTRATO
    WHERE cod_cliente_pj = cod_cliente
      AND status = 'Ativo' -- Assumindo 'Ativo' como status de contrato em dia
      AND dt_inicio <= data_atual
      AND dt_fim >= data_atual
    LIMIT 1; -- somente 1 contrato já é suficiente

    RETURN contrato_em_dia;
END //

DELIMITER ;

-- Função 2

DELIMITER //

-- DROP FUNCTION IF EXISTS verificar_pagamentos_em_dia; 

-- Retorna TRUE se o cliente está em dia com os pagamentos, ou FALSE se há parcelas vencidas não pagas
CREATE FUNCTION verificar_pagamentos_em_dia(p_cod_cliente INT)
RETURNS BOOLEAN                 
READS SQL DATA                 
DETERMINISTIC                 
BEGIN
    -- Declara variável para contar quantas parcelas vencidas e não pagas existem
    DECLARE existe_parcela_vencida INT;

    -- Consulta para verificar se há parcelas vencidas e ainda não pagas para o cliente
    SELECT COUNT(*) INTO existe_parcela_vencida
    FROM FATURA AS F
    JOIN PARCELA_FATURA AS PF ON F.cod = PF.cod_fatura
    WHERE F.cod_cliente_pj = p_cod_cliente                 
      AND PF.data_vencimento < CURDATE()                   -- Parcela já vencida
      AND PF.status_parcela != 'Paga';                     -- Parcela ainda não paga

    -- Se existir pelo menos uma parcela vencida e não paga, retorna FALSE
    IF existe_parcela_vencida > 0 THEN
        RETURN FALSE; -- Cliente tem pendências
    ELSE
        RETURN TRUE;  -- Cliente está em dia
    END IF;

END //

DELIMITER ;




-- Função 3
-- DROP FUNCTION IF EXISTS verificar_fatura_criada; 
DELIMITER //

-- Função que verifica se uma fatura foi criada corretamente para uma ordem de serviço
-- Retorna TRUE se a fatura foi emitida após ou na data de conclusão estimada
CREATE FUNCTION verificar_fatura_criada(cod_ordem INT)
RETURNS BOOLEAN                      
READS SQL DATA                       
DETERMINISTIC                        
BEGIN
    -- Declaração de variáveis locais
    DECLARE os_status VARCHAR(50);         -- Status da ordem de serviço
    DECLARE os_data_conclusao DATE;        -- Data estimada de conclusão da OS (data_criacao + prazo_em_dias)
    DECLARE fatura_cod INT;                -- Código da fatura associada
    DECLARE fatura_data_emissao DATE;      -- Data de emissão da fatura

    -- Busca o status da OS, a data estimada de conclusão e o código da fatura associada
    SELECT
        OS.status,
        DATE_ADD(OS.data_criacao, INTERVAL OS.prazo_em_dias DAY), -- Soma o prazo à data de criação
        OS.cod_fatura
    INTO
        os_status,
        os_data_conclusao,
        fatura_cod
    FROM
        ORDEM_SERVICO AS OS
    WHERE
        OS.numero = cod_ordem;

    -- Se a OS não está concluída, ou status é nulo, retorna FALSE
    IF os_status IS NULL OR os_status NOT IN ('Concluída') THEN
        RETURN FALSE;
    END IF;

    -- Se não há fatura associada, retorna FALSE
    IF fatura_cod IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Busca a data de emissão da fatura associada
    SELECT
        data_emissao
    INTO
        fatura_data_emissao
    FROM
        FATURA
    WHERE
        cod = fatura_cod;

    -- Se a data de emissão da fatura for nula, retorna FALSE
    IF fatura_data_emissao IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Verifica se a fatura foi emitida na data estimada de conclusão da OS ou depois
    IF fatura_data_emissao >= os_data_conclusao THEN
        RETURN TRUE; -- Fatura válida
    ELSE
        RETURN FALSE; -- Fatura inválida, emitida antes da data de conclusão da OS
    END IF;

END //

DELIMITER ;




    
    
  -- Teste função 1
  
	SELECT * FROM CLIENTE_PJ;
    SELECT * FROM CONTRATO WHERE cod_cliente_pj = 4;
    SELECT * FROM CONTRATO WHERE cod_cliente_pj = 105;
  
	SELECT verificar_contrato_em_dia(105);
  
  -- Teste função 2
  
	SELECT * FROM CLIENTE_PJ ;
    SELECT * FROM Fatura WHERE cod_cliente_pj = 1;
  
    
    SELECT * FROM Fatura WHERE cod_cliente_pj = 2;
    
	SELECT verificar_pagamentos_em_dia(2);
  
  
  
  -- Teste função 3
	SELECT verificar_fatura_criada(3) AS fatura_criada_os3;	
	SELECT verificar_fatura_criada(7) AS fatura_criada_os3;	
    
    SELECT * FROM ORDEM_SERVICO where status = 'Concluída';




INSERT INTO FATURA (cod, n_parcelas, data_emissao, valor_total, status, cod_cliente_pj) VALUES
(11, 3, '2025-07-23', 1500.00, 'Paga', 1);
