-- 1️ Database Creation
CREATE DATABASE blog_management;
USE blog_management;

-- 2️ Table Creation

-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Posts table
CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    published_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Comments table
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    comment_text TEXT NOT NULL,
    commented_at DATETIME,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 3️ Insert Sample Data

-- Users
INSERT INTO users (name) VALUES
('Arun Kumar'),
('Meena Devi'),
('Prakash Raj'),
('Sowmya Lakshmi'),
('Vikram Prabhu'),
('Nithya Shree'),
('Manoj Kumar'),
('Deepa Rani');

-- Posts
INSERT INTO posts (user_id, title, content, published_date) VALUES
(1, 'Best South Indian Breakfast', 'Idli, Dosa, Pongal details...', '2025-08-01'),
(2, 'Travel Guide to Ooty', 'Ooty travel experience...', '2025-08-03'),
(3, 'Healthy Lifestyle Tips', 'Exercise and diet plan...', '2025-08-05'),
(1, 'Street Food in Chennai', 'Exploring local food spots...', '2025-08-07'),
(4, 'Top 10 Tamil Movies', 'Kollywood movie list...', '2025-08-08'),
(5, 'Cycling in Tamil Nadu', 'Best routes for cycling...', '2025-08-09'),
(6, 'Temple Architecture', 'Famous temples in TN...', '2025-08-10'),
(2, 'Cooking Sambar', 'Step-by-step recipe...', '2025-08-11');

-- Comments
INSERT INTO comments (post_id, user_id, comment_text, commented_at) VALUES
(1, 2, 'Love this breakfast combo!', '2025-08-02 09:15:00'),
(1, 3, 'Idli with chutney is my fav!', '2025-08-02 10:00:00'),
(2, 1, 'Ooty is my dream destination', '2025-08-04 14:30:00'),
(3, 4, 'Thanks for the health tips', '2025-08-06 07:45:00'),
(4, 5, 'Street food is always the best!', '2025-08-07 21:20:00'),
(5, 6, 'I have seen 7 of these movies!', '2025-08-08 15:05:00'),
(6, 7, 'Cycling in TN is amazing!', '2025-08-09 06:50:00'),
(8, 8, 'I tried this Sambar recipe today', '2025-08-11 11:11:00');

-- 4️ SQL Queries (All Must Use)

-- a) Show all posts with author names
SELECT p.id, p.title, u.name AS author, p.published_date
FROM posts p
JOIN users u ON p.user_id = u.id;

-- b) Show all comments with post title and commenter name
SELECT c.id, p.title, u.name AS commenter, c.comment_text, c.commented_at
FROM comments c
JOIN posts p ON c.post_id = p.id
JOIN users u ON c.user_id = u.id;

-- c) Filter posts by specific user
SELECT * FROM posts WHERE user_id = 1;

-- d) Filter posts published after a certain date
SELECT * FROM posts WHERE published_date > '2025-08-05';

-- e) Count number of comments for each post
SELECT p.title, COUNT(c.id) AS total_comments
FROM posts p
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.title;

-- f) Show latest 5 posts
SELECT * FROM posts ORDER BY published_date DESC LIMIT 5;

-- g) Show posts and total comments with author name
SELECT u.name AS author, p.title, COUNT(c.id) AS comments_count
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, u.name, p.title
ORDER BY comments_count DESC;

-- h) Search posts by keyword in title
SELECT * FROM posts WHERE title LIKE '%Tamil%';
