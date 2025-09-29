-- =================================================================
-- Question 1: Achieving 1NF

-- Step 1: Create the original ProductDetail table
CREATE TABLE ProductDetail_Original (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert the original data with multi-valued Products column
INSERT INTO ProductDetail_Original (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 2: Create the normalized table in 1NF
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Step 3: Transform data to 1NF by splitting multi-valued attributes
-- Each row now represents a single product for an order
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Query to view the 1NF table
SELECT * FROM ProductDetail_1NF 
ORDER BY OrderID, Product;

-- Question 2: Achieving 2NF 

-- Problem: The OrderDetails table has partial dependencies
-- CustomerName depends only on OrderID, not on the full composite key (OrderID + Product)
-- Solution: Decompose into separate tables to eliminate partial dependencies

-- Step 1: Create the original OrderDetails table already in 1NF
CREATE TABLE OrderDetails_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

-- Insert the given data
INSERT INTO OrderDetails_1NF (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Step 2: Create normalized tables in 2NF
-- Table 1: Orders (CustomerName depends only on OrderID)
CREATE TABLE Orders_2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- Table 2: OrderItems (Quantity depends on the full composite key: OrderID + Product)
CREATE TABLE OrderItems_2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders_2NF(OrderID)
);

-- Step 3: Insert data into the normalized 2NF tables
-- Insert unique orders with customer information
INSERT INTO Orders_2NF (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Insert order items with quantities
INSERT INTO OrderItems_2NF (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Query to view the 2NF tables
SELECT o.OrderID, o.CustomerName, oi.Product, oi.Quantity
FROM Orders_2NF o
JOIN OrderItems_2NF oi ON o.OrderID = oi.OrderID
ORDER BY o.OrderID, oi.Product;


-- 🔍 Verification Queries

-- Verify 1NF transformation
SELECT 'Original ProductDetail (Violates 1NF)' AS Description;
SELECT * FROM ProductDetail_Original;

SELECT '1NF Normalized ProductDetail' AS Description;
SELECT * FROM ProductDetail_1NF ORDER BY OrderID, Product;

-- Verify 2NF transformation
SELECT 'Original OrderDetails (1NF but violates 2NF)' AS Description;
SELECT * FROM OrderDetails_1NF ORDER BY OrderID, Product;

SELECT '2NF Normalized - Orders Table' AS Description;
SELECT * FROM Orders_2NF ORDER BY OrderID;

SELECT '2NF Normalized - OrderItems Table' AS Description;
SELECT * FROM OrderItems_2NF ORDER BY OrderID, Product;

SELECT '2NF Combined View' AS Description;
SELECT o.OrderID, o.CustomerName, oi.Product, oi.Quantity
FROM Orders_2NF o
JOIN OrderItems_2NF oi ON o.OrderID = oi.OrderID
ORDER BY o.OrderID, oi.Product;
