-- 1. Database Creation
CREATE DATABASE qr_code_entry_log_system;
USE qr_code_entry_log_system;

-- 2. Table Creation
CREATE TABLE locations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE entry_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    location_id INT,
    entry_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

-- 3. Sample Data Insertion
INSERT INTO locations (name) VALUES
('Main Office'),
('Warehouse'),
('Conference Hall'),
('IT Department'),
('Reception'),
('Parking Area');

INSERT INTO users (name) VALUES
('John Smith'),
('Emma Johnson'),
('Michael Brown'),
('Sophia Davis'),
('Daniel Wilson'),
('Olivia Martinez');

INSERT INTO entry_logs (user_id, location_id, entry_time) VALUES
(1, 1, '2025-08-10 09:15:00'),
(2, 2, '2025-08-10 09:45:00'),
(3, 1, '2025-08-10 10:00:00'),
(4, 3, '2025-08-10 10:30:00'),
(5, 4, '2025-08-10 11:00:00'),
(6, 5, '2025-08-10 11:15:00'),
(1, 6, '2025-08-10 12:00:00'),
(2, 1, '2025-08-11 08:45:00'),
(3, 2, '2025-08-11 09:10:00'),
(4, 3, '2025-08-11 09:30:00');

-- 4. SQL Queries

-- a) Count total entries per location
SELECT l.name AS location_name, COUNT(e.id) AS total_entries
FROM locations l
LEFT JOIN entry_logs e ON l.id = e.location_id
GROUP BY l.id, l.name;

-- b) List all entries for a specific date
SELECT u.name AS user_name, l.name AS location_name, e.entry_time
FROM entry_logs e
JOIN users u ON e.user_id = u.id
JOIN locations l ON e.location_id = l.id
WHERE DATE(e.entry_time) = '2025-08-10'
ORDER BY e.entry_time;

-- c) List all entries for a specific location
SELECT u.name AS user_name, l.name AS location_name, e.entry_time
FROM entry_logs e
JOIN users u ON e.user_id = u.id
JOIN locations l ON e.location_id = l.id
WHERE l.name = 'Main Office'
ORDER BY e.entry_time;

-- d) Get the latest entry per user
SELECT u.name AS user_name, MAX(e.entry_time) AS latest_entry
FROM entry_logs e
JOIN users u ON e.user_id = u.id
GROUP BY u.id, u.name;

-- e) Count entries per user
SELECT u.name AS user_name, COUNT(e.id) AS total_entries
FROM users u
LEFT JOIN entry_logs e ON u.id = e.user_id
GROUP BY u.id, u.name
ORDER BY total_entries DESC;
