-- 1️ Create Database
CREATE DATABASE hotel_booking_system;
USE hotel_booking_system;

-- 2️ Create Tables
CREATE TABLE rooms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    number VARCHAR(10) NOT NULL,
    type VARCHAR(50) NOT NULL
);

CREATE TABLE guests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT NOT NULL,
    guest_id INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (room_id) REFERENCES rooms(id),
    FOREIGN KEY (guest_id) REFERENCES guests(id)
);

-- 3️ Insert Sample Data (Rooms)
INSERT INTO rooms (number, type) VALUES
('101', 'Single'),
('102', 'Single'),
('201', 'Double'),
('202', 'Double'),
('301', 'Suite'),
('302', 'Suite'),
('401', 'Deluxe'),
('402', 'Deluxe');

-- 4️ Insert Sample Data (Guests)
INSERT INTO guests (name) VALUES
('Arjun Kumar'),
('Priya Sharma'),
('Vikram Singh'),
('Meena Rani'),
('Ravi Teja'),
('Divya Iyer'),
('Karthik Raj'),
('Sneha Kapoor');

-- 5️ Insert Sample Data (Bookings)
INSERT INTO bookings (room_id, guest_id, from_date, to_date) VALUES
(1, 1, '2025-08-01', '2025-08-05'),
(2, 2, '2025-08-03', '2025-08-06'),
(3, 3, '2025-08-05', '2025-08-08'),
(4, 4, '2025-08-02', '2025-08-04'),
(5, 5, '2025-08-07', '2025-08-09'),
(6, 6, '2025-08-01', '2025-08-03'),
(7, 7, '2025-08-04', '2025-08-07'),
(8, 8, '2025-08-06', '2025-08-10');

-- 6️ SQL Queries

-- 🔹 a) Find overlapping bookings for a given date range (Example: Aug 4 to Aug 6)
SELECT b.id AS booking_id, r.number AS room_number, g.name AS guest_name, b.from_date, b.to_date
FROM bookings b
JOIN rooms r ON b.room_id = r.id
JOIN guests g ON b.guest_id = g.id
WHERE NOT (b.to_date < '2025-08-04' OR b.from_date > '2025-08-06');

-- 🔹 b) Find available rooms for a given date range (Example: Aug 4 to Aug 6)
SELECT r.id, r.number, r.type
FROM rooms r
WHERE r.id NOT IN (
    SELECT room_id FROM bookings
    WHERE NOT (to_date < '2025-08-04' OR from_date > '2025-08-06')
);

-- 🔹 c) Count bookings per room
SELECT r.number, COUNT(b.id) AS total_bookings
FROM rooms r
LEFT JOIN bookings b ON r.id = b.room_id
GROUP BY r.number
ORDER BY total_bookings DESC;

-- 🔹 d) Show upcoming bookings for each guest
SELECT g.name, r.number AS room_number, b.from_date, b.to_date
FROM guests g
JOIN bookings b ON g.id = b.guest_id
JOIN rooms r ON r.id = b.room_id
WHERE b.from_date >= CURDATE()
ORDER BY b.from_date;

-- 🔹 e) List all rooms never booked
SELECT r.id, r.number, r.type
FROM rooms r
LEFT JOIN bookings b ON r.id = b.room_id
WHERE b.id IS NULL;
