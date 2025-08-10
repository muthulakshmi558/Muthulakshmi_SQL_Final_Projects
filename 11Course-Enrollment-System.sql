-- 1️Create Database
CREATE DATABASE course_enrollment_db;
USE course_enrollment_db;

-- 2️Create Tables

-- Courses table
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    instructor VARCHAR(100) NOT NULL
);

-- Students table
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Enrollments table (Many-to-Many relationship)
CREATE TABLE enrollments (
    course_id INT,
    student_id INT,
    enroll_date DATE NOT NULL,
    PRIMARY KEY (course_id, student_id),
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- 3️Insert Sample Data

-- Courses (6 entries)
INSERT INTO courses (title, instructor) VALUES
('Web Development Basics', 'John Smith'),
('Data Science 101', 'Emily Davis'),
('Advanced SQL', 'Michael Brown'),
('Python for Beginners', 'Sarah Wilson'),
('Machine Learning', 'David Johnson'),
('UI/UX Design Principles', 'Anna Lee');

-- Students (6 entries)
INSERT INTO students (name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Martin', 'bob@example.com'),
('Charlie White', 'charlie@example.com'),
('Diana Green', 'diana@example.com'),
('Ethan King', 'ethan@example.com'),
('Fiona Scott', 'fiona@example.com');

-- Enrollments (8 entries)
INSERT INTO enrollments (course_id, student_id, enroll_date) VALUES
(1, 1, '2025-01-10'),
(1, 2, '2025-01-12'),
(2, 3, '2025-02-01'),
(3, 4, '2025-02-15'),
(3, 5, '2025-02-16'),
(4, 6, '2025-03-01'),
(5, 1, '2025-03-05'),
(6, 2, '2025-03-08');

-- 4️⃣ Useful Queries

-- 🔹 View all courses
SELECT * FROM courses;

-- 🔹 View all students
SELECT * FROM students;

-- 🔹 List all enrollments with student & course details
SELECT 
    e.enroll_date,
    s.name AS student_name,
    s.email,
    c.title AS course_title,
    c.instructor
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.id
ORDER BY e.enroll_date;

-- 🔹 Find all students in a specific course (Example: course_id = 1)
SELECT s.name, s.email
FROM enrollments e
JOIN students s ON e.student_id = s.id
WHERE e.course_id = 1;

-- 🔹 Count enrolled students per course
SELECT 
    c.title AS course_title,
    COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY total_students DESC;

-- 🔹 List courses with no students
SELECT c.title
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
WHERE e.student_id IS NULL;
