CREATE DATABASE leave_management;
USE leave_management;

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE leave_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL
);

CREATE TABLE leave_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    leave_type_id INT,
    from_date DATE,
    to_date DATE,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(id),
    
    -- 🔐 Constraint to prevent overlapping leave per employee when status = Approved
    CONSTRAINT no_overlap CHECK (from_date <= to_date)
);

INSERT INTO employees (name) VALUES 
('Arjun'), ('Priya'), ('Rahul'), ('Divya'), 
('Karan'), ('Meena'), ('Vikram'), ('Sneha');

INSERT INTO leave_types (type_name) VALUES 
('Casual Leave'), ('Sick Leave'), 
('Earned Leave'), ('Maternity Leave'),
('Paternity Leave'), ('Unpaid Leave');

INSERT INTO leave_requests (emp_id, leave_type_id, from_date, to_date, status) VALUES
(1, 1, '2025-08-01', '2025-08-03', 'Approved'),
(2, 2, '2025-08-05', '2025-08-07', 'Pending'),
(3, 3, '2025-08-10', '2025-08-12', 'Approved'),
(4, 1, '2025-08-01', '2025-08-02', 'Rejected'),
(5, 4, '2025-08-15', '2025-08-25', 'Approved'),
(6, 5, '2025-08-10', '2025-08-11', 'Pending'),
(7, 1, '2025-08-03', '2025-08-05', 'Approved'),
(8, 6, '2025-08-20', '2025-08-22', 'Approved');

DELIMITER $$

CREATE TRIGGER prevent_overlap
BEFORE INSERT ON leave_requests
FOR EACH ROW
BEGIN
  IF NEW.status = 'Approved' THEN
    IF EXISTS (
      SELECT 1 FROM leave_requests
      WHERE emp_id = NEW.emp_id
        AND status = 'Approved'
        AND (
          NEW.from_date BETWEEN from_date AND to_date OR
          NEW.to_date BETWEEN from_date AND to_date OR
          from_date BETWEEN NEW.from_date AND NEW.to_date
        )
    ) THEN
      SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = 'Leave overlaps with existing approved leave!';
    END IF;
  END IF;
END$$

DELIMITER ;

-- Get Leave Days by Employee
SELECT 
    e.name,
    SUM(DATEDIFF(to_date, from_date) + 1) AS total_leave_days
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.id
WHERE status = 'Approved'
GROUP BY lr.emp_id;

-- Optional: List All Leave Requests
SELECT 
    e.name, 
    lt.type_name, 
    from_date, 
    to_date, 
    status
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.id
JOIN leave_types lt ON lr.leave_type_id = lt.id
ORDER BY from_date;

