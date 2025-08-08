CREATE DATABASE project_tracker;
USE project_tracker;

-- USERS TABLE
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- PROJECTS TABLE
CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- TASKS TABLE
CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    name VARCHAR(200) NOT NULL,
    status ENUM('pending', 'in_progress', 'completed') DEFAULT 'pending',
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

-- TASK ASSIGNMENTS TABLE
CREATE TABLE task_assignments (
    task_id INT,
    user_id INT,
    PRIMARY KEY (task_id, user_id),
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- USERS
INSERT INTO users (name) VALUES 
('Alice'), ('Bob'), ('Charlie'), ('Diana');

-- PROJECTS
INSERT INTO projects (name) VALUES 
('Website Redesign'), ('Mobile App'), ('Internal Tool');

-- TASKS
INSERT INTO tasks (project_id, name, status) VALUES
(1, 'Design homepage', 'completed'),
(1, 'Setup hosting', 'in_progress'),
(2, 'Build login feature', 'pending'),
(2, 'Test UI', 'pending'),
(3, 'Write documentation', 'in_progress'),
(3, 'Deploy to server', 'pending');

-- TASK ASSIGNMENTS
INSERT INTO task_assignments (task_id, user_id) VALUES
(1, 1), (2, 2), 
(3, 3), (4, 3), 
(5, 4), (6, 1);

-- Get all tasks with project name and assigned users
SELECT 
    t.id AS task_id,
    t.name AS task_name,
    t.status,
    p.name AS project_name,
    u.name AS assigned_user
FROM tasks t
JOIN projects p ON t.project_id = p.id
JOIN task_assignments ta ON t.id = ta.task_id
JOIN users u ON ta.user_id = u.id;

-- Count of tasks per status in a project
SELECT 
    p.name AS project_name,
    t.status,
    COUNT(*) AS task_count
FROM tasks t
JOIN projects p ON t.project_id = p.id
GROUP BY p.id, t.status;

-- List of tasks assigned to a specific user (say user_id = 3)
SELECT 
    t.id AS task_id,
    t.name AS task_name,
    t.status,
    p.name AS project
FROM tasks t
JOIN task_assignments ta ON t.id = ta.task_id
JOIN projects p ON t.project_id = p.id
WHERE ta.user_id = 3;

-- Show completed tasks per user
SELECT 
    u.name AS user,
    COUNT(*) AS completed_tasks
FROM users u
JOIN task_assignments ta ON u.id = ta.user_id
JOIN tasks t ON t.id = ta.task_id
WHERE t.status = 'completed'
GROUP BY u.id;

-- Get all pending tasks across all projects
SELECT 
    t.name AS task,
    p.name AS project,
    t.status
FROM tasks t
JOIN projects p ON t.project_id = p.id
WHERE t.status = 'pending';
