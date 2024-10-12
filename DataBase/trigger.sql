CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT,
    order_date DATETIME,
    status ENUM('pending', 'completed', 'canceled')
);
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT
);
DELIMITER $$
CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    -- Get the available stock for the ordered product
    SELECT stock_quantity INTO available_stock
    FROM inventory
    WHERE product_id = NEW.product_id;
    
    -- Check if there is enough stock
    IF available_stock IS NOT NULL AND available_stock >= NEW.quantity THEN
        -- Update the inventory stock
        UPDATE inventory
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    ELSE
        -- If stock is insufficient, raise an error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for the product';
    END IF;
END $$
DELIMITER ;
INSERT INTO inventory (product_id, stock_quantity)
VALUES (1, 56),
       (2, 78),
       (5, 0);

INSERT INTO orders (product_id, quantity, order_date, status)
VALUES (1, 3, NOW(), 'pending');

SELECT * FROM orders;
SELECT * FROM inventory;
