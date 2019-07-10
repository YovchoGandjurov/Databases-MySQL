# 1.	Employees with Salary Above 35000

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT first_name, last_name
    FROM employees
    WHERE salary > 35000
    ORDER BY first_name, last_name , employee_id;
END $$


# 2. Employees with Salary Above Number
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(number DOUBLE)
BEGIN
	SELECT first_name, last_name
    FROM employees
    WHERE salary >= number
    ORDER BY first_name, last_name, employee_id;
END $$


# 3.Town Names Starting With
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(town_start VARCHAR(20))
BEGIN
	SELECT name
    FROM towns
    WHERE name LIKE CONCAT(town_start, '%')
    ORDER BY name;
END $$


# 4.Employees from Town

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(name_of_town VARCHAR(30))
BEGIN
	SELECT e.first_name, e.last_name
    FROM employees e
    JOIN addresses a
    ON e.address_id = a.address_id
    JOIN towns t
    ON a.town_id = t.town_id
    WHERE t.name = name_of_town
    ORDER BY first_name, last_name, employee_id;
END $$


#5.	Salary Level Function
# CREATE FUNCTION ufn_get_salary_level(emp_salary DOUBLE)





















































































