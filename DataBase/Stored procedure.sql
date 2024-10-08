-- ------------------------Insert data customer stored procedure------------------------------
DELIMITER //
CREATE PROCEDURE add_customer(
    IN p_CustomerName VARCHAR(50),
    IN p_ContactName VARCHAR(50)
)
BEGIN
    INSERT INTO customers (CustomerName, ContactName)
    VALUES (p_CustomerName, p_ContactName);
END //
DELIMITER ;

CALL add_customer('sejal', '4521566333');

-- ------------------------Insert data employee stored procedure------------------------------
DELIMITER //
CREATE PROCEDURE add_employee(IN p_EmployeeName VARCHAR(50),IN p_ManagerID INT)
BEGIN
    INSERT INTO employees (EmployeeName, ManagerID)VALUES (p_EmployeeName, p_ManagerID);
END //
DELIMITER ;

CALL add_employee('Mansi ', 1);

DELIMITER //

-- ------------------------Update data employee stored procedure------------------------------
DELIMITER //
CREATE PROCEDURE update_employee(IN p_EmployeeID INT,IN p_EmployeeName VARCHAR(50),IN p_ManagerID INT)
BEGIN
    UPDATE employees SET EmployeeName = p_EmployeeName,
        ManagerID = p_ManagerID
        WHERE EmployeeID = p_EmployeeID;
END //
DELIMITER ;

CALL update_employee(1, 'Shruti', 2);

-- -------------------delete data employee stored procedure--------------------------------------
DELIMITER //
CREATE PROCEDURE delete_employee(IN p_EmployeeID INT)
BEGIN
DELETE  from employees WHERE EmployeeID=p_EmployeeID;
END//
DELIMITER ;

CALL delete_employee(4);
