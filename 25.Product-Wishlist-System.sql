-- 1️ Database Creation
CREATE DATABASE product_wishlist_db;
USE product_wishlist_db;

-- 2️ Table Creation
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE wishlist (
    user_id INT,
    product_id INT,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 3️ Insert Sample Data (6–8 rows each)
INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eva'),
('Frank'),
('Grace'),
('Hannah');

INSERT INTO products (name) VALUES
('Laptop'),
('Smartphone'),
('Headphones'),
('Smartwatch'),
('Camera'),
('Gaming Console'),
('Tablet'),
('Bluetooth Speaker');

INSERT INTO wishlist (user_id, product_id) VALUES
(1, 1), -- Alice likes Laptop
(1, 3), -- Alice likes Headphones
(2, 2), -- Bob likes Smartphone
(2, 1), -- Bob likes Laptop
(3, 4), -- Charlie likes Smartwatch
(4, 1), -- David likes Laptop
(4, 2), -- David likes Smartphone
(5, 5), -- Eva likes Camera
(6, 6), -- Frank likes Gaming Console
(7, 1), -- Grace likes Laptop
(8, 8), -- Hannah likes Bluetooth Speaker
(8, 3); -- Hannah likes Headphones

-- 4️⃣ SQL Queries

-- a) View all wishlist items with user and product names
SELECT u.name AS user_name, p.name AS product_name
FROM wishlist w
JOIN users u ON w.user_id = u.id
JOIN products p ON w.product_id = p.id
ORDER BY u.name;

-- b) Find popular wishlist items (most wished products)
SELECT p.name AS product_name, COUNT(*) AS wish_count
FROM wishlist w
JOIN products p ON w.product_id = p.id
GROUP BY p.id
ORDER BY wish_count DESC;

-- c) Get all products wished by a specific user (example: Alice)
SELECT p.name
FROM wishlist w
JOIN products p ON w.product_id = p.id
JOIN users u ON w.user_id = u.id
WHERE u.name = 'Alice';

-- d) Get all users who wished for a specific product (example: Laptop)
SELECT u.name
FROM wishlist w
JOIN users u ON w.user_id = u.id
JOIN products p ON w.product_id = p.id
WHERE p.name = 'Laptop';

-- e) Count how many products each user has in wishlist
SELECT u.name, COUNT(w.product_id) AS total_wishlist_items
FROM users u
LEFT JOIN wishlist w ON u.id = w.user_id
GROUP BY u.id
ORDER BY total_wishlist_items DESC;

-- f) Find users who have no items in wishlist
SELECT u.name
FROM users u
LEFT JOIN wishlist w ON u.id = w.user_id
WHERE w.product_id IS NULL;
