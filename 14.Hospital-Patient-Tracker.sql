-- 1. Create Database
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- 2. Create Tables

-- Patients Table
CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL
);

-- Doctors Table
CREATE TABLE doctors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

-- Visits Table
CREATE TABLE visits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_time DATETIME NOT NULL,
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    CONSTRAINT fk_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    CONSTRAINT unique_doctor_visit UNIQUE (doctor_id, visit_time) -- Prevent overlapping visits for same doctor/time
);

-- 3. Insert Sample Data

-- Patients
INSERT INTO patients (name, dob) VALUES
('Murugan', '1985-02-14'),
('Krishnan', '1990-07-21'),
('Siva', '1978-05-09'),
('Vijay', '2000-12-01'),
('Anitha', '1995-03-30'),
('Rekha', '1988-09-15'),
('Karthik', '1992-06-10'),
('Divya', '1983-11-25');

-- Doctors
INSERT INTO doctors (name, specialization) VALUES
('Dr Arun', 'Cardiologist'),
('Dr Latha', 'Pediatrician'),
('Dr Siva', 'Orthopedic'),
('Dr Ramu', 'Dermatologist'),
('Dr Raja', 'Neurologist'),
('Dr Saravanan', 'ENT Specialist'),
('Dr Sandhya', 'Gynecologist'),
('Dr Kumar', 'General Physician');

-- Visits
INSERT INTO visits (patient_id, doctor_id, visit_time) VALUES
(1, 1, '2025-08-11 10:00:00'),
(2, 1, '2025-08-11 11:00:00'),
(3, 2, '2025-08-12 09:30:00'),
(4, 3, '2025-08-13 14:00:00'),
(5, 4, '2025-08-13 15:30:00'),
(6, 5, '2025-08-14 10:15:00'),
(7, 6, '2025-08-14 11:45:00'),
(8, 7, '2025-08-15 13:00:00');

-- 4. Useful Queries

-- a) List all patients visiting a specific doctor (Example: Dr Arun)
SELECT p.name AS PatientName, d.name AS DoctorName, v.visit_time
FROM visits v
JOIN patients p ON v.patient_id = p.id
JOIN doctors d ON v.doctor_id = d.id
WHERE d.name = 'Dr Arun';

-- b) List all visits on a specific date (Example: 2025-08-13)
SELECT p.name AS PatientName, d.name AS DoctorName, v.visit_time
FROM visits v
JOIN patients p ON v.patient_id = p.id
JOIN doctors d ON v.doctor_id = d.id
WHERE DATE(v.visit_time) = '2025-08-13';

-- c) Count visits for each doctor
SELECT d.name AS DoctorName, COUNT(v.id) AS TotalVisits
FROM doctors d
LEFT JOIN visits v ON d.id = v.doctor_id
GROUP BY d.name;

-- d) Find upcoming visits after current date/time
SELECT p.name AS PatientName, d.name AS DoctorName, v.visit_time
FROM visits v
JOIN patients p ON v.patient_id = p.id
JOIN doctors d ON v.doctor_id = d.id
WHERE v.visit_time > NOW()
ORDER BY v.visit_time ASC;

-- e) Patients with multiple visits
SELECT p.name AS PatientName, COUNT(v.id) AS VisitCount
FROM visits v
JOIN patients p ON v.patient_id = p.id
GROUP BY p.name
HAVING COUNT(v.id) > 1;

-- f) Doctors with no visits
SELECT d.name AS DoctorName
FROM doctors d
LEFT JOIN visits v ON d.id = v.doctor_id
WHERE v.id IS NULL;
