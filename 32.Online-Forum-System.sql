-- 1️ Database Creation
CREATE DATABASE online_forum_system;
USE online_forum_system;

-- 2️ Table Creation

-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Threads table
CREATE TABLE threads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Posts table
CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    thread_id INT,
    user_id INT,
    content TEXT NOT NULL,
    parent_post_id INT NULL,
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES threads(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_post_id) REFERENCES posts(id)
);

-- 3️⃣ Insert Sample Data

-- Users
INSERT INTO users (name) VALUES
('Arun Kumar'),
('Priya Sharma'),
('Ravi Kumar'),
('Sneha Reddy'),
('Vikram Singh'),
('Lakshmi Narayan'),
('Manoj Varma');

-- Threads
INSERT INTO threads (title, user_id) VALUES
('Best Programming Language in 2025?', 1),
('Travel Tips for South India', 2),
('Healthy Eating Habits', 3),
('Stock Market Predictions', 4),
('Best Places for Trekking', 5),
('Online Learning Resources', 6);

-- Posts (parent_post_id = NULL means it's the first post in the thread)
INSERT INTO posts (thread_id, user_id, content, parent_post_id) VALUES
(1, 1, 'I think Python is still the best choice!', NULL),
(1, 2, 'I prefer Java for large-scale projects.', 1),
(1, 3, 'Python for data science, Java for backend.', 2),
(2, 2, 'Always carry light clothes and sunscreen.', NULL),
(2, 4, 'Don’t forget a water bottle!', 4),
(3, 3, 'Eat more fruits and vegetables daily.', NULL),
(3, 6, 'Cut down on processed food.', 6),
(4, 4, 'I think the market will rise next quarter.', NULL);

-- 4️⃣ Example Queries

-- Q1: Show all threads with the name of the user who started them
SELECT t.id AS thread_id, t.title, u.name AS started_by
FROM threads t
JOIN users u ON t.user_id = u.id;

-- Q2: Count total posts per thread
SELECT t.title, COUNT(p.id) AS total_posts
FROM threads t
LEFT JOIN posts p ON t.id = p.thread_id
GROUP BY t.id, t.title;

-- Q3: Show reply chains (self join to get parent post content)
SELECT p1.id AS post_id, p1.content AS reply, p2.content AS replied_to
FROM posts p1
LEFT JOIN posts p2 ON p1.parent_post_id = p2.id
ORDER BY p1.thread_id, p1.id;

-- Q4: Count total replies each post has
SELECT p.id AS post_id, p.content, COUNT(r.id) AS reply_count
FROM posts p
LEFT JOIN posts r ON r.parent_post_id = p.id
GROUP BY p.id, p.content;

-- Q5: List latest post in each thread
SELECT t.title, p.content, p.posted_at
FROM threads t
JOIN posts p ON t.id = p.thread_id
WHERE p.posted_at = (
    SELECT MAX(posted_at) 
    FROM posts 
    WHERE thread_id = t.id
);
