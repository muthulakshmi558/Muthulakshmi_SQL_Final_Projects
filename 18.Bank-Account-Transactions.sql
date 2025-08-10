-- 1. Create Database
CREATE DATABASE BankDB;
USE BankDB;

-- 2. Create Tables

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Accounts Table
CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Transactions Table
CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    type ENUM('deposit', 'withdrawal') NOT NULL,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

-- 3. Insert Sample Data

-- Users
INSERT INTO users (name) VALUES
('Arun Kumar'),
('Priya Sharma'),
('Karthik Raja'),
('Divya Ramesh'),
('Ravi Kumar'),
('Sneha Iyer'),
('Vijay Anand'),
('Meena Rani');

-- Accounts
INSERT INTO accounts (user_id, balance) VALUES
(1, 5000.00),
(2, 10000.00),
(3, 7500.00),
(4, 12000.00),
(5, 3000.00),
(6, 15000.00),
(7, 2000.00),
(8, 500.00);

-- Transactions
INSERT INTO transactions (account_id, type, amount, timestamp) VALUES
(1, 'deposit', 2000.00, '2025-08-01 10:00:00'),
(1, 'withdrawal', 1500.00, '2025-08-02 11:30:00'),
(2, 'deposit', 5000.00, '2025-08-03 09:45:00'),
(3, 'withdrawal', 2500.00, '2025-08-04 14:20:00'),
(4, 'deposit', 4000.00, '2025-08-05 16:00:00'),
(5, 'withdrawal', 1000.00, '2025-08-06 13:15:00'),
(6, 'deposit', 3500.00, '2025-08-07 12:10:00'),
(7, 'withdrawal', 500.00, '2025-08-08 17:30:00');

-- 4. Useful Queries

-- a) CTE: Calculate current balance based on transactions
WITH transaction_totals AS (
    SELECT 
        account_id,
        SUM(CASE WHEN type = 'deposit' THEN amount ELSE -amount END) AS net_change
    FROM transactions
    GROUP BY account_id
)
SELECT 
    a.id AS AccountID,
    u.name AS UserName,
    a.balance + IFNULL(t.net_change, 0) AS CalculatedBalance
FROM accounts a
JOIN users u ON a.user_id = u.id
LEFT JOIN transaction_totals t ON a.id = t.account_id;

-- b) Transaction history for a specific account (Example: Account ID 1)
SELECT t.id, u.name AS UserName, t.type, t.amount, t.timestamp
FROM transactions t
JOIN accounts a ON t.account_id = a.id
JOIN users u ON a.user_id = u.id
WHERE a.id = 1
ORDER BY t.timestamp DESC;

-- c) Total deposits and withdrawals per account
SELECT 
    a.id AS AccountID,
    u.name AS UserName,
    SUM(CASE WHEN t.type = 'deposit' THEN t.amount ELSE 0 END) AS TotalDeposits,
    SUM(CASE WHEN t.type = 'withdrawal' THEN t.amount ELSE 0 END) AS TotalWithdrawals
FROM accounts a
JOIN users u ON a.user_id = u.id
LEFT JOIN transactions t ON a.id = t.account_id
GROUP BY a.id, u.name;

-- d) Accounts with balance below a certain threshold (Example: < 3000)
SELECT a.id AS AccountID, u.name AS UserName, a.balance
FROM accounts a
JOIN users u ON a.user_id = u.id
WHERE a.balance < 3000
ORDER BY a.balance ASC;

-- e) Recent 5 transactions across all accounts
SELECT u.name AS UserName, t.type, t.amount, t.timestamp
FROM transactions t
JOIN accounts a ON t.account_id = a.id
JOIN users u ON a.user_id = u.id
ORDER BY t.timestamp DESC
LIMIT 5;

-- f) Monthly transaction summary
SELECT 
    u.name AS UserName,
    YEAR(t.timestamp) AS Year,
    MONTH(t.timestamp) AS Month,
    SUM(CASE WHEN t.type = 'deposit' THEN t.amount ELSE 0 END) AS MonthlyDeposits,
    SUM(CASE WHEN t.type = 'withdrawal' THEN t.amount ELSE 0 END) AS MonthlyWithdrawals
FROM transactions t
JOIN accounts a ON t.account_id = a.id
JOIN users u ON a.user_id = u.id
GROUP BY u.name, YEAR(t.timestamp), MONTH(t.timestamp)
ORDER BY Year DESC, Month DESC;
