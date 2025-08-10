-- 1️ Create Database
CREATE DATABASE inventory_expiry_tracker;
USE inventory_expiry_tracker;

-- 2️ Create Tables
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE batches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    expiry_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 3️ Insert Sample Data (6–8 each)
INSERT INTO products (name) VALUES
('Milk 500ml'),
('Bread Loaf'),
('Cheese Block'),
('Yogurt Cup'),
('Eggs Pack'),
('Orange Juice 1L'),
('Butter 200g'),
('Chicken Breast');

INSERT INTO batches (product_id, quantity, expiry_date) VALUES
(1, 50, '2025-08-05'),  -- Expired
(1, 30, '2025-08-20'),
(2, 40, '2025-08-08'),  -- Expired
(3, 25, '2025-09-01'),
(4, 60, '2025-08-10'),  -- Expired
(5, 100, '2025-09-15'),
(6, 45, '2025-08-25'),
(7, 20, '2025-08-18');

-- 4️ SQL Queries

-- 📌 a) View all products with their batches
SELECT p.name AS product_name, b.quantity, b.expiry_date
FROM products p
JOIN batches b ON p.id = b.product_id
ORDER BY p.name;

-- 📌 b) Check expired stock (expiry date < today)
SELECT p.name AS product_name, b.quantity, b.expiry_date
FROM products p
JOIN batches b ON p.id = b.product_id
WHERE b.expiry_date < CURDATE()
ORDER BY b.expiry_date;

-- 📌 c) Check stock expiring in next 7 days
SELECT p.name AS product_name, b.quantity, b.expiry_date
FROM products p
JOIN batches b ON p.id = b.product_id
WHERE b.expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY b.expiry_date;

-- 📌 d) Total remaining stock per product
SELECT p.name AS product_name, SUM(b.quantity) AS total_quantity
FROM products p
JOIN batches b ON p.id = b.product_id
GROUP BY p.name
ORDER BY total_quantity DESC;

-- 📌 e) Remove expired batches (delete query)
DELETE FROM batches
WHERE expiry_date < CURDATE();

-- 📌 f) Update stock quantity for a batch
UPDATE batches
SET quantity = quantity - 5
WHERE id = 2; -- Example: Reduce quantity by 5 for batch id 2
