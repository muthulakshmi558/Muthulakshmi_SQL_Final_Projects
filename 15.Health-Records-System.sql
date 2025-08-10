-- 1️ Database Creation
CREATE DATABASE health_records;
USE health_records;

-- 2️ Table Creation
CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE medications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE prescription_details (
    prescription_id INT,
    medication_id INT,
    dosage VARCHAR(50),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id),
    FOREIGN KEY (medication_id) REFERENCES medications(id)
);

-- 3️ Insert Sample Data
INSERT INTO patients (name, age, gender) VALUES
('Arun Kumar', 32, 'Male'),
('Meena Rani', 28, 'Female'),
('Suresh Babu', 45, 'Male'),
('Lakshmi Priya', 35, 'Female'),
('Ravi Shankar', 50, 'Male'),
('Kavitha Devi', 40, 'Female');

INSERT INTO medications (name) VALUES
('Paracetamol 500mg'),
('Amoxicillin 250mg'),
('Cetirizine 10mg'),
('Vitamin C 500mg'),
('Metformin 500mg'),
('Ibuprofen 400mg'),
('Omeprazole 20mg');

INSERT INTO prescriptions (patient_id, date) VALUES
(1, '2025-08-01'),
(1, '2025-08-10'),
(2, '2025-08-05'),
(3, '2025-08-02'),
(4, '2025-08-06'),
(5, '2025-08-03'),
(6, '2025-08-08');

INSERT INTO prescription_details (prescription_id, medication_id, dosage) VALUES
(1, 1, '1 tablet twice daily'),
(1, 4, '1 tablet daily'),
(2, 2, '1 capsule thrice daily'),
(3, 3, '1 tablet daily at night'),
(4, 5, '1 tablet morning & night'),
(5, 6, '1 tablet twice daily'),
(6, 7, '1 capsule before breakfast'),
(7, 1, '1 tablet twice daily');

-- 4️ SQL Queries

-- 📝 1. List all patients with their prescriptions
SELECT p.name, pr.id AS prescription_id, pr.date
FROM patients p
JOIN prescriptions pr ON p.id = pr.patient_id;

-- 📝 2. Show all medications prescribed to 'Arun Kumar'
SELECT p.name, m.name AS medication, pd.dosage
FROM patients p
JOIN prescriptions pr ON p.id = pr.patient_id
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
WHERE p.name = 'Arun Kumar';

-- 📝 3. Filter prescriptions given after '2025-08-05'
SELECT p.name, pr.date
FROM prescriptions pr
JOIN patients p ON pr.patient_id = p.id
WHERE pr.date > '2025-08-05';

-- 📝 4. Count total prescriptions per patient
SELECT p.name, COUNT(pr.id) AS total_prescriptions
FROM patients p
LEFT JOIN prescriptions pr ON p.id = pr.patient_id
GROUP BY p.name;

-- 📝 5. Find patients who were prescribed 'Paracetamol 500mg'
SELECT DISTINCT p.name
FROM patients p
JOIN prescriptions pr ON p.id = pr.patient_id
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
WHERE m.name = 'Paracetamol 500mg';

-- 📝 6. Show all prescriptions with medication list (joined in one row)
SELECT pr.id AS prescription_id, p.name, GROUP_CONCAT(m.name SEPARATOR ', ') AS medications
FROM prescriptions pr
JOIN patients p ON pr.patient_id = p.id
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
GROUP BY pr.id, p.name;
