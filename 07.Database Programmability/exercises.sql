USE soft_uni;

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

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(emp_salary DOUBLE)
RETURNS VARCHAR(8)
BEGIN
	DECLARE result VARCHAR(8);
    SET result := IF(emp_salary < 30000, 'Low', IF(emp_salary BETWEEN 30000 AND 50000, 'Average', 'High'));
    RETURN result;
END $$

#SELECT ufn_get_salary_level(13500.00);


# 6.Employees by Salary Level
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(8))
BEGIN
		SELECT first_name, last_name FROM employees
		WHERE ufn_get_salary_level(salary) = salary_level
        ORDER BY first_name DESC, last_name DESC;
END $$

CALL usp_get_employees_by_salary_level('High');


#7.	Define Function
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS INT
BEGIN
    DECLARE indx INT DEFAULT 1;
    DECLARE symbol VARCHAR(1) DEFAULT '';
    
    WHILE indx <= char_length(word) DO
		SET symbol := SUBSTRING(word, indx, 1);
		IF LOCATE(symbol, set_of_letters) = 0 THEN
			RETURN 0;
		END IF;
        
        SET indx := indx + 1;
    END WHILE;

    RETURN 1;
END $$

SELECT ufn_is_word_comprised('itmishof', 'sofia');





























































