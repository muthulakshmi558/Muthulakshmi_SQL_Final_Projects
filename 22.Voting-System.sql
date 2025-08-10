-- 1. Create Database
CREATE DATABASE VotingSystemDB;
USE VotingSystemDB;

-- 2. Create Tables

-- Users Table (for tracking who voted)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Polls Table
CREATE TABLE polls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question VARCHAR(255) NOT NULL
);

-- Options Table
CREATE TABLE options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    poll_id INT NOT NULL,
    option_text VARCHAR(255) NOT NULL,
    CONSTRAINT fk_poll FOREIGN KEY (poll_id) REFERENCES polls(id) ON DELETE CASCADE
);

-- Votes Table
CREATE TABLE votes (
    user_id INT NOT NULL,
    option_id INT NOT NULL,
    voted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, option_id),
    CONSTRAINT fk_vote_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_vote_option FOREIGN KEY (option_id) REFERENCES options(id) ON DELETE CASCADE,
    CONSTRAINT unique_user_poll UNIQUE (user_id, option_id) -- Prevents duplicate votes for the same option
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

-- Polls
INSERT INTO polls (question) VALUES
('What is your favorite programming language?'),
('Which is the best mobile brand in 2025?');

-- Options
INSERT INTO options (poll_id, option_text) VALUES
(1, 'Python'),
(1, 'JavaScript'),
(1, 'Java'),
(1, 'C#'),
(2, 'Apple'),
(2, 'Samsung'),
(2, 'OnePlus'),
(2, 'Xiaomi');

-- Votes
INSERT INTO votes (user_id, option_id, voted_at) VALUES
(1, 1, '2025-08-01 10:00:00'),
(2, 2, '2025-08-01 10:05:00'),
(3, 1, '2025-08-01 10:10:00'),
(4, 3, '2025-08-01 10:15:00'),
(5, 6, '2025-08-02 09:00:00'),
(6, 5, '2025-08-02 09:10:00'),
(7, 5, '2025-08-02 09:15:00'),
(8, 7, '2025-08-02 09:20:00');

-- 4. Useful Queries

-- a) Count votes for each option in a poll
SELECT o.option_text, COUNT(v.user_id) AS TotalVotes
FROM options o
LEFT JOIN votes v ON o.id = v.option_id
WHERE o.poll_id = 1
GROUP BY o.option_text
ORDER BY TotalVotes DESC;

-- b) Show poll results with percentages
SELECT 
    o.option_text,
    COUNT(v.user_id) AS TotalVotes,
    CONCAT(ROUND((COUNT(v.user_id) / t.total_votes) * 100, 2), '%') AS Percentage
FROM options o
LEFT JOIN votes v ON o.id = v.option_id
JOIN (
    SELECT poll_id, COUNT(user_id) AS total_votes
    FROM options o
    LEFT JOIN votes v ON o.id = v.option_id
    WHERE poll_id = 1
    GROUP BY poll_id
) t ON o.poll_id = t.poll_id
WHERE o.poll_id = 1
GROUP BY o.option_text, t.total_votes
ORDER BY TotalVotes DESC;

-- c) List all polls with total participants
SELECT p.question, COUNT(DISTINCT v.user_id) AS TotalParticipants
FROM polls p
LEFT JOIN options o ON p.id = o.poll_id
LEFT JOIN votes v ON o.id = v.option_id
GROUP BY p.id, p.question;

-- d) Find which option a specific user voted for
SELECT u.name, p.question, o.option_text, v.voted_at
FROM votes v
JOIN users u ON v.user_id = u.id
JOIN options o ON v.option_id = o.id
JOIN polls p ON o.poll_id = p.id
WHERE u.name = 'Arun Kumar';

-- e) Users who have not voted in a specific poll
SELECT u.name
FROM users u
WHERE u.id NOT IN (
    SELECT DISTINCT v.user_id
    FROM votes v
    JOIN options o ON v.option_id = o.id
    WHERE o.poll_id = 1
);

-- f) Polls where a user has voted
SELECT DISTINCT p.question
FROM polls p
JOIN options o ON p.id = o.poll_id
JOIN votes v ON o.id = v.option_id
WHERE v.user_id = 1;
