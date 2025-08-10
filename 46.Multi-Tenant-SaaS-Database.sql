-- 1️ Create Database
CREATE DATABASE multi_tenant_saas;
USE multi_tenant_saas;

-- 2️ Table Creation
CREATE TABLE tenants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    tenant_id INT,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_id INT,
    content TEXT,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

-- 3️ Insert Sample Data (8 rows per table)

-- Tenants
INSERT INTO tenants (name) VALUES
('Alpha Corp'),
('Beta Solutions'),
('Gamma Tech'),
('Delta Systems'),
('Epsilon Ltd'),
('Zeta Innovations'),
('Omega Enterprises'),
('Nova Labs');

-- Users
INSERT INTO users (name, tenant_id) VALUES
('Alice', 1),
('Bob', 1),
('Charlie', 2),
('Diana', 2),
('Evan', 3),
('Fiona', 4),
('George', 5),
('Hannah', 6);

-- Data
INSERT INTO data (tenant_id, content) VALUES
(1, 'Alpha project plan'),
(1, 'Alpha budget report'),
(2, 'Beta client list'),
(2, 'Beta Q3 revenue'),
(3, 'Gamma API documentation'),
(4, 'Delta user analytics'),
(5, 'Epsilon new hire onboarding'),
(6, 'Zeta research notes');

-- 4️⃣ SQL Queries

-- a) Show all tenants
SELECT * FROM tenants;

-- b) Show all users for a specific tenant (Tenant ID = 1)
SELECT u.id, u.name 
FROM users u
JOIN tenants t ON u.tenant_id = t.id
WHERE t.id = 1;

-- c) Show all data for a specific tenant (Tenant Name = 'Beta Solutions')
SELECT d.id, d.content
FROM data d
JOIN tenants t ON d.tenant_id = t.id
WHERE t.name = 'Beta Solutions';

-- d) Tenant isolation: Prevent cross-tenant view (Example for Tenant ID = 3)
SELECT u.name AS UserName, d.content
FROM users u
JOIN data d ON u.tenant_id = d.tenant_id
WHERE u.tenant_id = 3;

-- e) Count data entries per tenant
SELECT t.name AS TenantName, COUNT(d.id) AS DataCount
FROM tenants t
LEFT JOIN data d ON t.id = d.tenant_id
GROUP BY t.name;

-- f) List tenants without any data
SELECT t.name
FROM tenants t
LEFT JOIN data d ON t.id = d.tenant_id
WHERE d.id IS NULL;

-- g) Get all users with their tenant name
SELECT u.name AS UserName, t.name AS TenantName
FROM users u
JOIN tenants t ON u.tenant_id = t.id;
