CREATE DATABASE shopping_cart_db;
USE shopping_cart_db;

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


CREATE TABLE carts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE cart_items (
    cart_id INT,
    product_id INT,
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES carts(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);


CREATE INDEX idx_cart_id ON cart_items(cart_id);
CREATE INDEX idx_product_id ON cart_items(product_id);

INSERT INTO users (name, email) VALUES
('Muthu Pandiyan', 'muthu@example.com'),
('Keerthi', 'keerthi@example.com'),
('Rajesh Kumar', 'rajesh@example.com'),
('Anjali Sharma', 'anjali@example.com'),
('Farhan Khan', 'farhan@example.com'),
('Divya ', 'divya@example.com');

INSERT INTO products (name, description, price, stock, image_url) VALUES
('iPhone 14', 'Latest Apple iPhone with A15 Bionic chip', 999.99, 50, 'iphone14.jpg'),
('Nike Air Max', 'Comfortable running shoes with air cushioning', 150.00, 120, 'nike_air_max.jpg'),
('Samsung 55" LED TV', 'Smart 4K UHD LED TV with HDR', 650.00, 35, 'samsung_tv.jpg'),
('Dell XPS 13', 'Ultra-portable laptop with Intel i7 and 16GB RAM', 1200.00, 20, 'dell_xps.jpg'),
('Sony WH-1000XM5', 'Noise cancelling wireless headphones', 299.99, 60, 'sony_headphones.jpg'),
('Canon EOS M50', 'Mirrorless camera with 4K video support', 700.00, 15, 'canon_m50.jpg');

INSERT INTO carts (user_id) VALUES
(1),
(2),
(3),
(4),
(5),
(6);


INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
-- Muthu's Cart
(1, 1, 2),  -- iPhone 14
(1, 5, 1),  -- Sony Headphones

-- Keerthi's Cart
(2, 2, 1),  -- Nike Shoes
(2, 6, 1),  -- Canon Camera

-- Rajesh's Cart
(3, 3, 1),  -- Samsung TV
(3, 5, 2),  -- Sony Headphones

-- Anjali's Cart
(4, 4, 1),  -- Dell Laptop

-- Farhan's Cart
(5, 2, 2),  -- Nike Shoes
(5, 3, 1),  -- Samsung TV

-- Divya's Cart
(6, 6, 1),  -- Canon Camera
(6, 1, 1);  -- iPhone 14

-- 1. View Cart with Product Details
SELECT 
    p.id AS product_id,
    p.name,
    p.price,
    ci.quantity,
    (p.price * ci.quantity) AS subtotal
FROM cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.cart_id = 1;

-- 2. Total Cart Value
SELECT 
    SUM(p.price * ci.quantity) AS total_cart_value
FROM cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.cart_id = 1;

-- 3. Update Quantity
UPDATE cart_items
SET quantity = 3
WHERE cart_id = 1 AND product_id = 1;

-- 4. Remove Item
DELETE FROM cart_items
WHERE cart_id = 1 AND product_id = 3;

