DELIMITER //

CREATE TRIGGER trg_atualiza_estoque_kit
AFTER INSERT ON vendas_itens
FOR EACH ROW
BEGIN
    IF NEW.tipo_item = 'kit' THEN
        DECLARE done INT DEFAULT 0;
        DECLARE pid INT;
        DECLARE qtd INT;

        -- Cursor para buscar os produtos do kit e suas quantidades
        DECLARE cur CURSOR FOR 
            SELECT id_produto, quantidade FROM kit_itens WHERE id_kit = NEW.id_produto;

        -- Handler para fim do cursor
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        OPEN cur;
        read_loop: LOOP
            FETCH cur INTO pid, qtd;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Atualiza o estoque do produto com base na quantidade do kit * quantidade vendida
            UPDATE produtos
            SET estoque = estoque - (qtd * NEW.quantidade)
            WHERE id = pid;
        END LOOP;
        CLOSE cur;
    END IF;
END;
//

DELIMITER ;
