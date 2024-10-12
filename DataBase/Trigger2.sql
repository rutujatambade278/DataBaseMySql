CREATE DATABASE Banking;
USE Banking;
CREATE TABLE customers (
    custid INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100),
    registrationdate DATETIME DEFAULT NOW(),
    balance DECIMAL(10, 2) DEFAULT 0
);

-- Create accounts table
CREATE TABLE accounts (
    acctid INT AUTO_INCREMENT PRIMARY KEY,
    custid INT,
    accounttype ENUM('current', 'saving') NOT NULL,
    createdon DATETIME DEFAULT NOW(),
    balance DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (custid) REFERENCES customers(custid) ON DELETE CASCADE
);

-- Create operations table
CREATE TABLE operations (
    operationid INT AUTO_INCREMENT PRIMARY KEY,
    accountid INT,
    amount DECIMAL(10, 2),
    operationdate DATETIME DEFAULT NOW(),
    operationtype ENUM('deposit', 'withdrawal', 'interest') NOT NULL,
    FOREIGN KEY (accountid) REFERENCES accounts(acctid) ON DELETE CASCADE
);

-- Create log table
CREATE TABLE logs (
    logid INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DATETIME DEFAULT NOW(),
    operationid INT,
    status ENUM('completed', 'failed') NOT NULL,
    FOREIGN KEY (operationid) REFERENCES operations(operationid) ON DELETE CASCADE
);



DELIMITER $$
CREATE TRIGGER after_customer_insert
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    -- Insert a new account for the customer with initial balance of 15000
    INSERT INTO accounts (custid, accounttype, balance) 
    VALUES (NEW.custid, 'saving', 15000);
    
    DECLARE acctid INT;
    SET acctid = LAST_INSERT_ID();

    -- Insert an initial deposit operation into the operations table
    INSERT INTO operations (accountid, amount, operationtype) 
    VALUES (acctid, 15000, 'deposit');

    -- Get the newly created operation id
    DECLARE opid INT;
    SET opid = LAST_INSERT_ID();

    -- Log the operation in the log table
    INSERT INTO logs (operationid, status) 
    VALUES (opid, 'completed');
END $$

DELIMITER ;
