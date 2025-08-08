CREATE DATABASE ecommerce_catalog;

USE ecommerce_catalog;

-- Categories Table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Brands Table
CREATE TABLE brands (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    image_url VARCHAR(255),
    category_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

CREATE INDEX idx_category ON products(category_id);
CREATE INDEX idx_brand ON products(brand_id);
CREATE INDEX idx_price ON products(price);

-- Categories
INSERT INTO categories (name) VALUES ('Electronics'), ('Apparel'), ('Home');

-- Brands
INSERT INTO brands (name) VALUES ('Apple'), ('Nike'), ('Samsung');

-- Products
INSERT INTO products (name, description, price, stock, image_url, category_id, brand_id) VALUES
('iPhone 14', 'Latest iPhone model', 999.99, 50, 'iphone.jpg', 1, 1),
('Nike Shoes', 'Running shoes', 120.00, 100, 'nike.jpg', 2, 2),
('Samsung TV', '55 inch Smart TV', 599.99, 30, 'tv.jpg', 1, 3);

-- Categories
INSERT INTO categories (name) VALUES ('Electronics'), ('Apparel'), ('Home');

-- Brands
INSERT INTO brands (name) VALUES ('Apple'), ('Nike'), ('Samsung');

-- Products
INSERT INTO products (name, description, price, stock, image_url, category_id, brand_id) VALUES
('iPhone 14', 'Latest iPhone model', 999.99, 50, 'iphone.jpg', 1, 1),
('Nike Shoes', 'Running shoes', 120.00, 100, 'nike.jpg', 2, 2),
('Samsung TV', '55 inch Smart TV', 599.99, 30, 'tv.jpg', 1, 3);

--  Get products by Category Name
SELECT p.* 
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Electronics';

-- Get products by Brand Name
SELECT p.*
FROM products p
JOIN brands b ON p.brand_id = b.id
WHERE b.name = 'Nike';

-- Get products within a price range
SELECT * FROM products
WHERE price BETWEEN 100 AND 600;

-- Combine Filters: Brand + Category + Price
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
WHERE c.name = 'Electronics'
  AND b.name = 'Samsung'
  AND p.price < 700;
