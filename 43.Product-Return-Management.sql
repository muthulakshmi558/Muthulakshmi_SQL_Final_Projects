-- 1️ Create Database
CREATE DATABASE product_return_mgmt;
USE product_return_mgmt;

-- 2️ Create Tables
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL
);

CREATE TABLE returns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    reason VARCHAR(255),
    status ENUM('Pending', 'Approved', 'Rejected', 'Completed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 3️ Insert Sample Data (8 rows each)
INSERT INTO orders (user_id, product_id) VALUES
(1, 101), (2, 102), (3, 103), (4, 104),
(5, 105), (2, 106), (1, 107), (3, 108);

INSERT INTO returns (order_id, reason, status) VALUES
(1, 'Damaged on arrival', 'Pending'),
(2, 'Wrong item', 'Approved'),
(3, 'Changed mind', 'Rejected'),
(4, 'Product not working', 'Pending'),
(5, 'Better price elsewhere', 'Completed'),
(6, 'Size issue', 'Approved'),
(7, 'Color mismatch', 'Pending'),
(8, 'Missing parts', 'Approved');

-- 4️ SQL Queries

-- 📌 1. List all return requests with order details
SELECT r.id AS return_id, o.id AS order_id, o.user_id, o.product_id,
       r.reason, r.status
FROM returns r
JOIN orders o ON r.order_id = o.id;

-- 📌 2. Count of returns per status
SELECT status, COUNT(*) AS total_returns
FROM returns
GROUP BY status;

-- 📌 3. Find all orders with pending returns
SELECT o.id AS order_id, o.user_id, o.product_id, r.reason
FROM returns r
JOIN orders o ON r.order_id = o.id
WHERE r.status = 'Pending';

-- 📌 4. Total returns made by each user
SELECT o.user_id, COUNT(r.id) AS total_returns
FROM returns r
JOIN orders o ON r.order_id = o.id
GROUP BY o.user_id;

-- 📌 5. Approved returns with product details
SELECT o.product_id, r.reason
FROM returns r
JOIN orders o ON r.order_id = o.id
WHERE r.status = 'Approved';
