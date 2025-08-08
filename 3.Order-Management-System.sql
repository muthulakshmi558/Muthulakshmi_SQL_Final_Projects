CREATE DATABASE order_management_db;
USE order_management_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    image_url VARCHAR(255)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    status ENUM('pending', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO users (name, email) VALUES
('Muthu lakshmi', 'muthu@example.com'),
('Keerthi Anand', 'keerthi@example.com'),
('Rahul Sharma', 'rahul@example.com'),
('Divya Mehra', 'divya@example.com'),
('Arun Prasad', 'arun@example.com'),
('Sneha Raj', 'sneha@example.com'),
('Kiran Kumar', 'kiran@example.com'),
('Neha Patel', 'neha@example.com');

INSERT INTO products (name, description, price, stock, image_url) VALUES
('iPhone 14', 'Latest Apple iPhone', 999.99, 50, 'iphone.jpg'),
('Nike Air Max', 'Running shoes with air cushion', 150.00, 80, 'nike.jpg'),
('Samsung 55" TV', '4K Smart LED TV', 650.00, 35, 'tv.jpg'),
('Dell XPS 13', 'Slim Intel i7 Laptop', 1200.00, 20, 'xps.jpg'),
('Sony WH-1000XM5', 'Noise cancelling headphones', 299.99, 60, 'sony.jpg'),
('Canon EOS M50', '4K Mirrorless Camera', 700.00, 15, 'canon.jpg'),
('Amazon Echo', 'Smart voice assistant', 129.99, 40, 'echo.jpg'),
('ASUS ROG Phone', 'Gaming smartphone', 899.00, 25, 'rog.jpg');


INSERT INTO orders (user_id, status) VALUES
(1, 'pending'),
(2, 'shipped'),
(3, 'delivered'),
(4, 'pending'),
(5, 'cancelled'),
(6, 'delivered');


INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 999.99),  -- 2 iPhones
(1, 5, 1, 299.99),  -- 1 Sony Headphones
(2, 2, 1, 150.00),  -- Nike Shoes
(2, 6, 1, 700.00),  -- Canon Camera
(3, 3, 1, 650.00),  -- Samsung TV
(4, 4, 1, 1200.00), -- Dell Laptop
(5, 7, 2, 129.99),  -- Amazon Echo
(6, 8, 1, 899.00);  -- ASUS ROG

-- Get Full Order History for a User

SELECT 
    o.id AS order_id,
    o.status,
    o.created_at,
    p.name AS product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS subtotal
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.user_id = 1
ORDER BY o.created_at DESC;


-- Total Order Value (Per Order)
SELECT 
    o.id AS order_id,
    o.status,
    SUM(oi.quantity * oi.price) AS total_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.user_id = 1
GROUP BY o.id, o.status;

-- Update Order Status 

UPDATE orders
SET status = 'shipped'
WHERE id = 1;

-- Cancel Order
UPDATE orders
SET status = 'cancelled'
WHERE id = 4;

-- Place a New Order (with Transaction)
START TRANSACTION;

-- Create order
INSERT INTO orders (user_id, status) VALUES (7, 'pending');

-- Insert order items (assume LAST_INSERT_ID() = 7)
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(LAST_INSERT_ID(), 1, 1, 999.99),
(LAST_INSERT_ID(), 4, 1, 1200.00);

COMMIT;

