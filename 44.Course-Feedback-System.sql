-- 1️ Database Creation
CREATE DATABASE course_feedback_db;
USE course_feedback_db;

-- 2️ Table Creation
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL
);

CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    user_id INT,
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 5),
    comments TEXT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 3️ Sample Data Insertion
INSERT INTO courses (title) VALUES
('Web Development Bootcamp'),
('Data Science with Python'),
('Digital Marketing Basics'),
('UI/UX Design Masterclass'),
('Cybersecurity Fundamentals'),
('AI & Machine Learning');

INSERT INTO feedback (course_id, user_id, rating, comments) VALUES
(1, 101, 4.5, 'Great course, learned a lot.'),
(1, 102, 4.0, 'Good content, but could be faster.'),
(2, 103, 5.0, 'Excellent and well-structured.'),
(2, 104, 4.8, 'Loved the hands-on exercises.'),
(3, 105, 3.5, 'Informative but too basic.'),
(3, 106, 4.2, 'Good for beginners.'),
(4, 107, 4.9, 'Amazing design tips and tricks.'),
(4, 108, 5.0, 'Best UI/UX course ever.'),
(5, 109, 4.1, 'Helpful for security awareness.'),
(6, 110, 4.7, 'AI concepts explained clearly.');

-- 4️ Queries

-- 1. View all courses with feedback count
SELECT c.id, c.title, COUNT(f.id) AS total_feedbacks
FROM courses c
LEFT JOIN feedback f ON c.id = f.course_id
GROUP BY c.id, c.title;

-- 2. Average rating per course
SELECT c.id, c.title, ROUND(AVG(f.rating), 2) AS avg_rating
FROM courses c
LEFT JOIN feedback f ON c.id = f.course_id
GROUP BY c.id, c.title
ORDER BY avg_rating DESC;

-- 3. Courses with average rating above 4.5
SELECT c.title, ROUND(AVG(f.rating), 2) AS avg_rating
FROM courses c
JOIN feedback f ON c.id = f.course_id
GROUP BY c.id, c.title
HAVING AVG(f.rating) > 4.5;

-- 4. Feedback comments for a specific course (e.g., course_id = 1)
SELECT c.title, f.user_id, f.rating, f.comments
FROM feedback f
JOIN courses c ON f.course_id = c.id
WHERE c.id = 1;

-- 5. Sentiment tracking (positive/negative feedback)
SELECT 
    id, 
    rating, 
    CASE 
        WHEN rating >= 4 THEN 'Positive' 
        WHEN rating >= 2 THEN 'Neutral' 
        ELSE 'Negative' 
    END AS sentiment
FROM feedback;

-- 6. Top 3 highest-rated courses
SELECT c.title, ROUND(AVG(f.rating), 2) AS avg_rating
FROM courses c
JOIN feedback f ON c.id = f.course_id
GROUP BY c.id, c.title
ORDER BY avg_rating DESC
LIMIT 3;

-- 7. Total feedback count
SELECT COUNT(*) AS total_feedback_entries FROM feedback;
