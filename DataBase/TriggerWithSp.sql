drop database if exists Banking;

create database Banking;

use Banking;

CREATE TABLE customers (
    custid INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(255) NOT NULL,
    registrationdate DATE NOT NULL
);


CREATE TABLE accounts (
    acctid INT AUTO_INCREMENT PRIMARY KEY,
    custid INT NOT NULL,
    accounttype ENUM('current', 'saving') NOT NULL,
    createdon DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    FOREIGN KEY (custid) REFERENCES customers(custid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE operations (
    operationid INT AUTO_INCREMENT PRIMARY KEY,
    accountid INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    operationsdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    operationtype ENUM('deposit', 'withdrawal', 'transfer') NOT NULL,
    FOREIGN KEY (accountid) REFERENCES accounts(acctid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE log (
    logid INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    operationid INT NOT NULL,
    status ENUM('completed', 'pending', 'failed') NOT NULL DEFAULT 'completed',
    FOREIGN KEY (operationid) REFERENCES operations(operationid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


INSERT INTO customers (fullname, registrationdate) VALUES
('Ajinkya Tambade ', '2024-01-15'),
('Rutuja Tambade', '2023-03-22'),
('Mansi Nighot', '2023-05-10'),
('Sharyu Koli', '2024-07-05'),
('Shridhar Patil', '2023-09-18');

select * from customers;

select * from accounts;

-- Create a trigger to register new customer in customers table.for registering customer with initial balance 15000.

DROP TRIGGER IF EXISTS after_customer_insert;

DELIMITER $$

CREATE TRIGGER after_customer_insert
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    INSERT INTO accounts (custid, accounttype, balance)
    VALUES (NEW.custid, 'saving', 15000.00);
END$$

DELIMITER ;


insert into customers (fullname, registrationdate) VALUES
('Neha bhor', '2024-01-05');

select * from customers;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

 
 
/* customer insert trigger --
insert new customer details into customers
insert new account entry into accounts table
insert new operation entury into operations table.
insert new  log entry into logs table */



DELIMITER $$

CREATE TRIGGER after_insert_customers
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    DECLARE new_acctid INT;
    DECLARE new_operationid INT;

    INSERT INTO accounts (custid, accounttype, createdon, balance)
    VALUES (NEW.custid, 'saving', NOW(), 15000.00);

    SET new_acctid = LAST_INSERT_ID();

    INSERT INTO operations (accountid, amount, operationsdate, operationtype)
    VALUES (new_acctid, 15000.00, NOW(), 'deposit');

    SET new_operationid = LAST_INSERT_ID();

    INSERT INTO log (operationid, status)
    VALUES (new_operationid, 'completed');

  
END$$

DELIMITER ;

INSERT INTO customers (fullname, registrationdate) VALUES
('sejal Ernde', '2023-09-11');

SELECT * FROM customers WHERE fullname = 'sejal Ernde';

SELECT * FROM accounts WHERE custid = 8;

SELECT * FROM operations WHERE accountid = 3;

SELECT * FROM log WHERE operationid = 1;
-------------------------------------------------------------------------------------------------------------------------------------------------

/* Create Stored procedure to deposite interest into Accounts table
    in  accountid , interestrate
	Check existing balance and update balance with caluclate interest based on interest set
	amount transfer entry to be added into operation with status "interest"
    Call stored procedure with accountid  and interest rate.*/