-- 1️ Create Database
CREATE DATABASE invoice_generator;
USE invoice_generator;

-- 2️ Create Tables
CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE invoices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    date DATE,
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE invoice_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    description VARCHAR(255),
    quantity INT,
    rate DECIMAL(10,2),
    FOREIGN KEY (invoice_id) REFERENCES invoices(id)
);

-- 3️ Insert Sample Data

-- Clients
INSERT INTO clients (name) VALUES
('Arun Kumar'),
('Priya Enterprises'),
('Sundar Traders'),
('Meena Textiles'),
('Ramesh Electronics'),
('Vijay Constructions'),
('Lakshmi Stores'),
('Anand IT Solutions');

-- Invoices
INSERT INTO invoices (client_id, date) VALUES
(1, '2025-08-01'),
(2, '2025-08-03'),
(3, '2025-08-05'),
(4, '2025-08-06'),
(5, '2025-08-07'),
(6, '2025-08-08'),
(7, '2025-08-09'),
(8, '2025-08-10');

-- Invoice Items
INSERT INTO invoice_items (invoice_id, description, quantity, rate) VALUES
(1, 'Laptop', 2, 55000.00),
(1, 'Mouse', 4, 500.00),
(2, 'Textile Fabric Roll', 10, 750.00),
(2, 'Silk Saree', 3, 2500.00),
(3, 'Cement Bag', 50, 320.00),
(3, 'Steel Rod', 20, 450.00),
(4, 'Refrigerator', 1, 28000.00),
(4, 'Washing Machine', 1, 18000.00),
(5, 'Mobile Phone', 5, 15000.00),
(5, 'Earphones', 10, 800.00),
(6, 'Office Chair', 6, 4500.00),
(6, 'Table', 3, 7500.00),
(7, 'Rice Bag (25kg)', 8, 1200.00),
(7, 'Oil Can (5L)', 6, 750.00),
(8, 'Software Development Service', 1, 120000.00),
(8, 'Website Hosting (1 year)', 1, 5000.00);

-- 4️ Queries

-- a) View all invoices with client names
SELECT i.id AS invoice_id, c.name AS client_name, i.date
FROM invoices i
JOIN clients c ON i.client_id = c.id;

-- b) Get all items for a specific invoice (e.g., invoice_id = 1)
SELECT ii.description, ii.quantity, ii.rate, (ii.quantity * ii.rate) AS subtotal
FROM invoice_items ii
WHERE ii.invoice_id = 1;

-- c) Calculate subtotal for each invoice
SELECT invoice_id, SUM(quantity * rate) AS subtotal
FROM invoice_items
GROUP BY invoice_id;

-- d) Get invoice with total amount and client name
SELECT i.id AS invoice_id, c.name AS client_name, i.date,
       SUM(ii.quantity * ii.rate) AS total_amount
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
GROUP BY i.id, c.name, i.date;

-- e) Find highest value invoice
SELECT i.id AS invoice_id, c.name AS client_name, SUM(ii.quantity * ii.rate) AS total_amount
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
GROUP BY i.id, c.name
ORDER BY total_amount DESC
LIMIT 1;

-- f) List all invoices in August 2025 with totals
SELECT i.id AS invoice_id, c.name AS client_name, SUM(ii.quantity * ii.rate) AS total_amount
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
WHERE MONTH(i.date) = 8 AND YEAR(i.date) = 2025
GROUP BY i.id, c.name;
