-- 1️Database Creation
CREATE DATABASE library_mgmt_db_tn;
USE library_mgmt_db_tn;

-- 2️Table Creation
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL
);

CREATE TABLE members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE borrows (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- 3️⃣ Sample Data Insert

-- Tamil Nadu Famous Books (English letters)
INSERT INTO books (title, author) VALUES
('Ponniyin Selvan', 'Kalki Krishnamurthy'),
('Silappathikaram', 'Ilango Adigal'),
('Thirukkural', 'Thiruvalluvar'),
('Sandhanathen', 'Jayakanthan'),
('Mullum Malarum', 'La Sa Ra'),
('Yaanai Doctor', 'Sukumaran'),
('Bharathiyar Kavithaigal', 'Subramania Bharathi'),
('Manimekalai', 'Sithalai Saathanar');

-- Tamil Member Names (English letters)
INSERT INTO members (name) VALUES
('Arun Kumar'),
('Priya Raj'),
('Vignesh Murali'),
('Sandhiya Devi'),
('Ganesh Kumar'),
('Sujitha Ravi'),
('Murugesan'),
('Isha Priya');

-- Borrow Records
INSERT INTO borrows (member_id, book_id, borrow_date, return_date) VALUES
(1, 1, '2025-01-10', '2025-01-15'),
(2, 2, '2025-01-12', '2025-01-20'),
(3, 3, '2025-01-15', NULL),
(4, 4, '2025-02-01', '2025-02-12'),
(5, 5, '2025-02-05', NULL),
(6, 6, '2025-02-10', '2025-02-18'),
(7, 7, '2025-02-15', NULL),
(8, 8, '2025-02-20', NULL);

-- 4️⃣ Useful Queries

-- a) All borrowed books with member details
SELECT b.id AS borrow_id, m.name AS member_name, bk.title AS book_title, b.borrow_date, b.return_date
FROM borrows b
JOIN members m ON b.member_id = m.id
JOIN books bk ON b.book_id = bk.id;

-- b) Books not yet returned
SELECT bk.title AS book_title, m.name AS borrowed_by, b.borrow_date
FROM borrows b
JOIN members m ON b.member_id = m.id
JOIN books bk ON b.book_id = bk.id
WHERE b.return_date IS NULL;

-- c) Fine calculation (₹10 per day after 7 days)
SELECT 
    m.name AS member_name,
    bk.title AS book_title,
    b.borrow_date,
    b.return_date,
    CASE 
        WHEN b.return_date IS NOT NULL AND DATEDIFF(b.return_date, b.borrow_date) > 7 
            THEN (DATEDIFF(b.return_date, b.borrow_date) - 7) * 10
        WHEN b.return_date IS NULL AND DATEDIFF(CURDATE(), b.borrow_date) > 7
            THEN (DATEDIFF(CURDATE(), b.borrow_date) - 7) * 10
        ELSE 0
    END AS fine_amount
FROM borrows b
JOIN members m ON b.member_id = m.id
JOIN books bk ON b.book_id = bk.id;

-- d) Top members by number of books borrowed
SELECT m.name AS member_name, COUNT(b.id) AS total_borrowed
FROM members m
JOIN borrows b ON m.id = b.member_id
GROUP BY m.id, m.name
ORDER BY total_borrowed DESC;

-- e) Books never borrowed
SELECT bk.title AS book_title, bk.author
FROM books bk
LEFT JOIN borrows b ON bk.id = b.book_id
WHERE b.book_id IS NULL;
