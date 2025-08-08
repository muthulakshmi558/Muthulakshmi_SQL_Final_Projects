-- 1. CREATE DATABASE FIRST
CREATE DATABASE product_review_system;
USE product_review_system;

-- 2. USERS TABLE
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

-- 3. PRODUCTS TABLE
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

-- 4. REVIEWS TABLE
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 5. INSERT USERS (7 sample users)
INSERT INTO users (name) VALUES
('Arun Kumar'),
('Deepa'),
('Ravi'),
('Kavya'),
('Manoj'),
('Aisha'),
('Vikram');

-- 6. INSERT PRODUCTS (6 sample products)
INSERT INTO products (name) VALUES
('iPhone 14'),
('Nike Air Max'),
('Sony Headphones'),
('Dell XPS 13'),
('Canon EOS M50'),
('Samsung 4K TV');

-- 7. INSERT REVIEWS (7 sample reviews)
INSERT INTO reviews (user_id, product_id, rating, review) VALUES
(1, 1, 5, 'Amazing phone! Totally worth the price.'),
(2, 1, 4, 'Good performance, camera could be better.'),
(3, 2, 5, 'Super comfortable and stylish.'),
(4, 3, 3, 'Sound is great but battery life is average.'),
(5, 4, 4, 'Sleek design, powerful performance.'),
(6, 5, 5, 'Perfect for beginner photographers.'),
(7, 6, 2, 'Not satisfied with picture quality.');

-- Average Rating Per Product
SELECT 
    p.name AS product_name,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.id) AS total_reviews
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id
ORDER BY avg_rating DESC;


--  Top 3 Rated Products
SELECT 
    p.name,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM products p
JOIN reviews r ON p.id = r.product_id
GROUP BY p.id
ORDER BY avg_rating DESC
LIMIT 3;

-- All Reviews for a Specific Product
SELECT 
    u.name AS reviewer,
    r.rating,
    r.review,
    r.created_at
FROM reviews r
JOIN users u ON r.user_id = u.id
WHERE r.product_id = 1; -- Replace with any product ID

-- All Reviews with Product Names
SELECT 
    u.name AS user,
    p.name AS product,
    r.rating,
    r.review,
    r.created_at
FROM reviews r
JOIN users u ON r.user_id = u.id
JOIN products p ON r.product_id = p.id
ORDER BY r.created_at DESC;
