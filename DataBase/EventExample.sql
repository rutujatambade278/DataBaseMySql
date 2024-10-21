CREATE TABLE customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    phone_number BIGINT
);

DELIMITER //
CREATE PROCEDURE my_procedure(IN cust_name VARCHAR(100), IN cust_phone BIGINT)
BEGIN
    -- Insert customer details into the customer table
    INSERT INTO customer (name, phone_number)
    VALUES (cust_name, cust_phone);
END //
DELIMITER ;

Drop PROCEDURE my_procedure;

CALL my_procedure('Neha','2345678');
SELECT * FROM customer;

	SHOW VARIABLES LIKE 'event_scheduler';
	SET GLOBAL event_scheduler = ON;

CREATE EVENT my_event
ON SCHEDULE EVERY 1 DAY 
STARTS '2024-10-18  12:47:00'
DO
CALL my_procedure();

SHOW EVENTS;
DROP EVENT IF EXISTS my_event;
