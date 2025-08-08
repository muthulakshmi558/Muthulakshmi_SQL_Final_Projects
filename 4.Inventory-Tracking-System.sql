CREATE DATABASE inventory_system_db;

USE inventory_system_db;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    stock INT DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE inventory_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    supplier_id INT,
    action ENUM('IN', 'OUT') NOT NULL,
    qty INT NOT NULL CHECK (qty > 0),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

INSERT INTO products (name, stock) VALUES
('iPhone 14', 50),
('Nike Shoes', 80),
('Samsung TV', 35),
('Canon EOS M50', 15),
('Sony Headphones', 60),
('Amazon Echo', 40),
('Dell XPS 13', 20),
('ASUS ROG Phone', 25);


INSERT INTO suppliers (name) VALUES
('Apple Inc.'),
('Nike Corp.'),
('Samsung Electronics'),
('Sony Ltd.'),
('Amazon Devices'),
('Dell Technologies');

INSERT INTO inventory_logs (product_id, supplier_id, action, qty) VALUES
(1, 1, 'IN', 20),
(2, 2, 'IN', 30),
(3, 3, 'OUT', 5),
(4, 4, 'IN', 10),
(5, 4, 'OUT', 15),
(6, 5, 'IN', 25),
(7, 6, 'OUT', 5),
(8, 1, 'OUT', 10);


DELIMITER $$

CREATE TRIGGER update_stock_after_log
AFTER INSERT ON inventory_logs
FOR EACH ROW
BEGIN
    IF NEW.action = 'IN' THEN
        UPDATE products
        SET stock = stock + NEW.qty
        WHERE id = NEW.product_id;
    ELSEIF NEW.action = 'OUT' THEN
        UPDATE products
        SET stock = stock - NEW.qty
        WHERE id = NEW.product_id;
    END IF;
END$$

DELIMITER ;

-- Query to View Current Stock

SELECT id, name, stock
FROM products
ORDER BY stock ASC;


-- Reorder Alert Logic using CASE WHEN
SELECT 
    id, 
    name,
    stock,
    CASE 
        WHEN stock < 20 THEN 'LOW STOCK - REORDER'
        WHEN stock BETWEEN 20 AND 50 THEN 'MODERATE STOCK'
        ELSE 'STOCK OK'
    END AS stock_status
FROM products;

-- View Full Inventory Movement Log (Detailed)
SELECT 
    il.id,
    p.name AS product_name,
    s.name AS supplier_name,
    il.action,
    il.qty,
    il.timestamp
FROM inventory_logs il
JOIN products p ON il.product_id = p.id
JOIN suppliers s ON il.supplier_id = s.id
ORDER BY il.timestamp DESC;
