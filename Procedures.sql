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
