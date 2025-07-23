USE HelpDesk;

DELIMITER //
 -- DROP FUNCTION IF EXISTS verificar_contrato_em_dia;
-- Função para retornar contrato em dia
CREATE FUNCTION verificar_contrato_em_dia(cod_cliente INT)
RETURNS BOOLEAN
READS SQL DATA 
DETERMINISTIC 
BEGIN
    DECLARE contrato_em_dia BOOLEAN DEFAULT FALSE;
    DECLARE data_atual DATE;
    
    SET data_atual = CURDATE();

    -- Verifica se existe algum contrato "ativo" para o cliente, cuja data atual esteja dentro do período de vigência 
    SELECT TRUE INTO contrato_em_dia
    FROM CONTRATO
    WHERE cod_cliente_pj = cod_cliente
      AND status = 'Ativo' 
      AND dt_inicio <= data_atual
      AND dt_fim >= data_atual
    LIMIT 1; -- somente 1 contrato já é suficiente

    RETURN contrato_em_dia;
END //

DELIMITER ;

DELIMITER //

-- DROP FUNCTION IF EXISTS verificar_fatura_criada; 

CREATE FUNCTION verificar_fatura_criada(cod_ordem INT)
RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC 

BEGIN
    DECLARE os_status VARCHAR(50);
    DECLARE os_data_conclusao DATE; 
    DECLARE fatura_cod INT;
    DECLARE fatura_data_emissao DATE;

    -- Obter o status e a data de 'conclusão' (dt_devida) da Ordem de Serviço
    SELECT
        OS.status,
        OS.dt_devida, -- Usando dt_devida como a data de referência para conclusão da OS
        OS.cod_fatura
    INTO
        os_status,
        os_data_conclusao,
        fatura_cod
    FROM
        ORDEM_SERVICO AS OS
    WHERE
        OS.numero = cod_ordem;

    -- Verificar se a OS existe e se foi concluída
    IF os_status IS NULL OR os_status NOT IN ('Finalizada') THEN       
        RETURN FALSE;  -- Retorna false, caso a OS não seja encontrada ou não esteja finalizada
    END IF;
    

    -- Obtendo a data de emissão da Fatura associada a OS   
    SELECT
        data_emissao 
    INTO
        fatura_data_emissao
    FROM
        FATURA 
    WHERE
        cod = fatura_cod;
    
    IF fatura_data_emissao IS NULL THEN        
        RETURN FALSE; -- Retorna falso caso a fatura não exista
    END IF;
    
    IF fatura_data_emissao >= os_data_conclusao THEN
        RETURN TRUE; -- Caso a data de emissão da fatura seja maior que a de finalização da OS, retorna true para fatura já criada
    ELSE
        RETURN FALSE; -- False caso contrário
    END IF;

END //

DELIMITER ;
