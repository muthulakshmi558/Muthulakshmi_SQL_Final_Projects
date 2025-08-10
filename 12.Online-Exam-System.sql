-- 1 Create Database
CREATE DATABASE online_exam_db;
USE online_exam_db;

-- 2️Create Tables
CREATE TABLE exams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    exam_date DATE NOT NULL
);

CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    text VARCHAR(255) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE TABLE student_answers (
    student_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option CHAR(1) NOT NULL,
    PRIMARY KEY (student_id, question_id),
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- 3️Insert Sample Data

-- Exams
INSERT INTO exams (course_id, exam_date) VALUES
(101, '2025-01-10'),
(102, '2025-01-15'),
(103, '2025-02-01'),
(101, '2025-02-10'),
(104, '2025-02-15'),
(105, '2025-03-01'),
(102, '2025-03-05'),
(103, '2025-03-10');

-- Questions
INSERT INTO questions (exam_id, text, correct_option) VALUES
(1, 'HTML stands for?', 'A'),
(1, 'Which tag is used for headings?', 'B'),
(2, 'What is the capital of France?', 'C'),
(2, '2 + 2 = ?', 'B'),
(3, 'Which is a primary key constraint?', 'A'),
(4, 'CSS is used for?', 'D'),
(5, 'What is Cloud Computing?', 'C'),
(6, 'Cyber Security protects?', 'A');

-- Student Answers
INSERT INTO student_answers (student_id, question_id, selected_option) VALUES
(1, 1, 'A'),
(1, 2, 'B'),
(1, 3, 'C'),
(1, 4, 'B'),
(2, 1, 'B'),
(2, 2, 'B'),
(2, 3, 'C'),
(2, 4, 'A'),
(3, 5, 'A'),
(3, 6, 'D'),
(3, 7, 'C'),
(3, 8, 'A');

-- 4️⃣ Useful Queries

-- a) Join exam with answers for a given student
SELECT sa.student_id, e.id AS exam_id, q.text, sa.selected_option, q.correct_option
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
JOIN exams e ON q.exam_id = e.id
WHERE sa.student_id = 1;

-- b) Calculate total score for a given student
SELECT sa.student_id, COUNT(*) AS total_questions,
SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END) AS score
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
WHERE sa.student_id = 1
GROUP BY sa.student_id;

-- c) Calculate score per exam for a student
SELECT sa.student_id, e.id AS exam_id, 
SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END) AS score
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
JOIN exams e ON q.exam_id = e.id
WHERE sa.student_id = 1
GROUP BY e.id, sa.student_id;

-- d) Show students who got full marks in any exam
SELECT sa.student_id, e.id AS exam_id
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
JOIN exams e ON q.exam_id = e.id
GROUP BY sa.student_id, e.id
HAVING SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END) = COUNT(*);

-- e) List all questions with correct answers for a given exam
SELECT q.id, q.text, q.correct_option
FROM questions q
WHERE q.exam_id = 1;
