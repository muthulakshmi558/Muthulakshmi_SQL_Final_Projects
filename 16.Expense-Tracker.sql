-- 1. Create Database
CREATE DATABASE ExpenseTrackerDB;
USE ExpenseTrackerDB;

-- 2. Create Tables

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Categories Table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Expenses Table
CREATE TABLE expenses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    date DATE NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- 3. Insert Sample Data

-- Users
INSERT INTO users (name) VALUES
('Arun Kumar'),
('Priya Sharma'),
('Karthik Raja'),
('Divya Ramesh'),
('Ravi Kumar'),
('Sneha Iyer'),
('Vijay Anand'),
('Meena Rani');

-- Categories
INSERT INTO categories (name) VALUES
('Food'),
('Transport'),
('Shopping'),
('Entertainment'),
('Utilities'),
('Healthcare'),
('Education'),
('Travel');

-- Expenses
INSERT INTO expenses (user_id, category_id, amount, date) VALUES
(1, 1, 250.50, '2025-08-01'),
(1, 2, 80.00, '2025-08-02'),
(2, 3, 1200.00, '2025-08-03'),
(3, 4, 500.00, '2025-08-04'),
(4, 5, 1500.00, '2025-08-05'),
(5, 6, 750.00, '2025-08-06'),
(6, 7, 2000.00, '2025-08-07'),
(7, 8, 5000.00, '2025-08-08');

-- 4. Useful Queries

-- a) Total expenses by each category
SELECT c.name AS Category, SUM(e.amount) AS TotalAmount
FROM expenses e
JOIN categories c ON e.category_id = c.id
GROUP BY c.name
ORDER BY TotalAmount DESC;

-- b) Monthly expense total for each user
SELECT u.name AS UserName, MONTH(e.date) AS Month, YEAR(e.date) AS Year, SUM(e.amount) AS TotalAmount
FROM expenses e
JOIN users u ON e.user_id = u.id
GROUP BY u.name, YEAR(e.date), MONTH(e.date)
ORDER BY u.name, Year, Month;

-- c) Filter expenses by amount range (Example: 500 to 2000)
SELECT u.name AS UserName, c.name AS Category, e.amount, e.date
FROM expenses e
JOIN users u ON e.user_id = u.id
JOIN categories c ON e.category_id = c.id
WHERE e.amount BETWEEN 500 AND 2000
ORDER BY e.amount DESC;

-- d) Highest single expense for each user
SELECT u.name AS UserName, MAX(e.amount) AS MaxExpense
FROM expenses e
JOIN users u ON e.user_id = u.id
GROUP BY u.name;

-- e) Top 3 categories with highest total expenses
SELECT c.name AS Category, SUM(e.amount) AS TotalAmount
FROM expenses e
JOIN categories c ON e.category_id = c.id
GROUP BY c.name
ORDER BY TotalAmount DESC
LIMIT 3;

-- f) Expenses made in the current month
SELECT u.name AS UserName, c.name AS Category, e.amount, e.date
FROM expenses e
JOIN users u ON e.user_id = u.id
JOIN categories c ON e.category_id = c.id
WHERE MONTH(e.date) = MONTH(CURDATE()) AND YEAR(e.date) = YEAR(CURDATE())
ORDER BY e.date;
