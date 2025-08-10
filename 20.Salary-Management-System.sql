-- 1. Create Database
CREATE DATABASE SalaryManagementDB;
USE SalaryManagementDB;

-- 2. Create Tables

-- Employees Table
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Salaries Table
CREATE TABLE salaries (
    emp_id INT NOT NULL,
    month DATE NOT NULL, -- Store first day of month for reference
    base DECIMAL(10,2) NOT NULL CHECK (base > 0),
    bonus DECIMAL(10,2) DEFAULT 0 CHECK (bonus >= 0),
    PRIMARY KEY (emp_id, month),
    CONSTRAINT fk_salary_employee FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- Deductions Table
CREATE TABLE deductions (
    emp_id INT NOT NULL,
    month DATE NOT NULL,
    reason VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    PRIMARY KEY (emp_id, month, reason),
    CONSTRAINT fk_deduction_employee FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- 3. Insert Sample Data

-- Employees
INSERT INTO employees (name) VALUES
('Arun Kumar'),
('Priya Sharma'),
('Karthik Raja'),
('Divya Ramesh'),
('Ravi Kumar'),
('Sneha Iyer'),
('Vijay Anand'),
('Meena Rani');

-- Salaries (month format YYYY-MM-01)
INSERT INTO salaries (emp_id, month, base, bonus) VALUES
(1, '2025-08-01', 40000.00, 5000.00),
(2, '2025-08-01', 50000.00, 8000.00),
(3, '2025-08-01', 35000.00, 3000.00),
(4, '2025-08-01', 45000.00, 4500.00),
(5, '2025-08-01', 30000.00, 2000.00),
(6, '2025-08-01', 60000.00, 10000.00),
(7, '2025-08-01', 28000.00, 1500.00),
(8, '2025-08-01', 32000.00, 2500.00);

-- Deductions
INSERT INTO deductions (emp_id, month, reason, amount) VALUES
(1, '2025-08-01', 'Late Coming', 500.00),
(1, '2025-08-01', 'Tax', 2000.00),
(2, '2025-08-01', 'Tax', 3000.00),
(3, '2025-08-01', 'Leave Without Pay', 1500.00),
(4, '2025-08-01', 'Tax', 2500.00),
(5, '2025-08-01', 'Tax', 1500.00),
(6, '2025-08-01', 'Tax', 4000.00),
(7, '2025-08-01', 'Leave Without Pay', 1000.00);

-- 4. Useful Queries

-- a) Monthly salary after deductions
SELECT 
    e.name AS EmployeeName,
    s.month,
    s.base,
    s.bonus,
    IFNULL(SUM(d.amount), 0) AS TotalDeductions,
    (s.base + s.bonus - IFNULL(SUM(d.amount), 0)) AS NetSalary
FROM salaries s
JOIN employees e ON s.emp_id = e.id
LEFT JOIN deductions d ON s.emp_id = d.emp_id AND s.month = d.month
GROUP BY e.name, s.month, s.base, s.bonus
ORDER BY NetSalary DESC;

-- b) Employees with bonuses above 5000
SELECT e.name AS EmployeeName, s.month, s.bonus
FROM salaries s
JOIN employees e ON s.emp_id = e.id
WHERE s.bonus > 5000;

-- c) Total company salary expense for a month (after deductions)
SELECT 
    s.month,
    SUM(s.base + s.bonus - IFNULL(d.total_deduction, 0)) AS TotalExpense
FROM salaries s
LEFT JOIN (
    SELECT emp_id, month, SUM(amount) AS total_deduction
    FROM deductions
    GROUP BY emp_id, month
) d ON s.emp_id = d.emp_id AND s.month = d.month
GROUP BY s.month;

-- d) List deductions for a specific employee (Example: Arun Kumar)
SELECT e.name AS EmployeeName, d.reason, d.amount, d.month
FROM deductions d
JOIN employees e ON d.emp_id = e.id
WHERE e.name = 'Arun Kumar';

-- e) Employees with no deductions
SELECT e.name AS EmployeeName, s.month
FROM salaries s
JOIN employees e ON s.emp_id = e.id
LEFT JOIN deductions d ON s.emp_id = d.emp_id AND s.month = d.month
WHERE d.emp_id IS NULL;

-- f) Conditional bonus: If base salary > 50000, give extra 2000
SELECT 
    e.name AS EmployeeName,
    s.base,
    s.bonus,
    CASE WHEN s.base > 50000 THEN s.bonus + 2000 ELSE s.bonus END AS AdjustedBonus
FROM salaries s
JOIN employees e ON s.emp_id = e.id;
