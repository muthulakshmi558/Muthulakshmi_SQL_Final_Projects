-- 1️ Create Database
CREATE DATABASE fitness_tracker;
USE fitness_tracker;

-- 2️ Create Tables
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE workouts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL
);

CREATE TABLE workout_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    workout_id INT,
    duration INT, -- in minutes
    log_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (workout_id) REFERENCES workouts(id)
);

-- 3️ Insert Sample Data
INSERT INTO users (name) VALUES
('Arjun Kumar'), ('Priya Sharma'), ('Ravi Singh'), ('Meera Nair'),
('Anil Mehta'), ('Sneha Gupta'), ('Vikram Rao'), ('Kavya Iyer');

INSERT INTO workouts (name, type) VALUES
('Running', 'Cardio'),
('Cycling', 'Cardio'),
('Yoga', 'Flexibility'),
('Weight Lifting', 'Strength'),
('Swimming', 'Cardio'),
('HIIT', 'Cardio'),
('Pilates', 'Flexibility'),
('Push-Ups', 'Strength');

INSERT INTO workout_logs (user_id, workout_id, duration, log_date) VALUES
(1, 1, 30, '2025-08-04'),
(1, 4, 45, '2025-08-05'),
(2, 2, 40, '2025-08-04'),
(2, 3, 60, '2025-08-06'),
(3, 1, 25, '2025-08-04'),
(3, 6, 35, '2025-08-07'),
(4, 5, 50, '2025-08-04'),
(4, 3, 55, '2025-08-05'),
(5, 7, 40, '2025-08-04'),
(5, 8, 30, '2025-08-06'),
(6, 1, 20, '2025-08-04'),
(6, 4, 50, '2025-08-07'),
(7, 2, 45, '2025-08-05'),
(7, 5, 35, '2025-08-06'),
(8, 6, 30, '2025-08-04'),
(8, 7, 60, '2025-08-08');

-- 4️⃣ Queries

-- A. Weekly summary per user (total minutes this week)
SELECT 
    u.name AS user_name,
    SUM(wl.duration) AS total_minutes
FROM users u
JOIN workout_logs wl ON u.id = wl.user_id
WHERE YEARWEEK(wl.log_date, 1) = YEARWEEK(CURDATE(), 1)
GROUP BY u.id;

-- B. Show each user's workouts with type
SELECT 
    u.name AS user_name,
    w.name AS workout_name,
    w.type AS workout_type,
    wl.duration,
    wl.log_date
FROM workout_logs wl
JOIN users u ON wl.user_id = u.id
JOIN workouts w ON wl.workout_id = w.id
ORDER BY u.name, wl.log_date;

-- C. Total time spent per workout type
SELECT 
    w.type,
    SUM(wl.duration) AS total_minutes
FROM workout_logs wl
JOIN workouts w ON wl.workout_id = w.id
GROUP BY w.type;

-- D. Most active user (this week)
SELECT 
    u.name,
    SUM(wl.duration) AS total_minutes
FROM users u
JOIN workout_logs wl ON u.id = wl.user_id
WHERE YEARWEEK(wl.log_date, 1) = YEARWEEK(CURDATE(), 1)
GROUP BY u.id
ORDER BY total_minutes DESC
LIMIT 1;

-- E. Workouts done by a specific user (Example: Priya Sharma)
SELECT 
    w.name AS workout_name,
    wl.duration,
    wl.log_date
FROM workout_logs wl
JOIN workouts w ON wl.workout_id = w.id
JOIN users u ON wl.user_id = u.id
WHERE u.name = 'Priya Sharma';
