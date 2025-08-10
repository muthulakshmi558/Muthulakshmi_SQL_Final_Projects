-- 1️ Create Database
CREATE DATABASE it_support_ticket_system;
USE it_support_ticket_system;

-- 2️ Create Tables
CREATE TABLE tickets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    issue VARCHAR(255),
    category VARCHAR(50),
    status VARCHAR(20),
    created_at DATETIME,
    resolved_at DATETIME
);

CREATE TABLE support_staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE assignments (
    ticket_id INT,
    staff_id INT,
    PRIMARY KEY (ticket_id, staff_id),
    FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    FOREIGN KEY (staff_id) REFERENCES support_staff(id)
);

-- 3️ Insert Sample Data
INSERT INTO tickets (user_id, issue, category, status, created_at, resolved_at) VALUES
(1, 'Cannot login to account', 'Login', 'Resolved', '2025-08-01 09:15:00', '2025-08-01 11:15:00'),
(2, 'System crash during update', 'Software', 'Resolved', '2025-08-02 14:20:00', '2025-08-02 17:00:00'),
(3, 'Printer not working', 'Hardware', 'Pending', '2025-08-03 10:00:00', NULL),
(4, 'Email not syncing', 'Network', 'Resolved', '2025-08-03 12:30:00', '2025-08-03 14:00:00'),
(5, 'Slow internet speed', 'Network', 'Pending', '2025-08-04 09:00:00', NULL),
(6, 'Software license expired', 'Software', 'Resolved', '2025-08-04 15:45:00', '2025-08-04 16:30:00'),
(7, 'Forgot password reset link not received', 'Login', 'Resolved', '2025-08-05 08:00:00', '2025-08-05 08:20:00'),
(8, 'System overheating', 'Hardware', 'Pending', '2025-08-05 13:00:00', NULL);

INSERT INTO support_staff (name) VALUES
('John Smith'),
('Emily Davis'),
('Michael Johnson'),
('Sarah Lee'),
('David Brown'),
('Olivia Wilson');

INSERT INTO assignments (ticket_id, staff_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 2),
(5, 4),
(6, 1),
(7, 5),
(8, 6);

-- 4️ Queries

-- A) Average resolution time for resolved tickets (in hours)
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_at, resolved_at)) / 60, 2) AS avg_resolution_time_hours
FROM tickets
WHERE status = 'Resolved';

-- B) Ticket volume by category
SELECT 
    category, 
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY category
ORDER BY total_tickets DESC;

-- C) List all tickets with assigned staff member
SELECT 
    t.id AS ticket_id,
    t.issue,
    t.category,
    t.status,
    s.name AS assigned_staff
FROM tickets t
JOIN assignments a ON t.id = a.ticket_id
JOIN support_staff s ON a.staff_id = s.id;

-- D) Tickets still pending with staff assigned
SELECT 
    t.id AS ticket_id,
    t.issue,
    s.name AS assigned_staff
FROM tickets t
JOIN assignments a ON t.id = a.ticket_id
JOIN support_staff s ON a.staff_id = s.id
WHERE t.status = 'Pending';

-- E) Staff workload (number of tickets handled)
SELECT 
    s.name,
    COUNT(a.ticket_id) AS total_tickets
FROM support_staff s
LEFT JOIN assignments a ON s.id = a.staff_id
GROUP BY s.name
ORDER BY total_tickets DESC;
