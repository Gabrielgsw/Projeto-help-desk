USE HelpDesk;

DELIMITER //

CREATE PROCEDURE procedure_atualizar_os_concluidas()
BEGIN
    
    DECLARE os_concluida INT DEFAULT FALSE;
    DECLARE codigo_Fatura INT;
    DECLARE codigo_chamado INT;
    DECLARE os_status VARCHAR(50); 
    DECLARE fat_status VARCHAR(50); 
    
    DECLARE cursor_os_concluidas CURSOR FOR
        SELECT
            OS.cod_fatura,
            OS.cod_chamado,
            C.status,
            F.status
        FROM
            ORDEM_SERVICO AS OS
        JOIN
            CHAMADO AS C ON OS.cod_chamado = C.Seq
        JOIN
            FATURA AS F ON OS.cod_fatura = F.cod
        WHERE
            C.status = 'Resolvido'
            AND F.status != 'Paga'; -- Desconsidera faturas já pagas
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET os_concluida = TRUE; -- inserindo condição para que, caso o resultado seja encontrado, a leitura do cursor não seja mais necessária

    
    START TRANSACTION;

    
    OPEN cursor_os_concluidas;

    
    read_loop: LOOP
        FETCH cursor_os_concluidas INTO codigo_Fatura, codigo_chamado, os_status, fat_status;

        IF os_concluida THEN
            LEAVE read_loop;
        END IF;      
        
        
        IF fat_status != 'Paga' THEN -- Verificando apenas faturas não pagas
            UPDATE FATURA
            SET
                status = 'Paga'
            WHERE
                cod = codigo_Fatura;            
        END IF;

    END LOOP;
    
    CLOSE cursor_os_concluidas;
    
        COMMIT;
    
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_gerar_kpi_para_tecnico_especifico(
    IN p_matric_tec INT,
    IN dt_inicio DATE,
    IN dt_fim DATE
)
BEGIN
    -- Variáveis para os valores de KPI
    DECLARE v_kpi1_val DECIMAL(10, 2);
    DECLARE v_kpi2_val DECIMAL(10, 2);
    DECLARE v_kpi3_val DECIMAL(10, 2);
    DECLARE v_kpi4_val DECIMAL(10, 2);
    DECLARE v_kpi5_val DECIMAL(10, 2);
    DECLARE v_kpi6_val DECIMAL(10, 2);
    DECLARE v_seq INT;

    -- KPI 1: Tempo Médio de Resposta
    SELECT IFNULL(AVG(DATEDIFF(OS.data_criacao, C.data)), 0)
    INTO v_kpi1_val
    FROM CHAMADO C
    LEFT JOIN ORDEM_SERVICO OS ON C.Seq = OS.cod_chamado
    WHERE C.mat_tec = p_matric_tec
      AND C.data BETWEEN dt_inicio AND dt_fim;

    -- KPI 2: Taxa de Resolução
    SELECT IFNULL((SUM(CASE WHEN status = 'Resolvido' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 0)
    INTO v_kpi2_val
    FROM CHAMADO
    WHERE mat_tec = p_matric_tec
      AND data BETWEEN dt_inicio AND dt_fim;

    -- KPI 3: Chamados Fechados
    SELECT COUNT(*)
    INTO v_kpi3_val
    FROM CHAMADO
    WHERE mat_tec = p_matric_tec
      AND status = 'Resolvido'
      AND data BETWEEN dt_inicio AND dt_fim;

    -- KPI 4: Produtividade Diária
    SELECT IFNULL(COUNT(DISTINCT DATE(data)) / (DATEDIFF(dt_fim, dt_inicio) + 1), 0)
    INTO v_kpi4_val
    FROM CHAMADO
    WHERE mat_tec = p_matric_tec
      AND status = 'Resolvido'
      AND data BETWEEN dt_inicio AND dt_fim;

    -- KPI 5: Eficiência de Resolução
    SELECT IFNULL((SUM(CASE WHEN C.status = 'Resolvido' AND DATEDIFF(OS.data_criacao, C.data) = 0 THEN 1 ELSE 0 END) / COUNT(C.Seq)) * 100, 0)
    INTO v_kpi5_val
    FROM CHAMADO C
    LEFT JOIN ORDEM_SERVICO OS ON C.Seq = OS.cod_chamado
    WHERE C.mat_tec = p_matric_tec
      AND C.data BETWEEN dt_inicio AND dt_fim;

    -- KPI 6: Serviços concluídos
    SELECT COUNT(S.cod)
    INTO v_kpi6_val
    FROM SERVICO S
    JOIN ORDEM_SERVICO OS ON S.num_serv = OS.numero
    JOIN CHAMADO C ON OS.cod_chamado = C.Seq
    WHERE C.mat_tec = p_matric_tec
      AND S.status = 'Concluído'
      AND C.data BETWEEN dt_inicio AND dt_fim;

    -- === BLOCO KPI 1 e 2 ===
    SELECT IFNULL(MAX(Sequencial), 0) + 1
    INTO v_seq
    FROM KPI
    WHERE matric_tec = p_matric_tec;

    INSERT INTO KPI (matric_tec, Sequencial, KPI_1, dsc_KPI_1, KPI_2, dsc_KPI_2)
    VALUES (
        p_matric_tec, v_seq,
        'Tempo Médio de Resposta', 'Média de tempo para primeira resposta',
        'Taxa de Resolução', 'Porcentagem de chamados resolvidos'
    );

    INSERT INTO VALOR_KPI (matric_tec, kpi_sequencial, data_registro, valor_kpi_numerico)
    VALUES
        (p_matric_tec, v_seq, CURDATE(), v_kpi1_val),
        (p_matric_tec, v_seq, CURDATE(), v_kpi2_val);

    -- === BLOCO KPI 3 e 4 ===
    SELECT IFNULL(MAX(Sequencial), 0) + 1
    INTO v_seq
    FROM KPI
    WHERE matric_tec = p_matric_tec;

    INSERT INTO KPI (matric_tec, Sequencial, KPI_1, dsc_KPI_1, KPI_2, dsc_KPI_2)
    VALUES (
        p_matric_tec, v_seq,
        'Chamados Fechados', 'Número de chamados fechados pelo técnico',
        'Produtividade Diária', 'Número de chamados resolvidos por dia'
    );

    INSERT INTO VALOR_KPI (matric_tec, kpi_sequencial, data_registro, valor_kpi_numerico)
    VALUES
        (p_matric_tec, v_seq, CURDATE(), v_kpi3_val),
        (p_matric_tec, v_seq, CURDATE(), v_kpi4_val);

    -- === BLOCO KPI 5 e 6 ===
    SELECT IFNULL(MAX(Sequencial), 0) + 1
    INTO v_seq
    FROM KPI
    WHERE matric_tec = p_matric_tec;

    INSERT INTO KPI (matric_tec, Sequencial, KPI_1, dsc_KPI_1, KPI_2, dsc_KPI_2)
    VALUES (
        p_matric_tec, v_seq,
        'Eficiência de Resolução', 'Percentual de chamados resolvidos no primeiro contato',
        'Serviços concluídos', 'Número total de serviços concluídos'
    );

    INSERT INTO VALOR_KPI (matric_tec, kpi_sequencial, data_registro, valor_kpi_numerico)
    VALUES
        (p_matric_tec, v_seq, CURDATE(), v_kpi5_val),
        (p_matric_tec, v_seq, CURDATE(), v_kpi6_val);

END //

DROP PROCEDURE IF EXISTS sp_gerar_kpi_para_tecnico_especifico;

CALL sp_gerar_kpi_para_tecnico_especifico(103, '2025-07-01', '2025-07-31');

SELECT * FROM KPI WHERE matric_tec = 103;
SELECT * FROM VALOR_KPI;
SELECT * FROM CHAMADO