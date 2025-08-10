-- 1️ Create Database
CREATE DATABASE course_progress_tracker;
USE course_progress_tracker;

-- 2️ Table Creation
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE lessons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE progress (
    student_id INT NOT NULL,
    lesson_id INT NOT NULL,
    completed_at DATE,
    PRIMARY KEY (student_id, lesson_id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

-- 3️ Insert Sample Data
INSERT INTO courses (name) VALUES
('Web Development'),
('Data Science'),
('Graphic Design');

INSERT INTO lessons (course_id, title) VALUES
(1, 'HTML Basics'),
(1, 'CSS Fundamentals'),
(1, 'JavaScript Intro'),
(2, 'Python Basics'),
(2, 'Data Analysis with Pandas'),
(3, 'Photoshop Essentials'),
(3, 'Illustrator Basics');

INSERT INTO progress (student_id, lesson_id, completed_at) VALUES
(1, 1, '2025-08-01'),
(1, 2, '2025-08-02'),
(1, 4, '2025-08-05'),
(2, 1, '2025-08-03'),
(2, 2, NULL), -- Not completed yet
(2, 3, '2025-08-06'),
(3, 6, '2025-08-07');

-- 4️ Queries

-- 🔹 a) List all lessons of a specific course
SELECT c.name AS course_name, l.title AS lesson_title
FROM courses c
JOIN lessons l ON c.id = l.course_id
WHERE c.name = 'Web Development';

-- 🔹 b) Count lessons completed by each student
SELECT p.student_id, COUNT(p.lesson_id) AS completed_lessons
FROM progress p
WHERE p.completed_at IS NOT NULL
GROUP BY p.student_id;

-- 🔹 c) Completion percentage per student per course
SELECT 
    p.student_id,
    c.name AS course_name,
    CONCAT(
        ROUND(
            (SUM(CASE WHEN p.completed_at IS NOT NULL THEN 1 ELSE 0 END) / COUNT(l.id)) * 100, 
            2
        ), '%'
    ) AS completion_percentage
FROM courses c
JOIN lessons l ON c.id = l.course_id
LEFT JOIN progress p ON l.id = p.lesson_id
GROUP BY p.student_id, c.id;

-- 🔹 d) List students who have completed all lessons in a course
SELECT p.student_id, c.name AS course_name
FROM courses c
JOIN lessons l ON c.id = l.course_id
JOIN progress p ON l.id = p.lesson_id
WHERE p.completed_at IS NOT NULL
GROUP BY p.student_id, c.id
HAVING COUNT(p.lesson_id) = (SELECT COUNT(*) FROM lessons WHERE course_id = c.id);

-- 🔹 e) Find incomplete lessons for a student
SELECT c.name AS course_name, l.title AS lesson_title
FROM courses c
JOIN lessons l ON c.id = l.course_id
LEFT JOIN progress p ON l.id = p.lesson_id AND p.student_id = 1
WHERE p.completed_at IS NULL;
