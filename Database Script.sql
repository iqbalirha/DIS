-- Replicated tables asia
CREATE TABLE Customer (
    Cust_id SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Country VARCHAR(50),
    Phn_no VARCHAR(20)
);

-- Region-specific tables
CREATE TABLE "Order" (
    Order_id SERIAL PRIMARY KEY,
    Cust_id INTEGER REFERENCES Customer(Cust_id),
    Order_dt TIMESTAMP,
    Status VARCHAR(50)
);

CREATE TABLE Payment (
    Payment_id SERIAL PRIMARY KEY,
    Order_id INTEGER REFERENCES "Order"(Order_id),
    Amount DECIMAL(10,2),
    Payment_dt TIMESTAMP
);
CREATE TABLE Product (
    Product_id SERIAL PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    Description TEXT,
    Seller_id INTEGER,
    StockLevel INTEGER
);

-- Insert sample data for Asia region
INSERT INTO Customer (Name, Email, Country, Phn_no) VALUES
    ('Saikat Banik', 'saikat@gmail.com', 'India', '+91-555-0101'),
    ('Hidetoshi Yuki', 'hidetoshi@gmail.com', 'Japan', '+81-555-0102'),
    ('Iqbal Hossen', 'iqbal@gmail.com', 'Bangladesh', '+88-555-0103'),
    ('Dominik Saimon', 'dominik@gmail.com', 'Germany', '+49-555-0101'),
    ('Marie Dubois', 'marie@gmail.com', 'France', '+33-555-0102'),
    ('Giuseppe Romano', 'giuseppe@gmail.com', 'Italy', '+39-555-0103'),
    ('John Smith', 'john@gmail.com', 'USA', '+1-555-0101'),
    ('Dakota Johnson', 'dakota@gmail.com', 'USA', '+1-555-0102'),
    ('Michael Brown', 'michael@gmail.com', 'USA', '+1-555-0103');

---Fragmentation---
CREATE TABLE customer_as AS
SELECT * FROM Customer
WHERE Country IN ('India', 'Japan', 'Bangladesh');

INSERT INTO Product (ProductName, Price, Description, Seller_id, StockLevel) VALUES
    ('Laptop', 949.99, 'High-performance laptop', 1, 60),
    ('Smartphone', 679.99, 'Latest Asian smartphone', 2, 120),
    ('Tablet', 319.99, 'Premium tablet', 3, 90),
    ('Laptop', 899.99, 'Premium laptop model', 1, 40),
    ('Smartphone', 649.99, 'Latest EU smartphone', 2, 80),
    ('Tablet', 349.99, 'Lightweight tablet', 3, 60),
    ('Laptop', 999.99, 'High-end laptop', 1, 50),
    ('Smartphone', 699.99, 'Latest smartphone model', 2, 100),
    ('Tablet', 399.99, 'Portable tablet device', 3, 75);

INSERT INTO "Order" (Cust_id, Order_dt, Status) VALUES
    (1, '2024-05-01 13:00:00', 'Pending'),
    (2, '2024-05-02 16:15:00', 'Shipped'),
    (3, '2024-05-03 10:30:00', 'Delivered');

INSERT INTO Payment (Order_id, Amount, Payment_dt) VALUES
    (1, 949.99, '2024-05-01 13:05:00'),
    (2, 679.99, '2024-05-02 16:20:00'),
    (3, 319.99, '2024-05-03 10:35:00');


us------
CREATE DATABASE us_region;
\c us_region;


-- Replicated tables
CREATE TABLE Customer (
    Cust_id SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Country VARCHAR(50),
    Phn_no VARCHAR(20)
);


--------


-- Region-specific tables
CREATE TABLE "Order" (
    Order_id SERIAL PRIMARY KEY,
    Cust_id INTEGER REFERENCES Customer(Cust_id),
    Order_dt TIMESTAMP,
    Status VARCHAR(50)
);

CREATE TABLE Payment (
    Payment_id SERIAL PRIMARY KEY,
    Order_id INTEGER REFERENCES "Order"(Order_id),
    Amount DECIMAL(10,2),
    Payment_dt TIMESTAMP
);
CREATE TABLE Product (
    Product_id SERIAL PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    Description TEXT,
    Seller_id INTEGER,
    StockLevel INTEGER
);
-- Insert sample data for Asia region
INSERT INTO Customer (Name, Email, Country, Phn_no) VALUES
    ('Saikat Banik', 'saikat@gmail.com', 'India', '+91-555-0101'),
    ('Hidetoshi Yuki', 'hidetoshi@gmail.com', 'Japan', '+81-555-0102'),
    ('Iqbal Hossen', 'iqbal@gmail.com', 'Bangladesh', '+88-555-0103'),
    ('Dominik Saimon', 'dominik@gmail.com', 'Germany', '+49-555-0101'),
    ('Marie Dubois', 'marie@gmail.com', 'France', '+33-555-0102'),
    ('Giuseppe Romano', 'giuseppe@gmail.com', 'Italy', '+39-555-0103'),
    ('John Smith', 'john@gmail.com', 'USA', '+1-555-0101'),
    ('Dakota Johnson', 'Dakota@gmail.com', 'USA', '+1-555-0102'),
    ('Michael Brown', 'michael@gmail.com', 'USA', '+1-555-0103');

----Fragmentation---
CREATE TABLE Customer_USA AS
SELECT * FROM Customer
WHERE Country = 'USA';

INSERT INTO Product (ProductName, Price, Description, Seller_id, StockLevel) VALUES
    ('Laptop', 949.99, 'High-performance laptop', 1, 60),
    ('Smartphone', 679.99, 'Latest Asian smartphone', 2, 120),
    ('Tablet', 319.99, 'Premium tablet', 3, 90),
    ('Laptop', 899.99, 'Premium laptop model', 1, 40),
    ('Smartphone', 649.99, 'Latest EU smartphone', 2, 80),
    ('Tablet', 349.99, 'Lightweight tablet', 3, 60),
    ('Laptop', 999.99, 'High-end laptop', 1, 50),
    ('Smartphone', 699.99, 'Latest smartphone model', 2, 100),
    ('Tablet', 399.99, 'Portable tablet device', 3, 75);


INSERT INTO "Order" (Cust_id, Order_dt, Status) VALUES
    (1, '2024-05-01 10:30:00', 'Pending'),
    (2, '2024-05-02 14:45:00', 'Shipped'),
    (3, '2024-05-03 08:15:00', 'Delivered');

INSERT INTO Payment (Order_id, Amount, Payment_dt) VALUES
    (1, 999.99, '2024-05-01 10:35:00'),
    (2, 699.99, '2024-05-02 14:50:00'),
    (3, 399.99, '2024-05-03 08:20:00');

====
CREATE DATABASE eu_region;
\c eu_region;

-- Repsaikatcated tables
CREATE TABLE Customer (
    Cust_id SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Country VARCHAR(50),
    Phn_no VARCHAR(20)
);


-- Region-specific tables
CREATE TABLE "Order" (
    Order_id SERIAL PRIMARY KEY,
    Cust_id INTEGER REFERENCES Customer(Cust_id),
    Order_dt TIMESTAMP,
    Status VARCHAR(50)
);

CREATE TABLE Payment (
    Payment_id SERIAL PRIMARY KEY,
    Order_id INTEGER REFERENCES "Order"(Order_id),
    Amount DECIMAL(10,2),
    Payment_dt TIMESTAMP
);
CREATE TABLE Product (
    Product_id SERIAL PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    Description TEXT,
    Seller_id INTEGER,
    StockLevel INTEGER
);
-- Insert sample data for EU region
INSERT INTO Customer (Name, Email, Country, Phn_no) VALUES
    ('Dominik Saimon', 'dominik@gmail.com', 'Germany', '+49-555-0101'),
    ('Marie Dubois', 'marie@gmail.com', 'France', '+33-555-0102'),
    ('Giuseppe Romano', 'giuseppe@gmail.com', 'Italy', '+39-555-0103');
---Fragmentation-----
CREATE TABLE customer_eu AS
SELECT * FROM Customer
WHERE Country IN ('Germany', 'France','Italy');

INSERT INTO Product (ProductName, Price, Description, Seller_id, StockLevel) VALUES
    ('Laptop', 899.99, 'Premium laptop model', 1, 40),
    ('Smartphone', 649.99, 'Latest EU smartphone', 2, 80),
    ('Tablet', 349.99, 'Lightweight tablet device', 3, 60);

INSERT INTO "Order" (Cust_id, Order_dt, Status) VALUES
    (1, '2024-05-01 11:45:00', 'Pending'),
    (2, '2024-05-02 15:30:00', 'Shipped'),
    (3, '2024-05-03 09:00:00', 'Delivered');

INSERT INTO Payment (Order_id, Amount, Payment_dt) VALUES
    (1, 899.99, '2024-05-01 11:50:00'),
    (2, 649.99, '2024-05-02 15:35:00'),
    (3, 349.99, '2024-05-03 09:05:00');
