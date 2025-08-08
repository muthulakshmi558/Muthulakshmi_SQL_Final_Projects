CREATE DATABASE employee_timesheet_db;
USE employee_timesheet_db;

-- Employees Table
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dept VARCHAR(100)
);

-- Projects Table
CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

-- Timesheets Table
CREATE TABLE timesheets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    project_id INT,
    hours DECIMAL(5,2),
    date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

-- Employees
INSERT INTO employees (name, dept) VALUES
('Arun', 'Engineering'),
('Divya', 'Design'),
('Karthik', 'Marketing'),
('Meena', 'HR'),
('Raj', 'Engineering'),
('Sita', 'Finance'),
('John', 'Support');

-- Projects
INSERT INTO projects (name) VALUES
('Website Redesign'),
('Mobile App Dev'),
('Ad Campaign'),
('HR System Upgrade'),
('Customer Support Tool'),
('Internal Dashboard');

-- Timesheets
INSERT INTO timesheets (emp_id, project_id, hours, date) VALUES
(1, 1, 8.0, '2025-08-01'),
(1, 2, 4.5, '2025-08-02'),
(2, 1, 6.0, '2025-08-01'),
(3, 3, 7.0, '2025-08-03'),
(4, 4, 8.0, '2025-08-02'),
(5, 1, 6.5, '2025-08-03'),
(6, 6, 5.5, '2025-08-02'),
(7, 5, 7.5, '2025-08-01');

-- Total hours per employee
SELECT e.name, SUM(t.hours) AS total_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
GROUP BY t.emp_id;

-- Hours logged per employee per project

SELECT e.name AS employee, p.name AS project, SUM(t.hours) AS total_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
GROUP BY t.emp_id, t.project_id;

-- Total hours spent on each project
SELECT p.name AS project, SUM(t.hours) AS total_hours
FROM timesheets t
JOIN projects p ON t.project_id = p.id
GROUP BY t.project_id;

-- Employee timesheet for specific week (e.g., 2025-08-01 to 2025-08-07)
SELECT e.name, t.date, p.name AS project, t.hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
WHERE t.date BETWEEN '2025-08-01' AND '2025-08-07'
ORDER BY e.name, t.date;

-- Monthly hours per employee (August 2025)
SELECT e.name, SUM(t.hours) AS total_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
WHERE MONTH(t.date) = 8 AND YEAR(t.date) = 2025
GROUP BY e.id;

-- Employees who worked more than 10 hours total
SELECT e.name, SUM(t.hours) AS total_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
GROUP BY e.id
HAVING total_hours > 10;

-- List of employees who haven’t logged any timesheet
SELECT e.name
FROM employees e
LEFT JOIN timesheets t ON e.id = t.emp_id
WHERE t.id IS NULL;
