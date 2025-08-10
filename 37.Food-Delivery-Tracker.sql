-- 1️ Create Database
CREATE DATABASE food_delivery_tracker;
USE food_delivery_tracker;

-- 2️ Table Creation
CREATE TABLE restaurants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    user_id INT,
    placed_at DATETIME,
    delivered_at DATETIME,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

CREATE TABLE delivery_agents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE deliveries (
    order_id INT,
    agent_id INT,
    PRIMARY KEY (order_id, agent_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (agent_id) REFERENCES delivery_agents(id)
);

-- 3️ Insert Sample Data
INSERT INTO restaurants (name) VALUES
('Pizza Palace'), ('Burger Hub'), ('Sushi Corner');

INSERT INTO orders (restaurant_id, user_id, placed_at, delivered_at) VALUES
(1, 101, '2025-08-10 12:00:00', '2025-08-10 12:30:00'),
(1, 102, '2025-08-10 12:15:00', '2025-08-10 12:50:00'),
(2, 103, '2025-08-10 13:00:00', '2025-08-10 13:40:00'),
(3, 104, '2025-08-10 14:00:00', '2025-08-10 14:20:00'),
(2, 105, '2025-08-10 15:00:00', '2025-08-10 15:50:00'),
(3, 106, '2025-08-10 16:00:00', '2025-08-10 16:25:00');

INSERT INTO delivery_agents (name) VALUES
('Agent A'), ('Agent B'), ('Agent C');

INSERT INTO deliveries (order_id, agent_id) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 2),
(6, 3);

-- 4️⃣ Queries

-- 🔹 Delivery time (in minutes) for each order
SELECT 
    o.id AS order_id,
    r.name AS restaurant_name,
    TIMESTAMPDIFF(MINUTE, o.placed_at, o.delivered_at) AS delivery_time_minutes
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id;

-- 🔹 Average delivery time per restaurant
SELECT 
    r.name AS restaurant_name,
    AVG(TIMESTAMPDIFF(MINUTE, o.placed_at, o.delivered_at)) AS avg_delivery_time
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
GROUP BY r.name;

-- 🔹 Agent workload (number of deliveries handled)
SELECT 
    da.name AS agent_name,
    COUNT(d.order_id) AS total_deliveries
FROM deliveries d
JOIN delivery_agents da ON d.agent_id = da.id
GROUP BY da.name;

-- 🔹 Top fastest delivery (shortest time)
SELECT 
    o.id AS order_id,
    r.name AS restaurant_name,
    TIMESTAMPDIFF(MINUTE, o.placed_at, o.delivered_at) AS delivery_time_minutes
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
ORDER BY delivery_time_minutes ASC
LIMIT 1;

-- 🔹 Orders delivered in more than 40 minutes
SELECT 
    o.id AS order_id,
    r.name AS restaurant_name,
    TIMESTAMPDIFF(MINUTE, o.placed_at, o.delivered_at) AS delivery_time_minutes
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
WHERE TIMESTAMPDIFF(MINUTE, o.placed_at, o.delivered_at) > 40;
