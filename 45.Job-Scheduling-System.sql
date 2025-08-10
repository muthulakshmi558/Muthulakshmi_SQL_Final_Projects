-- 1️ Database Creation
CREATE DATABASE job_scheduling_system;
USE job_scheduling_system;

-- 2️ Table Creation
CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    frequency VARCHAR(50) NOT NULL  -- e.g., Daily, Hourly, Weekly
);

CREATE TABLE job_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    run_time DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL, -- e.g., Success, Failed, Running
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);

-- 3️⃣ Insert Sample Data
INSERT INTO jobs (name, frequency) VALUES
('Data Backup', 'Daily'),
('Email Campaign', 'Weekly'),
('Report Generation', 'Daily'),
('Log Cleanup', 'Hourly'),
('Inventory Sync', 'Daily'),
('Server Health Check', 'Hourly'),
('Sales Data ETL', 'Weekly'),
('Notification Sender', 'Hourly');

INSERT INTO job_logs (job_id, run_time, status) VALUES
(1, '2025-08-10 02:00:00', 'Success'),
(1, '2025-08-11 02:00:00', 'Failed'),
(2, '2025-08-04 10:00:00', 'Success'),
(3, '2025-08-11 06:30:00', 'Success'),
(4, '2025-08-11 07:00:00', 'Running'),
(5, '2025-08-11 01:00:00', 'Success'),
(6, '2025-08-11 07:30:00', 'Failed'),
(7, '2025-08-05 09:00:00', 'Success'),
(8, '2025-08-11 08:00:00', 'Success'),
(4, '2025-08-11 06:00:00', 'Success'),
(6, '2025-08-11 06:30:00', 'Success'),
(1, '2025-08-09 02:00:00', 'Success');

-- 4️⃣ Queries

-- a) Last run time of each job
SELECT j.name AS job_name, MAX(l.run_time) AS last_run
FROM jobs j
LEFT JOIN job_logs l ON j.id = l.job_id
GROUP BY j.name;

-- b) Next run estimation (Example: If daily → +1 day, hourly → +1 hour, weekly → +7 days)
SELECT j.name AS job_name,
       MAX(l.run_time) AS last_run,
       CASE 
           WHEN j.frequency = 'Daily' THEN DATE_ADD(MAX(l.run_time), INTERVAL 1 DAY)
           WHEN j.frequency = 'Hourly' THEN DATE_ADD(MAX(l.run_time), INTERVAL 1 HOUR)
           WHEN j.frequency = 'Weekly' THEN DATE_ADD(MAX(l.run_time), INTERVAL 7 DAY)
           ELSE NULL
       END AS next_run
FROM jobs j
LEFT JOIN job_logs l ON j.id = l.job_id
GROUP BY j.name, j.frequency;

-- c) Status count by job
SELECT j.name AS job_name, l.status, COUNT(*) AS status_count
FROM jobs j
JOIN job_logs l ON j.id = l.job_id
GROUP BY j.name, l.status
ORDER BY j.name;

-- d) Jobs that failed in the last 24 hours
SELECT j.name, l.run_time, l.status
FROM jobs j
JOIN job_logs l ON j.id = l.job_id
WHERE l.status = 'Failed'
  AND l.run_time >= NOW() - INTERVAL 1 DAY;

-- e) Jobs currently running
SELECT j.name, l.run_time
FROM jobs j
JOIN job_logs l ON j.id = l.job_id
WHERE l.status = 'Running';
