-- 1. Create Database
CREATE DATABASE attendance_tracker;
USE attendance_tracker;

-- 2. Create Tables
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE attendance (
    student_id INT,
    course_id INT,
    date DATE,
    status ENUM('Present', 'Absent') NOT NULL,
    PRIMARY KEY (student_id, course_id, date),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 3. Insert Sample Data
INSERT INTO students (name) VALUES
('John Smith'),
('Emily Davis'),
('Michael Brown'),
('Sophia Wilson'),
('Daniel Johnson'),
('Olivia Miller');

INSERT INTO courses (name) VALUES
('Mathematics'),
('Physics'),
('Computer Science');

INSERT INTO attendance (student_id, course_id, date, status) VALUES
(1, 1, '2025-08-01', 'Present'),
(1, 1, '2025-08-02', 'Absent'),
(2, 1, '2025-08-01', 'Present'),
(3, 2, '2025-08-01', 'Present'),
(4, 2, '2025-08-02', 'Absent'),
(5, 3, '2025-08-01', 'Present'),
(6, 3, '2025-08-01', 'Absent');

-- 4. Queries

-- 4.1 Show all students
SELECT * FROM students;

-- 4.2 Show all courses
SELECT * FROM courses;

-- 4.3 Show all attendance records
SELECT s.name AS student, c.name AS course, a.date, a.status
FROM attendance a
JOIN students s ON a.student_id = s.id
JOIN courses c ON a.course_id = c.id
ORDER BY a.date;

-- 4.4 Show attendance for a specific student
SELECT s.name AS student, c.name AS course, a.date, a.status
FROM attendance a
JOIN students s ON a.student_id = s.id
JOIN courses c ON a.course_id = c.id
WHERE s.name = 'John Smith';

-- 4.5 Count total presents per student
SELECT s.name, COUNT(*) AS total_present
FROM attendance a
JOIN students s ON a.student_id = s.id
WHERE a.status = 'Present'
GROUP BY s.name;

-- 4.6 Attendance summary per course
SELECT c.name AS course, 
       SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS total_present,
       SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS total_absent
FROM attendance a
JOIN courses c ON a.course_id = c.id
GROUP BY c.name;

-- 4.7 Find students absent on a specific date
SELECT s.name, c.name AS course
FROM attendance a
JOIN students s ON a.student_id = s.id
JOIN courses c ON a.course_id = c.id
WHERE a.status = 'Absent' AND a.date = '2025-08-02';
