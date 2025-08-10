-- 1️ Create Database
CREATE DATABASE messaging_system_db;
USE messaging_system_db;

-- 2️ Create Tables
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE conversations (
    id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT,
    sender_id INT,
    message_text TEXT,
    sent_at DATETIME,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- 3️ Insert Sample Data (6-8 per table)
INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Emma'),
('Frank'),
('Grace'),
('Hannah');

INSERT INTO conversations VALUES
(1), (2), (3), (4), (5), (6);

INSERT INTO messages (conversation_id, sender_id, message_text, sent_at) VALUES
(1, 1, 'Hey Bob! How are you?', '2025-08-01 09:15:00'),
(1, 2, 'I’m good, Alice! You?', '2025-08-01 09:16:30'),
(2, 3, 'Meeting today at 5 PM.', '2025-08-02 10:00:00'),
(2, 4, 'Noted. I’ll be there.', '2025-08-02 10:05:00'),
(3, 5, 'Happy Birthday Grace!', '2025-08-03 12:00:00'),
(3, 7, 'Thank you so much Emma!', '2025-08-03 12:05:00'),
(4, 6, 'Project deadline is next week.', '2025-08-04 14:00:00'),
(4, 1, 'Got it, I’ll finish my part.', '2025-08-04 14:15:00');

-- 4️ SQL Queries

-- a) Retrieve all messages in a specific conversation
SELECT m.id, u.name AS sender, m.message_text, m.sent_at
FROM messages m
JOIN users u ON m.sender_id = u.id
WHERE m.conversation_id = 1
ORDER BY m.sent_at;

-- b) Get recent message for each conversation
SELECT c.id AS conversation_id, 
       u.name AS sender, 
       m.message_text, 
       m.sent_at
FROM conversations c
JOIN messages m ON c.id = m.conversation_id
JOIN users u ON m.sender_id = u.id
WHERE m.sent_at = (
    SELECT MAX(sent_at) 
    FROM messages 
    WHERE conversation_id = c.id
)
ORDER BY m.sent_at DESC;

-- c) Show all conversations for a specific user
SELECT DISTINCT c.id AS conversation_id
FROM conversations c
JOIN messages m ON c.id = m.conversation_id
WHERE m.sender_id = 1;

-- d) Count messages in each conversation
SELECT conversation_id, COUNT(*) AS total_messages
FROM messages
GROUP BY conversation_id;

-- e) Retrieve all messages sent by a specific user
SELECT m.id, c.id AS conversation_id, m.message_text, m.sent_at
FROM messages m
JOIN conversations c ON m.conversation_id = c.id
WHERE m.sender_id = 1
ORDER BY m.sent_at;

-- f) Get last 5 messages in the system
SELECT m.id, u.name AS sender, m.message_text, m.sent_at
FROM messages m
JOIN users u ON m.sender_id = u.id
ORDER BY m.sent_at DESC
LIMIT 5;
