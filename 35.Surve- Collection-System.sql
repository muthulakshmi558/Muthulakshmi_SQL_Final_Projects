-- 1️ Create Database
CREATE DATABASE survey_collection_db;
USE survey_collection_db;

-- 2️ Create Tables
CREATE TABLE surveys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    survey_id INT,
    question_text VARCHAR(500) NOT NULL,
    FOREIGN KEY (survey_id) REFERENCES surveys(id)
);

CREATE TABLE responses (
    user_id INT,
    question_id INT,
    answer_text VARCHAR(255) NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- 3️ Insert Sample Data

-- Surveys
INSERT INTO surveys (title) VALUES
('Customer Satisfaction Survey'),
('Employee Feedback Survey'),
('Product Feedback Survey');

-- Questions (8+ total)
INSERT INTO questions (survey_id, question_text) VALUES
(1, 'How satisfied are you with our service?'),
(1, 'Would you recommend us to a friend?'),
(1, 'How often do you use our service?'),
(2, 'Are you happy with the work environment?'),
(2, 'Do you feel valued at work?'),
(3, 'How would you rate the product quality?'),
(3, 'Would you buy this product again?'),
(3, 'What features would you like to see?');

-- Responses (multiple users answering different questions)
INSERT INTO responses (user_id, question_id, answer_text) VALUES
(1, 1, 'Very Satisfied'),
(2, 1, 'Satisfied'),
(3, 1, 'Neutral'),
(1, 2, 'Yes'),
(2, 2, 'Yes'),
(3, 2, 'No'),
(4, 3, 'Weekly'),
(5, 3, 'Monthly'),
(1, 4, 'Yes'),
(2, 4, 'No'),
(3, 5, 'Yes'),
(4, 5, 'No'),
(1, 6, 'Excellent'),
(2, 6, 'Good'),
(3, 6, 'Average'),
(4, 7, 'Yes'),
(5, 7, 'Yes'),
(6, 7, 'No'),
(2, 8, 'More Colors'),
(3, 8, 'Faster Delivery');

-- 4️ Queries

-- A. View all surveys
SELECT * FROM surveys;

-- B. View questions for a specific survey (example: Survey ID = 1)
SELECT q.id, q.question_text
FROM questions q
WHERE q.survey_id = 1;

-- C. Count responses per question
SELECT q.question_text, COUNT(r.user_id) AS total_responses
FROM questions q
LEFT JOIN responses r ON q.id = r.question_id
GROUP BY q.question_text;

-- D. Count answers grouped by answer_text for a specific question
SELECT r.answer_text, COUNT(*) AS count
FROM responses r
WHERE r.question_id = 1
GROUP BY r.answer_text;

-- E. Pivot-style summary: Number of each answer for a survey
SELECT 
    q.question_text,
    SUM(CASE WHEN r.answer_text = 'Yes' THEN 1 ELSE 0 END) AS Yes_Count,
    SUM(CASE WHEN r.answer_text = 'No' THEN 1 ELSE 0 END) AS No_Count,
    SUM(CASE WHEN r.answer_text = 'Very Satisfied' THEN 1 ELSE 0 END) AS Very_Satisfied_Count,
    SUM(CASE WHEN r.answer_text = 'Satisfied' THEN 1 ELSE 0 END) AS Satisfied_Count,
    SUM(CASE WHEN r.answer_text = 'Neutral' THEN 1 ELSE 0 END) AS Neutral_Count
FROM questions q
LEFT JOIN responses r ON q.id = r.question_id
WHERE q.survey_id = 1
GROUP BY q.question_text;

-- F. List distinct users who responded to a survey
SELECT DISTINCT r.user_id
FROM responses r
JOIN questions q ON r.question_id = q.id
WHERE q.survey_id = 1;

-- G. Most answered question
SELECT q.question_text, COUNT(r.user_id) AS total_responses
FROM questions q
JOIN responses r ON q.id = r.question_id
GROUP BY q.id
ORDER BY total_responses DESC
LIMIT 1;
