-- 1️ Create Database
CREATE DATABASE recruitment_portal;
USE recruitment_portal;

-- 2️ Create Tables
CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    company VARCHAR(100) NOT NULL
);

CREATE TABLE candidates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE applications (
    job_id INT,
    candidate_id INT,
    status VARCHAR(50) CHECK (status IN ('Applied', 'Interview', 'Hired', 'Rejected')),
    applied_at DATE,
    PRIMARY KEY (job_id, candidate_id),
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE
);

-- 3️ Insert Sample Data
INSERT INTO jobs (title, company) VALUES
('Software Engineer', 'TechCorp'),
('Data Analyst', 'DataMinds'),
('UX Designer', 'DesignPro'),
('Backend Developer', 'CodeBase'),
('Project Manager', 'BuildSmart'),
('QA Tester', 'QualityFirst');

INSERT INTO candidates (name) VALUES
('Arjun Kumar'),
('Priya Sharma'),
('Rahul Mehta'),
('Sneha Iyer'),
('Karan Singh'),
('Divya Nair'),
('Vikram Raj'),
('Meena Das');

INSERT INTO applications (job_id, candidate_id, status, applied_at) VALUES
(1, 1, 'Applied', '2025-07-01'),
(1, 2, 'Interview', '2025-07-03'),
(2, 3, 'Hired', '2025-07-05'),
(3, 4, 'Rejected', '2025-07-07'),
(4, 5, 'Applied', '2025-07-08'),
(5, 6, 'Interview', '2025-07-10'),
(6, 7, 'Applied', '2025-07-12'),
(2, 8, 'Hired', '2025-07-15');

-- 4️⃣ SQL Queries

-- a) Filter candidates by status (Example: All 'Applied' candidates)
SELECT c.id, c.name, a.status, j.title AS job_title, j.company
FROM candidates c
JOIN applications a ON c.id = a.candidate_id
JOIN jobs j ON a.job_id = j.id
WHERE a.status = 'Applied';

-- b) Job-wise applicant count
SELECT j.id, j.title, j.company, COUNT(a.candidate_id) AS total_applicants
FROM jobs j
LEFT JOIN applications a ON j.id = a.job_id
GROUP BY j.id, j.title, j.company
ORDER BY total_applicants DESC;

-- c) Recent applications (last 7 days)
SELECT c.name, j.title, a.status, a.applied_at
FROM applications a
JOIN candidates c ON a.candidate_id = c.id
JOIN jobs j ON a.job_id = j.id
WHERE a.applied_at >= CURDATE() - INTERVAL 7 DAY
ORDER BY a.applied_at DESC;
