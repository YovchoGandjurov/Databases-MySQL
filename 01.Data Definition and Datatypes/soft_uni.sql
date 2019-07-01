CREATE DATABASE soft_uni;

USE soft_uni;

CREATE TABLE towns (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE addresses (
	id INT PRIMARY KEY AUTO_INCREMENT,
    address_text VARCHAR(50) NOT NULL,
    town_id INT,
    FOREIGN KEY (town_id) REFERENCES towns(id)
);

CREATE TABLE departments (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    job_title VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments (id),
    hire_date DATETIME NOT NULL,
    salary DOUBLE(15, 2) NOT NULL,
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);


INSERT INTO towns
VALUES
	(1, 'Sofia'),
    (2, 'Plovdiv'),
    (3, 'Varna'),
    (4, 'Burgas');


INSERT INTO departments
VALUES
	(1, 'Engineering'), 
	(2, 'Sales'), 
	(3, 'Marketing'), 
	(4, 'Software Development'), 
	(5, 'Quality Assurance');


INSERT INTO employees (id, first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES
(1, 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
(2, 'Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
(3, 'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
(4, 'Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
(5, 'Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

# Basic Select Some Fields 
SELECT name FROM towns ORDER BY name;
SELECT name FROM departments ORDER BY name;
SELECT first_name, last_name, job_title, salary FROM employees ORDER BY salary DESC;

# Increase Employees Salary 
UPDATE employees SET salary = salary * 1.1;
SELECT salary FROM employees;

# Decrease Tax Rate
USE hotel;
UPDATE payments SET tax_rate = tax_rate - tax_rate * 0.03;
SELECT tax_rate FROM payments;

# Delete All Records
USE hotel;
TRUNCATE TABLE occupancies;

