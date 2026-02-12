DELIMITER //

CREATE TRIGGER trg_atualiza_estoque_produto
AFTER INSERT ON vendas_itens
FOR EACH ROW
BEGIN
    IF NEW.tipo_item = 'produto' THEN
        UPDATE produtos
        SET estoque = estoque - NEW.quantidade
        WHERE id = NEW.id_produto;
    END IF;
END;
//

DELIMITER ;
