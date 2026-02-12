DROP PROCEDURE IF EXISTS registrar_venda_kit;
DELIMITER //
CREATE PROCEDURE registrar_venda_kit(
	IN p_id_venda INT,
	IN p_id_produto INT,
	IN p_quantidade INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE pid INT;
	DECLARE qtd INT;
	DECLARE preco_kit DECIMAL(10, 2);
	DECLARE cur CURSOR FOR
		SELECT id_produto, quantidade FROM kit_itens WHERE id_kit = p_id_produto;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	-- Buscar o preço do kit antes de abrir o cursor
	SELECT preco INTO preco_kit FROM kits WHERE id = p_id_produto;

	-- Inserir o item do tipo kit
	INSERT INTO vendas_itens (id_venda, id_produto, tipo_item, quantidade, preco_unitario)
	VALUES (p_id_venda, p_id_produto, 'kit', p_quantidade, preco_kit);

	-- Abrir o cursor e percorrer os itens do kit
	OPEN cur;
	read_loop: LOOP
		FETCH cur INTO pid, qtd;
		IF done THEN
			LEAVE read_loop;
		END IF;

		-- Atualiza o estoque dos produtos componentes
		UPDATE produtos
		SET estoque = estoque - (p_quantidade * qtd)
		WHERE id = pid;
	END LOOP;
	CLOSE cur;
END;
//

DELIMITER ;
