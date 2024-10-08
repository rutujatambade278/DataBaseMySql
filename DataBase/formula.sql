DELIMITER //
CREATE PROCEDURE calculate_circle_properties (IN radius DECIMAL(10,2),OUT area DECIMAL(10,2),OUT circumference DECIMAL(10,2))
BEGIN
    SET area = 3.1416 * radius * radius;
    SET circumference = 2 * 3.1416 * radius;
END //
DELIMITER ;
CALL calculate_circle_properties(5, @circle_area, @circle_circumference);
SELECT @circle_area AS 'Area of Circle', @circle_circumference AS 'Circumference of Circle';


DELIMITER //
CREATE PROCEDURE calculate_circle_area (IN radius DECIMAL(10,2),OUT area DECIMAL(10,2)
)
BEGIN
SET area = 3.1416 * radius * radius;
END //
DELIMITER ;
CALL calculate_circle_area(6, @circle_area);
SELECT @circle_area AS 'Area of Circle';
