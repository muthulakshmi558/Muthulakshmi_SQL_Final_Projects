-- 1. Create Database
CREATE DATABASE vehicle_rental_system;
USE vehicle_rental_system;

-- 2. Create Tables
CREATE TABLE vehicles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50) NOT NULL,
    plate_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE rentals (
    vehicle_id INT,
    customer_id INT,
    start_date DATE NOT NULL,
    end_date DATE,
    PRIMARY KEY (vehicle_id, customer_id, start_date),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- 3. Insert Sample Data
INSERT INTO vehicles (type, plate_number) VALUES
('Car', 'TN01AB1234'),
('Car', 'TN02BC5678'),
('Bike', 'TN03CD9101'),
('Van', 'TN04DE1122'),
('Truck', 'TN05EF3344'),
('Scooter', 'TN06GH5566'),
('SUV', 'TN07IJ7788'),
('Car', 'TN08KL9900');

INSERT INTO customers (name) VALUES
('John Smith'),
('Mary Johnson'),
('David Williams'),
('Sophia Brown'),
('James Taylor'),
('Olivia Wilson'),
('Liam Martinez'),
('Emma Davis');

INSERT INTO rentals (vehicle_id, customer_id, start_date, end_date) VALUES
(1, 1, '2025-08-01', '2025-08-05'),
(2, 2, '2025-08-03', '2025-08-07'),
(3, 3, '2025-08-05', NULL), -- Still rented
(4, 4, '2025-08-02', '2025-08-04'),
(5, 5, '2025-08-01', '2025-08-10'),
(6, 6, '2025-08-06', NULL), -- Still rented
(7, 7, '2025-08-03', '2025-08-08'),
(8, 8, '2025-08-04', '2025-08-06');

-- 4. Queries

-- a) List all available vehicles (not currently rented)
SELECT v.id, v.type, v.plate_number
FROM vehicles v
WHERE v.id NOT IN (
    SELECT vehicle_id FROM rentals WHERE end_date IS NULL OR end_date >= CURDATE()
);

-- b) Count total rentals per vehicle type
SELECT v.type, COUNT(r.vehicle_id) AS total_rentals
FROM rentals r
JOIN vehicles v ON r.vehicle_id = v.id
GROUP BY v.type;

-- c) Calculate rental duration and estimated charge (₹500 per day for cars, ₹300 for bikes, ₹800 for trucks/SUVs, ₹400 others)
SELECT 
    c.name AS customer_name,
    v.type,
    v.plate_number,
    DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) AS rental_days,
    CASE 
        WHEN v.type = 'Car' THEN DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) * 500
        WHEN v.type = 'Bike' THEN DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) * 300
        WHEN v.type = 'Truck' OR v.type = 'SUV' THEN DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) * 800
        ELSE DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) * 400
    END AS estimated_charge
FROM rentals r
JOIN vehicles v ON r.vehicle_id = v.id
JOIN customers c ON r.customer_id = c.id;

-- d) Show all vehicles currently rented
SELECT v.id, v.type, v.plate_number, c.name AS rented_by, r.start_date
FROM rentals r
JOIN vehicles v ON r.vehicle_id = v.id
JOIN customers c ON r.customer_id = c.id
WHERE r.end_date IS NULL OR r.end_date >= CURDATE();

-- e) Total income expected from all rentals
SELECT SUM(
    CASE 
        WHEN v.type = 'Car' THEN DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) * 500
        WHEN v.type = 'Bike' THEN DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) * 300
        WHEN v.type = 'Truck' OR v.type = 'SUV' THEN DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) * 800
        ELSE DATEDIFF(IFNULL(r.end_date, CURDATE()), r.start_date) * 400
    END
) AS total_income
FROM rentals r
JOIN vehicles v ON r.vehicle_id = v.id;
