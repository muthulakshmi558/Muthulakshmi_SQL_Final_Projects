-- 1️ Create Database
CREATE DATABASE restaurant_reservation_db;
USE restaurant_reservation_db;

-- 2️ Tables Creation
CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_number INT NOT NULL UNIQUE,
    capacity INT NOT NULL
);

CREATE TABLE guests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    table_id INT,
    date DATE NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES guests(id),
    FOREIGN KEY (table_id) REFERENCES tables(id)
);

-- 3️ Insert Sample Data
INSERT INTO tables (table_number, capacity) VALUES
(1, 2),
(2, 4),
(3, 6),
(4, 2),
(5, 8),
(6, 4),
(7, 2),
(8, 6);

INSERT INTO guests (name) VALUES
('John Doe'),
('Alice Smith'),
('Bob Johnson'),
('David Brown'),
('Emily Davis'),
('Sophia Wilson'),
('Liam Miller'),
('Olivia Martinez');

INSERT INTO reservations (guest_id, table_id, date, time_slot) VALUES
(1, 1, '2025-08-11', '18:00-19:00'),
(2, 2, '2025-08-11', '18:30-19:30'),
(3, 1, '2025-08-11', '19:00-20:00'),
(4, 3, '2025-08-11', '20:00-21:00'),
(5, 4, '2025-08-12', '18:00-19:00'),
(6, 2, '2025-08-12', '19:00-20:00'),
(7, 5, '2025-08-12', '20:00-21:00'),
(8, 6, '2025-08-13', '18:00-19:00');

-- 4️ Query: Detect Overlapping Reservations for Same Table
SELECT 
    r1.id AS reservation_id_1,
    r2.id AS reservation_id_2,
    t.table_number,
    r1.date,
    r1.time_slot AS slot_1,
    r2.time_slot AS slot_2
FROM reservations r1
JOIN reservations r2 
    ON r1.table_id = r2.table_id 
    AND r1.id < r2.id
    AND r1.date = r2.date
    AND (
        SUBSTRING_INDEX(r1.time_slot, '-', -1) > SUBSTRING_INDEX(r2.time_slot, '-', 1)
        AND SUBSTRING_INDEX(r1.time_slot, '-', 1) < SUBSTRING_INDEX(r2.time_slot, '-', -1)
    )
JOIN tables t ON r1.table_id = t.id;

-- 5️ Query: Daily Summary (Total Reservations Per Day)
SELECT 
    date,
    COUNT(*) AS total_reservations,
    COUNT(DISTINCT table_id) AS tables_booked
FROM reservations
GROUP BY date
ORDER BY date;

-- 6️ Query: Guest Reservation History
SELECT 
    g.name AS guest_name,
    t.table_number,
    r.date,
    r.time_slot
FROM reservations r
JOIN guests g ON r.guest_id = g.id
JOIN tables t ON r.table_id = t.id
ORDER BY g.name, r.date;

-- 7️ Query: Table Utilization Count
SELECT 
    t.table_number,
    COUNT(r.id) AS times_reserved
FROM tables t
LEFT JOIN reservations r ON t.id = r.table_id
GROUP BY t.table_number
ORDER BY times_reserved DESC;
