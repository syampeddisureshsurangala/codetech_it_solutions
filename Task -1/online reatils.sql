CREATE DATABASE OnlineRetailStoreDB;

USE OnlineRetailStoreDB;
-- Create Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    address TEXT
);

-- Create Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Payments Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert Sample Data into Products Table
INSERT INTO products (product_id, product_name, description, price, stock_quantity) VALUES
(1, 'Wireless Mouse', 'Ergonomic wireless mouse with long battery life', 25.99, 150),
(2, 'Mechanical Keyboard', 'RGB mechanical keyboard with customizable keys', 89.99, 75),
(3, 'HD Monitor', '27 inch HD monitor with high refresh rate', 199.99, 50),
(4, 'USB-C Hub', 'Multi-port USB-C hub for laptops and tablets', 39.99, 200),
(5, 'Bluetooth Headphones', 'Noise-cancelling Bluetooth headphones', 79.99, 100);

-- Insert Sample Data into Customers Table
INSERT INTO customers (customer_id, first_name, last_name, email, phone_number, address) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '1234567890', '123 Elm St'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '0987654321', '456 Oak St'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '1122334455', '789 Pine St'),
(4, 'Bob', 'Williams', 'bob.williams@example.com', '2233445566', '321 Maple St'),
(5, 'Charlie', 'Brown', 'charlie.brown@example.com', '3344556677', '654 Cedar St');

-- Insert Sample Data into Orders Table with Example Dates
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-11-01', 115.98), -- John Doe's order on November 1st
(2, 2, '2024-11-02', 25.99), -- Jane Smith's order on November 2nd
(3, 3, '2024-11-03', 199.99), -- Alice Johnson's order on November 3rd
(4, 4, '2024-11-04', 39.99), -- Bob Williams' order on November 4th
(5, 5, '2024-11-05', 89.99); -- Charlie Brown's order on November 5th

-- Insert Sample Data into Payments Table with Example Dates
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_status) VALUES
(1, 1, '2024-11-01', 115.98, 'Completed'), -- Payment for John Doe's order on November 1st
(2, 2, '2024-11-02', 25.99, 'Completed'), -- Payment for Jane Smith's order on November 2nd
(3, 3, '2024-11-03', 199.99, 'Completed'), -- Payment for Alice Johnson's order on November 3rd
(4, 4, '2024-11-05', 39.99, 'Pending'), -- Payment for Bob Williams' order on November 5th (Pending)
(5, 5, '2024-11-05', 89.99, 'Completed'); -- Payment for Charlie Brown's order on November 5th

-- Example Queries to Retrieve Data

-- Retrieve all products
SELECT * FROM products;

-- Retrieve all customers
SELECT * FROM customers;

select * from payments;

select * from orders;

-- Retrieve all orders placed by a specific customer (e.g., John Doe)
SELECT o.order_id, o.order_date, o.total_amount 
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id 
WHERE c.customer_id = 1;

-- Check the payment status of a specific order (e.g., Order ID = 1)
SELECT p.payment_status 
FROM payments p 
JOIN orders o ON p.order_id = o.order_id 
WHERE o.order_id = 1;

-- Calculate total sales amount per customer
SELECT c.customer_id, CONCAT(c.first_name ,' ', c.last_name) AS customer_name , SUM(o.total_amount) AS total_sales 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id;

-- Update a Product's Stock Quantity
UPDATE products 
SET stock_quantity = stock_quantity - 1 
WHERE product_id = 1; -- Decrease stock for Wireless Mouse

-- Update Payment Status for an Order (e.g., Mark Bob Williams' payment as Completed)
UPDATE payments 
SET payment_status = 'Completed' 
WHERE order_id = 4; 

-- Delete a Customer Record (e.g., if a customer requests account deletion)
DELETE FROM customers 
WHERE customer_id = 5; -- Delete Charlie Brown

-- Retrieve All Pending Payments
SELECT p.payment_id, o.order_id, p.amount 
FROM payments p 
JOIN orders o ON p.order_id = o.order_id 
WHERE p.payment_status = 'Pending';

-- Retrieve Products with Low Stock (e.g., less than or equal to 20)
SELECT * FROM products 
WHERE stock_quantity <= 20;

-- Get Total Revenue from Completed Payments
SELECT SUM(amount) AS total_revenue 
FROM payments 
WHERE payment_status = 'Completed';

-- Get Order Details along with Customer Information
SELECT o.order_id, c.first_name ||' '+ c.last_name AS customer_name , o.order_date , o.total_amount 
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id;
