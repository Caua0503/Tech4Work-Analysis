DELIMITER //

CREATE TRIGGER trg_atualiza_estoque
AFTER INSERT ON vendas
FOR EACH ROW
BEGIN
    UPDATE produtos
    SET estoque = estoque - NEW.quantidade
    WHERE id = NEW.id_produto;
END;
//

DELIMITER ;
