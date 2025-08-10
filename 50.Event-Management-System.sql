-- 1. Create Database
CREATE DATABASE event_management;
USE event_management;

-- 2. Create Tables
CREATE TABLE events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    max_capacity INT NOT NULL
);

CREATE TABLE attendees (
    event_id INT,
    user_id INT,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES events(id)
);

-- 3. Insert Sample Data
INSERT INTO events (title, max_capacity) VALUES
('Tech Conference 2025', 100),
('Music Fest', 50),
('Startup Pitch', 30),
('Photography Workshop', 20),
('Art Exhibition', 40),
('Yoga Retreat', 25),
('Coding Bootcamp', 60),
('Food Carnival', 80);

INSERT INTO attendees (event_id, user_id, registered_at) VALUES
(1, 101, '2025-08-01 10:00:00'),
(1, 102, '2025-08-01 10:05:00'),
(1, 103, '2025-08-01 10:10:00'),
(2, 104, '2025-08-02 09:00:00'),
(2, 105, '2025-08-02 09:15:00'),
(3, 106, '2025-08-03 11:30:00'),
(3, 107, '2025-08-03 11:45:00'),
(4, 108, '2025-08-04 14:00:00'),
(5, 109, '2025-08-05 15:00:00'),
(5, 110, '2025-08-05 15:10:00'),
(6, 111, '2025-08-06 08:00:00'),
(7, 112, '2025-08-07 13:00:00');

-- 4. Queries

-- (a) Event-wise participant count
SELECT 
    e.id, 
    e.title, 
    COUNT(a.user_id) AS participant_count
FROM events e
LEFT JOIN attendees a ON e.id = a.event_id
GROUP BY e.id, e.title;

-- (b) Capacity alert - events where registered attendees >= max_capacity
SELECT 
    e.id, 
    e.title, 
    COUNT(a.user_id) AS participant_count, 
    e.max_capacity,
    CASE 
        WHEN COUNT(a.user_id) >= e.max_capacity THEN 'Capacity Full'
        ELSE 'Seats Available'
    END AS status
FROM events e
LEFT JOIN attendees a ON e.id = a.event_id
GROUP BY e.id, e.title, e.max_capacity;
