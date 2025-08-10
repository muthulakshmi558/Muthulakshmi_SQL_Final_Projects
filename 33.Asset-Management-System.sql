-- 1️ Create Database
CREATE DATABASE asset_management;
USE asset_management;

-- 2️ Create Tables
CREATE TABLE assets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE assignments (
    asset_id INT,
    user_id INT,
    assigned_date DATE NOT NULL,
    returned_date DATE,
    PRIMARY KEY (asset_id, user_id, assigned_date),
    FOREIGN KEY (asset_id) REFERENCES assets(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 3️⃣ Insert Sample Data (8+ entries each)
INSERT INTO assets (name, category) VALUES
('Laptop Dell XPS 13', 'Laptop'),
('HP EliteBook 840', 'Laptop'),
('Canon EOS 90D', 'Camera'),
('Epson L3150', 'Printer'),
('Samsung Galaxy Tab S7', 'Tablet'),
('MacBook Pro 16"', 'Laptop'),
('Logitech MX Master 3', 'Mouse'),
('Lenovo ThinkPad X1', 'Laptop');

INSERT INTO users (name) VALUES
('John Doe'),
('Jane Smith'),
('Michael Johnson'),
('Emily Davis'),
('David Wilson'),
('Sarah Brown'),
('Chris Evans'),
('Sophia Taylor');

INSERT INTO assignments (asset_id, user_id, assigned_date, returned_date) VALUES
(1, 1, '2025-07-01', NULL),   -- Currently with John
(2, 2, '2025-06-15', '2025-07-20'), -- Returned
(3, 3, '2025-07-10', NULL),   -- Currently with Michael
(4, 4, '2025-07-05', '2025-07-30'),
(5, 5, '2025-07-18', NULL),   -- Currently with David
(6, 6, '2025-07-22', NULL),   -- Currently with Sarah
(7, 7, '2025-07-25', '2025-07-28'),
(8, 8, '2025-07-29', NULL);   -- Currently with Sophia

-- 4️⃣ Queries

-- 🔍 1. Show all assets
SELECT * FROM assets;

-- 🔍 2. Show all users
SELECT * FROM users;

-- 🔍 3. Show all assignments
SELECT * FROM assignments;

-- 🔍 4. Check current assets in use (not returned yet)
SELECT a.id, a.name, u.name AS assigned_to, asg.assigned_date
FROM assignments AS asg
JOIN assets AS a ON asg.asset_id = a.id
JOIN users AS u ON asg.user_id = u.id
WHERE asg.returned_date IS NULL;

-- 🔍 5. Check available assets (not assigned currently)
SELECT id, name
FROM assets
WHERE id NOT IN (
    SELECT asset_id FROM assignments WHERE returned_date IS NULL
);

-- 🔍 6. Get assignment history for an asset
SELECT a.name AS asset, u.name AS user, asg.assigned_date, asg.returned_date
FROM assignments AS asg
JOIN assets AS a ON asg.asset_id = a.id
JOIN users AS u ON asg.user_id = u.id
WHERE a.id = 1;

-- 🔍 7. Get current user of a specific asset
SELECT u.name AS current_assigned_user
FROM assignments AS asg
JOIN users AS u ON asg.user_id = u.id
WHERE asg.asset_id = 1 
  AND asg.returned_date IS NULL;


-- 🔍 8. Total assets in each category
SELECT category, COUNT(*) AS total_assets
FROM assets
GROUP BY category;

-- 🔍 9. Number of currently assigned assets per user
SELECT u.name, COUNT(asg.asset_id) AS assigned_assets
FROM assignments AS asg
JOIN users AS u ON asg.user_id = u.id
WHERE asg.returned_date IS NULL
GROUP BY u.id;
