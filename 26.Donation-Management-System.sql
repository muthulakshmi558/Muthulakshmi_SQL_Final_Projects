-- 1. Create Database
CREATE DATABASE donation_management;
USE donation_management;

-- 2. Create Tables
CREATE TABLE donors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE causes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL
);

CREATE TABLE donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    cause_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    donated_at DATETIME NOT NULL,
    FOREIGN KEY (donor_id) REFERENCES donors(id),
    FOREIGN KEY (cause_id) REFERENCES causes(id)
);

-- 3. Insert Sample Data (6–8 per table)
INSERT INTO donors (name) VALUES
('John Smith'),
('Emily Johnson'),
('Michael Brown'),
('Sarah Davis'),
('David Wilson'),
('Olivia Martinez'),
('James Taylor'),
('Sophia Anderson');

INSERT INTO causes (title) VALUES
('Education for All'),
('Clean Water Project'),
('Animal Welfare'),
('Disaster Relief'),
('Healthcare Access'),
('Tree Plantation Drive'),
('Homeless Shelter Fund'),
('Women Empowerment');

INSERT INTO donations (donor_id, cause_id, amount, donated_at) VALUES
(1, 1, 500.00, '2025-08-01 10:15:00'),
(2, 1, 300.00, '2025-08-02 14:20:00'),
(3, 2, 200.00, '2025-08-03 09:10:00'),
(4, 3, 150.00, '2025-08-03 18:45:00'),
(5, 4, 1000.00, '2025-08-04 11:30:00'),
(6, 5, 250.00, '2025-08-05 15:25:00'),
(7, 6, 600.00, '2025-08-05 16:10:00'),
(8, 2, 450.00, '2025-08-06 12:40:00'),
(1, 7, 700.00, '2025-08-07 10:50:00'),
(3, 8, 350.00, '2025-08-07 14:15:00');

-- 4. Queries

-- a) Total donations per cause
SELECT c.title, SUM(d.amount) AS total_donations
FROM donations d
JOIN causes c ON d.cause_id = c.id
GROUP BY c.id, c.title
ORDER BY total_donations DESC;

-- b) Rank causes by total funds raised
SELECT c.title, SUM(d.amount) AS total_donations,
       RANK() OVER (ORDER BY SUM(d.amount) DESC) AS rank_position
FROM donations d
JOIN causes c ON d.cause_id = c.id
GROUP BY c.id, c.title;

-- c) List all donations by a specific donor
SELECT donors.name AS donor_name, causes.title AS cause, d.amount, d.donated_at
FROM donations d
JOIN donors ON d.donor_id = donors.id
JOIN causes ON d.cause_id = causes.id
WHERE donors.name = 'John Smith'
ORDER BY d.donated_at DESC;

-- d) Get top 3 donors by total contribution
SELECT donors.name, SUM(d.amount) AS total_donated
FROM donations d
JOIN donors ON d.donor_id = donors.id
GROUP BY donors.id, donors.name
ORDER BY total_donated DESC
LIMIT 3;

-- e) Donations made in the last 7 days
SELECT donors.name, causes.title, d.amount, d.donated_at
FROM donations d
JOIN donors ON d.donor_id = donors.id
JOIN causes ON d.cause_id = causes.id
WHERE d.donated_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY d.donated_at DESC;
