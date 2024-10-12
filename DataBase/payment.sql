CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10, 2),
    payment_date DATETIME,
    status ENUM('pending', 'completed')
);

DELIMITER $$

CREATE TRIGGER after_payment_completed
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    -- Check if the payment status is 'completed'
    IF NEW.status = 'completed' THEN
        -- Update the corresponding order status to 'completed'
        UPDATE orders
        SET status = 'completed'
        WHERE order_id = NEW.order_id;
    END IF;
END $$

DELIMITER ;

INSERT INTO orders (product_id, quantity, order_date, status)
VALUES (2, 4, NOW(), 'pending');

INSERT INTO payments (order_id, amount, payment_date, status)
VALUES (4, 300.00, NOW(), 'completed');

SELECT * FROM orders;

