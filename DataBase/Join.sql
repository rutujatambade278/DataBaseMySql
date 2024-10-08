
-- create database TryQuiry;
-- CREATE TABLE Customers (CustomerID INT PRIMARY KEY ,CustomerName VARCHAR(50),ContactName VARCHAR(50));

INSERT INTO Customers (CustomerID, CustomerName, ContactName)VALUES 
-- (1, 'John Doe', 'John'),
-- (2, 'Jane Smith', 'Jane'),
-- (3, 'Mike Johnson', 'Mike');
 --   (4, 'mike smith', 'mike');
   (5,'rutuja tambade','');


-- CREATE TABLE Orders (OrderID INT PRIMARY KEY AUTO_INCREMENT,CustomerID INT,OrderDate DATE,FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID));

INSERT INTO Orders (OrderID, CustomerID, OrderDate)VALUES
(101, 1, '2024-01-10'),
(102, 1, '2024-01-15'),
(103, 2, '2024-02-01'),
(104, 3, '2024-03-15');  

-- INNER JOIN QUERY
-- SELECT Customers.CustomerID, Customers.CustomerName, Customers.ContactName, Orders.OrderID, Orders.OrderDate FROM Customers LEFT JOIN Orders
-- ON Customers.CustomerID = Orders.CustomerID;

-- LEFT JOIN QUERY
-- SELECT  Customers.CustomerID, Customers.CustomerName, Orders.OrderID, Orders.OrderDate FROM  Customers  
-- LEFT JOIN  Orders ON  Customers.CustomerID = Orders.CustomerID;

-- Right join query
SELECT  Customers.CustomerID, Customers.CustomerName, Orders.OrderID, Orders.OrderDate FROM Customers
RIGHT JOIN   Orders ON  Customers.CustomerID = Orders.CustomerID;

-- fullouter join
-- SELECT Customers.CustomerID, Customers.CustomerName, Orders.OrderID, Orders.OrderDate FROM Customers FULLOUTER  JOIN Orders
-- ON Customers.CustomerID = Orders.CustomerID;

 
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(50),
    ContactName VARCHAR(50)
);

DELETE FROM Orders
WHERE OrderID = 104;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeName VARCHAR(50) NOT NULL,
    ManagerID INT NULL
);

INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID) 
VALUES 
(1, 'Sachin Raje', NULL), 
(2, 'Ramakant Pande', 1), 
(3, 'Seeta Varma', 1), 
(4, 'Ganesh Patil', 2), 
(5, 'Sitaram Jadhav', 3);

SELECT  
    e.EmployeeID AS EmployeeID,
    e.EmployeeName AS EmployeeName,
    m.EmployeeName AS ManagerName
FROM  
    Employees e
LEFT JOIN 
    Employees m ON e.ManagerID = m.EmployeeID;