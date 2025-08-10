-- 1️ Create Database
CREATE DATABASE notification_system;
USE notification_system;

-- 2️ Create Tables
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message TEXT NOT NULL,
    status ENUM('unread', 'read') DEFAULT 'unread',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 3️ Insert Sample Data (6–8 per table)
INSERT INTO users (name) VALUES
('Arun Kumar'),
('Priya Sharma'),
('Karthik Raja'),
('Meena Devi'),
('Vikram Singh'),
('Deepa Rani'),
('Suresh Kumar'),
('Anjali Menon');

INSERT INTO notifications (user_id, message, status, created_at) VALUES
(1, 'Your order #123 has been shipped.', 'unread', '2025-08-10 10:15:00'),
(1, 'Payment for invoice #456 received.', 'read', '2025-08-09 14:30:00'),
(2, 'New message from support.', 'unread', '2025-08-11 09:20:00'),
(3, 'Password changed successfully.', 'unread', '2025-08-10 08:10:00'),
(4, 'Your subscription is expiring soon.', 'read', '2025-08-08 11:45:00'),
(5, 'Welcome to our platform!', 'unread', '2025-08-07 12:00:00'),
(6, 'Discount coupon: SAVE20', 'read', '2025-08-06 09:50:00'),
(7, 'Security alert: New login detected.', 'unread', '2025-08-11 07:40:00');

-- 4️⃣ Queries

-- 📌 Get all unread notifications for a specific user
SELECT * 
FROM notifications
WHERE user_id = 1 AND status = 'unread'
ORDER BY created_at DESC;

-- 📌 Count of unread notifications for each user
SELECT u.id, u.name, COUNT(n.id) AS unread_count
FROM users u
LEFT JOIN notifications n ON u.id = n.user_id AND n.status = 'unread'
GROUP BY u.id, u.name;

-- 📌 Mark all notifications as read for a user
UPDATE notifications
SET status = 'read'
WHERE user_id = 1 AND status = 'unread';

-- 📌 Recent notifications (latest 5 for a user)
SELECT * 
FROM notifications
WHERE user_id = 1
ORDER BY created_at DESC
LIMIT 5;

-- 📌 Get notifications with user name
SELECT n.id, u.name AS user_name, n.message, n.status, n.created_at
FROM notifications n
JOIN users u ON n.user_id = u.id
ORDER BY n.created_at DESC;
