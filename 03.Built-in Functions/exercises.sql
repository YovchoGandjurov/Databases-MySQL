USE soft_uni;

#1.	Find Names of All Employees by First Name
SELECT first_name, last_name FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;


#2.	Find Names of All employees by Last Name 
SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;


#3.	Find First Names of All Employees
SELECT first_name FROM employees
WHERE department_id IN (3, 10) AND EXTRACT(YEAR FROM hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;


#4.	Find All Employees Except Engineers
SELECT first_name, last_name FROM employees
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id;


#5.	Find Towns with Name Length
SELECT name FROM towns
WHERE CHAR_LENGTH(name) IN (5, 6)
ORDER BY name;


#6. Find Towns Starting With
SELECT * FROM towns
WHERE LEFT(name, 1) IN ('M', 'K', 'B', 'E')
ORDER BY name;


#7.	Find Towns Not Starting With
SELECT * FROM towns
WHERE LEFT(name, 1) NOT IN ('R', 'B', 'D')
ORDER BY name;


#8.	Create View Employees Hired After 2000 Year
CREATE VIEW v_employees_hired_after_2000 AS
SELECT first_name, last_name FROM employees
WHERE YEAR(hire_date) > 2000;

SELECT * FROM v_employees_hired_after_2000;


#9.	Length of Last Name
SELECT first_name, last_name FROM employees
WHERE CHAR_LENGTH(last_name) = 5;


USE geography;

#10. Countries Holding ‘A’ 3 or More Times
SELECT country_name, iso_code FROM countries
WHERE country_name LIKE '%a%a%a%'
ORDER BY iso_code;


#11. Mix of Peak and River Names
SELECT p.peak_name,
       r.river_name,
       LOWER(CONCAT(p.peak_name, SUBSTRING(r.river_name, 2))) AS mix
FROM peaks p, rivers r
WHERE RIGHT(p.peak_name, 1) = LEFT(r.river_name, 1)
ORDER BY mix;

USE diablo;

#12. Games from 2011 and 2012 year
SELECT name, DATE_FORMAT(g.start, '%Y-%m-%d') AS start FROM games g
WHERE YEAR(start) IN (2011, 2012)
ORDER BY DATE(start)
LIMIT 50;


#13. User Email Providers
SELECT user_name,
       SUBSTRING(email, LOCATE('@', email) + 1) AS email_provider
FROM users
ORDER BY email_provider, user_name;


































































