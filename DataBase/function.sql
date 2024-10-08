-- DELIMITER //

-- CREATE FUNCTION calculate_tax(
--     amount DECIMAL(10,2))
-- RETURNS DECIMAL(10,2)
-- DETERMINISTIC
-- BEGIN
--     RETURN amount * 0.2;
-- END //
-- DELIMITER ;

-- select calculate_tax(100)as tax_amount;

-- DELIMITER //

-- CREATE FUNCTION days_between(start_date DATE, end_date DATE)
-- RETURNS INT
-- DETERMINISTIC
-- BEGIN
--     RETURN DATEDIFF(end_date, start_date);
-- END //
-- DELIMITER ;

-- SELECT days_between('2024-01-01', '2024-01-10');





