CREATE DATABASE sales_crm;
USE sales_crm;

-- USERS
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- LEADS
CREATE TABLE leads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    source VARCHAR(100) NOT NULL -- e.g., Website, Referral, Ads, etc.
);

-- DEALS
CREATE TABLE deals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lead_id INT,
    user_id INT,
    stage ENUM('New', 'Contacted', 'Proposal', 'Negotiation', 'Won', 'Lost'),
    amount DECIMAL(10,2),
    created_at DATE,
    FOREIGN KEY (lead_id) REFERENCES leads(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (name) VALUES 
('Ravi'), ('Neha'), ('Karan'), ('Divya'),
('Amit'), ('Sneha'), ('Vikram'), ('Ishita');

INSERT INTO leads (name, source) VALUES 
('Tata Motors', 'Website'),
('Infosys', 'Referral'),
('Wipro', 'Email Campaign'),
('Reliance', 'Cold Call'),
('HCL', 'Ads'),
('Tech Mahindra', 'Website'),
('L&T', 'Event'),
('Zoho', 'Referral');

INSERT INTO deals (lead_id, user_id, stage, amount, created_at) VALUES
(1, 1, 'New', 50000, '2025-07-01'),
(2, 2, 'Proposal', 75000, '2025-07-05'),
(3, 3, 'Negotiation', 85000, '2025-07-10'),
(4, 4, 'Won', 120000, '2025-07-12'),
(5, 5, 'Lost', 40000, '2025-07-15'),
(6, 6, 'Proposal', 65000, '2025-07-18'),
(7, 1, 'Contacted', 30000, '2025-07-20'),
(8, 3, 'Won', 95000, '2025-07-25');

-- Show progression history of deals per lead sorted by stage & time
SELECT 
    d.id AS deal_id,
    l.name AS lead_name,
    u.name AS owner,
    d.stage,
    d.amount,
    d.created_at,
    ROW_NUMBER() OVER (PARTITION BY lead_id ORDER BY created_at) AS stage_sequence
FROM deals d
JOIN leads l ON d.lead_id = l.id
JOIN users u ON d.user_id = u.id;

-- Aggregate – Total Deals by Stage
SELECT 
    stage,
    COUNT(*) AS total_deals,
    SUM(amount) AS total_value
FROM deals
GROUP BY stage
ORDER BY FIELD(stage, 'New', 'Contacted', 'Proposal', 'Negotiation', 'Won', 'Lost');

-- Filter – Deals by Date Range
SELECT 
    d.id, l.name AS lead_name, u.name AS owner, stage, amount, created_at
FROM deals d
JOIN leads l ON d.lead_id = l.id
JOIN users u ON d.user_id = u.id
WHERE created_at BETWEEN '2025-07-01' AND '2025-07-20';

-- Filter – Won Deals from Referrals Only
SELECT 
    d.id, l.name AS lead_name, u.name AS owner, amount, created_at
FROM deals d
JOIN leads l ON d.lead_id = l.id
JOIN users u ON d.user_id = u.id
WHERE stage = 'Won' AND l.source = 'Referral';

-- Total Deal Value by User (All Time)
SELECT 
    u.name AS sales_person,
    COUNT(d.id) AS total_deals,
    SUM(d.amount) AS total_amount
FROM deals d
JOIN users u ON d.user_id = u.id
GROUP BY u.id
ORDER BY total_amount DESC;
