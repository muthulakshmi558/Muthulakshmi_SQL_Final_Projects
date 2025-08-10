-- 1️ Database Creation
CREATE DATABASE loan_tracker;
USE loan_tracker;

-- 2️ Table Creation
CREATE TABLE loans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    principal DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL
);

CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    paid_on DATE NOT NULL,
    FOREIGN KEY (loan_id) REFERENCES loans(id)
);

-- 3️ Sample Data (6–8 rows)
INSERT INTO loans (user_id, principal, interest_rate) VALUES
(101, 50000, 12.5),
(102, 75000, 10.0),
(103, 100000, 11.0),
(104, 60000, 9.5),
(105, 85000, 10.5),
(106, 120000, 13.0);

INSERT INTO payments (loan_id, amount, paid_on) VALUES
(1, 5000, '2025-01-15'),
(1, 7000, '2025-02-15'),
(2, 8000, '2025-01-10'),
(2, 7500, '2025-02-10'),
(3, 15000, '2025-03-05'),
(4, 6000, '2025-01-20'),
(5, 9000, '2025-02-25'),
(6, 10000, '2025-03-01');

-- 4️ Queries

-- 🔹 Total Loan Amount with Interest
SELECT id AS loan_id,
       principal,
       interest_rate,
       (principal + (principal * interest_rate / 100)) AS total_with_interest
FROM loans;

-- 🔹 Total Paid per Loan
SELECT l.id AS loan_id,
       SUM(p.amount) AS total_paid
FROM loans l
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id;

-- 🔹 Pending Amount per Loan
SELECT l.id AS loan_id,
       (l.principal + (l.principal * l.interest_rate / 100)) AS total_with_interest,
       IFNULL(SUM(p.amount),0) AS total_paid,
       ((l.principal + (l.principal * l.interest_rate / 100)) - IFNULL(SUM(p.amount),0)) AS pending_amount
FROM loans l
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id;

-- 🔹 Loans with Due Date Passed (Assume EMI due every 30 days from first payment)
SELECT l.id AS loan_id,
       MAX(p.paid_on) AS last_payment_date,
       DATE_ADD(MAX(p.paid_on), INTERVAL 30 DAY) AS next_due_date,
       CASE 
           WHEN DATE_ADD(MAX(p.paid_on), INTERVAL 30 DAY) < CURDATE() THEN 'OVERDUE'
           ELSE 'ON TIME'
       END AS status
FROM loans l
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id;

-- 🔹 User-Wise Loan Summary
SELECT l.user_id,
       COUNT(l.id) AS total_loans,
       SUM(l.principal) AS total_principal,
       SUM(l.principal + (l.principal * l.interest_rate / 100)) AS total_with_interest
FROM loans l
GROUP BY l.user_id;
