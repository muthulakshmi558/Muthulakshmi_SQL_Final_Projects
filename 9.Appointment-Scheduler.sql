CREATE DATABASE appointment_scheduler;
USE appointment_scheduler;

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Services Table
CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Appointments Table
CREATE TABLE appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    service_id INT,
    appointment_time DATETIME,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_service FOREIGN KEY (service_id) REFERENCES services(id),
    CONSTRAINT unique_appointment UNIQUE (user_id, appointment_time)
);

-- Users
INSERT INTO users (name) VALUES
('Muthu Pandiyan'), ('Aarthi'), ('Vijay'), ('Kavi'), ('Sundar'), ('Meena');

-- Services
INSERT INTO services (name) VALUES
('Haircut'), ('Dental Checkup'), ('Yoga Class'), ('Massage'), ('Grooming'), ('Eye Checkup');

-- Appointments
INSERT INTO appointments (user_id, service_id, appointment_time) VALUES
(1, 1, '2025-08-10 10:00:00'),
(2, 2, '2025-08-10 11:00:00'),
(3, 3, '2025-08-11 09:00:00'),
(4, 4, '2025-08-11 10:30:00'),
(5, 5, '2025-08-12 15:00:00'),
(6, 6, '2025-08-12 16:30:00'),
(1, 2, '2025-08-15 10:00:00');

-- Query: View All Appointments with User & Service
SELECT 
    a.id, 
    u.name AS user_name, 
    s.name AS service_name, 
    a.appointment_time
FROM appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
ORDER BY a.appointment_time;

-- Query: Filter Appointments by Date
SELECT 
    u.name, s.name, a.appointment_time
FROM appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE DATE(appointment_time) = '2025-08-10';

-- Query: Filter Appointments by Service
SELECT 
    u.name, s.name, a.appointment_time
FROM appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE s.name = 'Haircut';

-- Time Clash Logic – Detect Overlapping Slots for User
SELECT * FROM appointments
WHERE user_id = 1 AND appointment_time = '2025-08-10 10:00:00';
