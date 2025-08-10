-- 1️ Create Database
CREATE DATABASE movie_db;
USE movie_db;

-- 2️ Create Tables
CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    release_year INT NOT NULL,
    genre_id INT,
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

CREATE TABLE ratings (
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    score DECIMAL(2,1) CHECK (score >= 0 AND score <= 10),
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- 3️⃣ Insert Sample Data
-- Genres
INSERT INTO genres (name) VALUES
('Action'),
('Drama'),
('Comedy'),
('Thriller'),
('Romance'),
('Horror'),
('Sci-Fi'),
('Fantasy');

-- Movies
INSERT INTO movies (title, release_year, genre_id) VALUES
('Vikram', 2022, 1),
('96', 2018, 5),
('Master', 2021, 1),
('Soorarai Pottru', 2020, 2),
('Kaithi', 2019, 4),
('Love Today', 2022, 3),
('Raatchasan', 2018, 4),
('Enthiran', 2010, 7);

-- Ratings
INSERT INTO ratings (user_id, movie_id, score) VALUES
(1, 1, 9.0),
(2, 1, 8.5),
(3, 2, 9.2),
(1, 2, 8.9),
(4, 3, 8.0),
(2, 3, 7.8),
(3, 4, 9.5),
(1, 4, 9.0),
(2, 5, 8.7),
(3, 6, 7.5),
(4, 7, 9.1),
(1, 8, 8.8);

-- 4️⃣ Queries

-- a) Get average rating for each movie
SELECT m.title, ROUND(AVG(r.score), 2) AS avg_rating
FROM movies m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id
ORDER BY avg_rating DESC;

-- b) List movies with their genre name
SELECT m.title, m.release_year, g.name AS genre
FROM movies m
JOIN genres g ON m.genre_id = g.id
ORDER BY m.release_year DESC;

-- c) Get top 5 highest-rated movies
SELECT m.title, ROUND(AVG(r.score), 2) AS avg_rating
FROM movies m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id
ORDER BY avg_rating DESC
LIMIT 5;

-- d) Get all movies in a specific genre (e.g., Thriller)
SELECT m.title, g.name AS genre
FROM movies m
JOIN genres g ON m.genre_id = g.id
WHERE g.name = 'Thriller';

-- e) Find movies released after 2020 with rating above 8
SELECT m.title, m.release_year, ROUND(AVG(r.score), 2) AS avg_rating
FROM movies m
JOIN ratings r ON m.id = r.movie_id
WHERE m.release_year > 2020
GROUP BY m.id
HAVING avg_rating > 8;
