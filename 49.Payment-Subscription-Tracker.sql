-- 1️ Create Database
CREATE DATABASE payment_subscription_tracker;
USE payment_subscription_tracker;

-- 2️ Create Tables
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE subscriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    plan_name VARCHAR(50),
    start_date DATE,
    renewal_cycle VARCHAR(20), -- 'Monthly', 'Quarterly', 'Yearly'
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 3️ Insert Sample Data (8 rows each table)
INSERT INTO users (name) VALUES
('Arun Kumar'),
('Priya Sharma'),
('Vignesh R'),
('Deepa Raj'),
('Karthik S'),
('Meena Devi'),
('Suresh Kumar'),
('Anitha R');

INSERT INTO subscriptions (user_id, plan_name, start_date, renewal_cycle) VALUES
(1, 'Basic', '2025-01-15', 'Monthly'),
(2, 'Premium', '2025-02-01', 'Yearly'),
(3, 'Standard', '2025-01-10', 'Monthly'),
(4, 'Premium', '2025-03-05', 'Quarterly'),
(5, 'Basic', '2025-02-20', 'Monthly'),
(6, 'Standard', '2025-01-25', 'Yearly'),
(7, 'Basic', '2025-02-28', 'Quarterly'),
(8, 'Premium', '2025-01-30', 'Monthly');

-- 4️⃣ Queries

-- 🔹 Show all subscriptions with user names
SELECT s.id, u.name AS user_name, s.plan_name, s.start_date, s.renewal_cycle
FROM subscriptions s
JOIN users u ON s.user_id = u.id;

-- 🔹 Calculate Auto-Renewal Date (based on cycle)
SELECT 
    s.id,
    u.name AS user_name,
    s.plan_name,
    s.start_date,
    s.renewal_cycle,
    CASE 
        WHEN s.renewal_cycle = 'Monthly' THEN DATE_ADD(s.start_date, INTERVAL 1 MONTH)
        WHEN s.renewal_cycle = 'Quarterly' THEN DATE_ADD(s.start_date, INTERVAL 3 MONTH)
        WHEN s.renewal_cycle = 'Yearly' THEN DATE_ADD(s.start_date, INTERVAL 1 YEAR)
    END AS next_renewal_date
FROM subscriptions s
JOIN users u ON s.user_id = u.id;

-- 🔹 Find Expired Subscriptions (renewal date before today)
SELECT 
    u.name,
    s.plan_name,
    s.start_date,
    s.renewal_cycle,
    CASE 
        WHEN s.renewal_cycle = 'Monthly' THEN DATE_ADD(s.start_date, INTERVAL 1 MONTH)
        WHEN s.renewal_cycle = 'Quarterly' THEN DATE_ADD(s.start_date, INTERVAL 3 MONTH)
        WHEN s.renewal_cycle = 'Yearly' THEN DATE_ADD(s.start_date, INTERVAL 1 YEAR)
    END AS next_renewal_date
FROM subscriptions s
JOIN users u ON s.user_id = u.id
HAVING next_renewal_date < CURDATE();

-- 🔹 Count of Subscriptions by Plan
SELECT plan_name, COUNT(*) AS total_subscriptions
FROM subscriptions
GROUP BY plan_name;

-- 🔹 Users with Monthly Subscriptions
SELECT u.name, s.plan_name
FROM subscriptions s
JOIN users u ON s.user_id = u.id
WHERE s.renewal_cycle = 'Monthly';
