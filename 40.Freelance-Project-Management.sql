-- 1. Create Database
CREATE DATABASE freelance_project_management;
USE freelance_project_management;

-- 2. Create Tables
CREATE TABLE freelancers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    skill VARCHAR(100) NOT NULL
);

CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL
);

CREATE TABLE proposals (
    freelancer_id INT,
    project_id INT,
    bid_amount DECIMAL(10,2) NOT NULL,
    status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
    PRIMARY KEY (freelancer_id, project_id),
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

-- 3. Insert Sample Data
INSERT INTO freelancers (name, skill) VALUES
('Arun Kumar', 'Web Development'),
('Priya Sharma', 'Graphic Design'),
('Vikram Singh', 'Content Writing'),
('Anjali Mehta', 'Mobile App Development'),
('Ravi Verma', 'SEO Specialist'),
('Karan Patel', 'UI/UX Design'),
('Neha Reddy', 'Digital Marketing'),
('Suresh Iyer', 'Backend Development');

INSERT INTO projects (client_name, title) VALUES
('TechSoft Pvt Ltd', 'E-commerce Website'),
('GreenLeaf Agency', 'Brand Logo Design'),
('EduWorld', 'Educational Blog Content'),
('FoodiesHub', 'Restaurant Mobile App'),
('TravelMate', 'SEO Optimization'),
('Designify', 'UI Redesign Project'),
('CodeBase Solutions', 'API Development'),
('MarketMasters', 'Social Media Campaign');

INSERT INTO proposals (freelancer_id, project_id, bid_amount, status) VALUES
(1, 1, 50000, 'Accepted'),
(2, 2, 15000, 'Accepted'),
(3, 3, 8000, 'Pending'),
(4, 4, 60000, 'Accepted'),
(5, 5, 20000, 'Rejected'),
(6, 6, 25000, 'Pending'),
(7, 8, 18000, 'Accepted'),
(8, 7, 35000, 'Pending'),
(1, 5, 22000, 'Pending'),
(2, 6, 26000, 'Rejected');

-- 4. Queries

-- a) View all bids for a specific project (example: Project ID 1)
SELECT f.name AS Freelancer, p.title AS Project, pr.bid_amount, pr.status
FROM proposals pr
JOIN freelancers f ON pr.freelancer_id = f.id
JOIN projects p ON pr.project_id = p.id
WHERE p.id = 1;

-- b) List all accepted proposals
SELECT f.name AS Freelancer, p.title AS Project, pr.bid_amount
FROM proposals pr
JOIN freelancers f ON pr.freelancer_id = f.id
JOIN projects p ON pr.project_id = p.id
WHERE pr.status = 'Accepted';

-- c) Count projects per freelancer
SELECT f.name AS Freelancer, COUNT(pr.project_id) AS ProjectCount
FROM freelancers f
LEFT JOIN proposals pr ON f.id = pr.freelancer_id
GROUP BY f.id, f.name;

-- d) Find freelancers who have no proposals yet
SELECT f.name
FROM freelancers f
LEFT JOIN proposals pr ON f.id = pr.freelancer_id
WHERE pr.project_id IS NULL;

-- e) Highest bid per project
SELECT p.title, MAX(pr.bid_amount) AS HighestBid
FROM proposals pr
JOIN projects p ON pr.project_id = p.id
GROUP BY p.id, p.title;

-- f) Average bid amount per skill
SELECT f.skill, AVG(pr.bid_amount) AS AverageBid
FROM proposals pr
JOIN freelancers f ON pr.freelancer_id = f.id
GROUP BY f.skill;

-- g) Projects with no accepted proposals
SELECT p.title
FROM projects p
LEFT JOIN proposals pr ON p.id = pr.project_id AND pr.status = 'Accepted'
WHERE pr.project_id IS NULL;
