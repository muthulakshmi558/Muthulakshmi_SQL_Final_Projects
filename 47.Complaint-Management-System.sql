-- 1. Create Database
CREATE DATABASE complaint_management;
USE complaint_management;

-- 2. Table Creation
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    department_id INT,
    status ENUM('Open', 'In Progress', 'Resolved', 'Closed') DEFAULT 'Open',
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE responses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    complaint_id INT,
    responder_id INT,
    message TEXT NOT NULL,
    response_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id)
);

-- 3. Insert Sample Data
INSERT INTO departments (name) VALUES
('Sanitation'),
('Water Supply'),
('Electricity'),
('Road Maintenance'),
('Public Health'),
('Parks & Recreation'),
('Transport');

INSERT INTO complaints (title, department_id, status) VALUES
('Garbage not collected for 3 days', 1, 'Open'),
('Water leakage near main road', 2, 'In Progress'),
('Frequent power cuts', 3, 'Open'),
('Potholes on main street', 4, 'Resolved'),
('Mosquito breeding in park', 5, 'Open'),
('Broken swings in children park', 6, 'Closed'),
('Bus stop shelter damaged', 7, 'In Progress'),
('Sewage overflow', 1, 'Resolved');

INSERT INTO responses (complaint_id, responder_id, message) VALUES
(1, 101, 'Complaint received, cleaning scheduled tomorrow.'),
(2, 102, 'Leak inspection in progress.'),
(4, 103, 'Road repaired last week.'),
(8, 104, 'Drainage cleared and sanitized.');

-- 4. SQL Queries

-- a) View all complaints with department name
SELECT c.id, c.title, d.name AS department, c.status
FROM complaints c
JOIN departments d ON c.department_id = d.id;

-- b) Count of complaints per department
SELECT d.name AS department, COUNT(c.id) AS total_complaints
FROM departments d
LEFT JOIN complaints c ON d.id = c.department_id
GROUP BY d.id, d.name;

-- c) Status summary (how many complaints are Open, Resolved, etc.)
SELECT status, COUNT(*) AS total
FROM complaints
GROUP BY status;

-- d) View all responses for a specific complaint (example: complaint_id = 1)
SELECT r.id, r.message, r.response_date
FROM responses r
WHERE r.complaint_id = 1;

-- e) List departments with most pending complaints
SELECT d.name, COUNT(c.id) AS pending_complaints
FROM departments d
JOIN complaints c ON d.id = c.department_id
WHERE c.status IN ('Open', 'In Progress')
GROUP BY d.id, d.name
ORDER BY pending_complaints DESC;

-- f) Get all resolved complaints with their response message
SELECT c.title, r.message, r.response_date
FROM complaints c
JOIN responses r ON c.id = r.complaint_id
WHERE c.status = 'Resolved';
