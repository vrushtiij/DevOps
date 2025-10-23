CREATE DATABASE IF NOT EXISTS Company;
USE Company;

CREATE TABLE IF NOT EXISTS Employee (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  role VARCHAR(100),
  salary INT
);

-- Insert sample rows
INSERT INTO Employee (name, role, salary) VALUES
  ('Alice','Developer',60000),
  ('Bob','Manager',80000),
  ('Charlie','Intern',20000);

-- Delete one row as required
DELETE FROM Employee WHERE name='Bob';

-- Show final rows
SELECT * FROM Employee;
