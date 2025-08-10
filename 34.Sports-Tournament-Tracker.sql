-- 1. Database creation
CREATE DATABASE sports_tournament;
USE sports_tournament;

-- 2. Table creation
CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE matches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    team1_id INT NOT NULL,
    team2_id INT NOT NULL,
    match_date DATE NOT NULL,
    FOREIGN KEY (team1_id) REFERENCES teams(id),
    FOREIGN KEY (team2_id) REFERENCES teams(id)
);

CREATE TABLE scores (
    match_id INT NOT NULL,
    team_id INT NOT NULL,
    score INT NOT NULL,
    PRIMARY KEY (match_id, team_id),
    FOREIGN KEY (match_id) REFERENCES matches(id),
    FOREIGN KEY (team_id) REFERENCES teams(id)
);

-- 3. Sample data insertion
INSERT INTO teams (name) VALUES
('Chennai Warriors'), ('Madurai Tigers'), ('Coimbatore Kings'),
('Trichy Panthers'), ('Salem Smashers'), ('Erode Eagles');

INSERT INTO matches (team1_id, team2_id, match_date) VALUES
(1, 2, '2025-07-01'),
(3, 4, '2025-07-02'),
(5, 6, '2025-07-03'),
(1, 3, '2025-07-04'),
(2, 5, '2025-07-05'),
(4, 6, '2025-07-06');

INSERT INTO scores (match_id, team_id, score) VALUES
-- Match 1
(1, 1, 250), (1, 2, 230),
-- Match 2
(2, 3, 180), (2, 4, 200),
-- Match 3
(3, 5, 150), (3, 6, 170),
-- Match 4
(4, 1, 210), (4, 3, 190),
-- Match 5
(5, 2, 220), (5, 5, 200),
-- Match 6
(6, 4, 240), (6, 6, 260);

-- 4. SQL Queries

-- a) List all matches with team names
SELECT m.id AS match_id, 
       t1.name AS team1, 
       t2.name AS team2, 
       m.match_date
FROM matches m
JOIN teams t1 ON m.team1_id = t1.id
JOIN teams t2 ON m.team2_id = t2.id;

-- b) Match results (winner, loser, score difference)
SELECT m.id AS match_id,
       t1.name AS team1,
       s1.score AS team1_score,
       t2.name AS team2,
       s2.score AS team2_score,
       CASE 
           WHEN s1.score > s2.score THEN t1.name
           WHEN s2.score > s1.score THEN t2.name
           ELSE 'Draw'
       END AS winner
FROM matches m
JOIN scores s1 ON m.id = s1.match_id AND m.team1_id = s1.team_id
JOIN scores s2 ON m.id = s2.match_id AND m.team2_id = s2.team_id
JOIN teams t1 ON s1.team_id = t1.id
JOIN teams t2 ON s2.team_id = t2.id;

-- c) Win/Loss stats per team
WITH match_results AS (
    SELECT m.id AS match_id,
           t1.id AS team1_id,
           s1.score AS team1_score,
           t2.id AS team2_id,
           s2.score AS team2_score
    FROM matches m
    JOIN scores s1 ON m.id = s1.match_id AND m.team1_id = s1.team_id
    JOIN scores s2 ON m.id = s2.match_id AND m.team2_id = s2.team_id
    JOIN teams t1 ON m.team1_id = t1.id
    JOIN teams t2 ON m.team2_id = t2.id
)
SELECT t.id, t.name,
       SUM(CASE WHEN (t.id = team1_id AND team1_score > team2_score) 
                     OR (t.id = team2_id AND team2_score > team1_score) THEN 1 ELSE 0 END) AS wins,
       SUM(CASE WHEN (t.id = team1_id AND team1_score < team2_score) 
                     OR (t.id = team2_id AND team2_score < team1_score) THEN 1 ELSE 0 END) AS losses
FROM teams t
JOIN match_results mr ON t.id IN (mr.team1_id, mr.team2_id)
GROUP BY t.id, t.name
ORDER BY wins DESC;

-- d) Leaderboard by wins (ties broken by total score difference)
WITH match_points AS (
    SELECT t.id AS team_id,
           SUM(CASE WHEN (t.id = m.team1_id AND s1.score > s2.score) 
                     OR (t.id = m.team2_id AND s2.score > s1.score) THEN 1 ELSE 0 END) AS wins,
           SUM(s1.score - s2.score) AS score_diff
    FROM teams t
    JOIN matches m ON t.id IN (m.team1_id, m.team2_id)
    JOIN scores s1 ON m.id = s1.match_id AND s1.team_id = t.id
    JOIN scores s2 ON m.id = s2.match_id AND s2.team_id != t.id
    GROUP BY t.id
)
SELECT t.name, mp.wins, mp.score_diff
FROM match_points mp
JOIN teams t ON mp.team_id = t.id
ORDER BY mp.wins DESC, mp.score_diff DESC;
