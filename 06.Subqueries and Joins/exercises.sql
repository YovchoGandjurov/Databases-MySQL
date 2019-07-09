USE soft_uni;

# 1. Employee Address
SELECT e.employee_id, e.job_title, e.address_id, a.address_text
FROM employees e
JOIN addresses a
ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;


# 2. Addresses with Towns
SELECT e.first_name, e.last_name, t.name, a.address_text
FROM employees e
JOIN addresses a
ON e.address_id = a.address_id
JOIN towns t
ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;


#3.	Sales Employee
SELECT e.employee_id, e.first_name, e.last_name, d.name AS department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;


#4.	Employee Departments
SELECT e.employee_id, e.first_name, e.salary, d.name AS department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;


#5.	Employees Without Project
SELECT e.employee_id, e.first_name
FROM employees e
LEFT JOIN employees_projects ep
ON e.employee_id = ep.employee_id
LEFT JOIN projects p
ON p.project_id = ep.project_id
WHERE p.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;


#6.	Employees Hired After
SELECT e.first_name, e.last_name, e.hire_date, d.name AS dept_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
			AND DATE(e.hire_date) > '1999-01-01'
            AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date;


#7.	Employees with Project
SELECT e.employee_id, e.first_name, p.name AS project_name
FROM employees e

JOIN employees_projects ep
ON e.employee_id = ep.employee_id

JOIN projects p
ON ep.project_id = p.project_id AND DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL

ORDER BY e.first_name, project_name
LIMIT 5;


#8.	Employee 24
SELECT 
	e.employee_id,
	e.first_name,
    IF(YEAR(p.start_date) < '2005', p.name, NULL) AS project_name
FROM employees e
JOIN employees_projects ep
ON e.employee_id = ep.employee_id
JOIN projects p
ON ep.project_id = p.project_id AND e.employee_id = 24
ORDER BY project_name;


#9.	Employee Manager
SELECT 
	e1.employee_id,
    e1.first_name,
    e2.employee_id,
    e2.first_name AS manager_name
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.employee_id AND e1.manager_id IN (3, 7)
ORDER BY e1.first_name;


#10. Employee Summary
SELECT
	e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
	CONCAT(e2.first_name, ' ', e2.last_name) AS manager_name,
    d.name AS department_name
FROM employees e
JOIN employees e2
ON e.manager_id = e2.employee_id
JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;


#11. Min Average Salary
SELECT AVG(salary) AS min_average_salary
FROM employees
GROUP BY department_id
ORDER BY min_average_salary
LIMIT 1;

#11 Second way - using subquery
SELECT MIN(avg_salary) AS min_average_salary
FROM (
	SELECT AVG(e.salary) AS avg_salary
    FROM employees e
    GROUP BY e.department_id
) AS avg_salaries;


USE geography;

#12. Highest Peaks in Bulgaria
SELECT c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM countries c
JOIN mountains_countries mc
ON c.country_code = mc.country_code
JOIN mountains m
ON mc.mountain_id = m.id
JOIN peaks p
ON m.id = p.mountain_id
WHERE c.country_code = 'BG' AND p.elevation > 2835
ORDER BY p.elevation DESC;


#13.Count Mountain Ranges
SELECT c.country_code, COUNT(m.mountain_range) AS mountain_range
FROM countries c
JOIN mountains_countries mc
ON c.country_code = mc.country_code
JOIN mountains m
ON mc.mountain_id = m.id
WHERE c.country_name IN ('United States', 'Russia', 'Bulgaria')
GROUP BY c.country_code
ORDER BY mountain_range DESC;


#14. Countries with Rivers
SELECT c.country_name, r.river_name
FROM countries c
LEFT JOIN countries_rivers cr
ON c.country_code = cr.country_code
LEFT JOIN rivers r
ON cr.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;


#15. *Continents and Currencies
SELECT d1.continent_code, d1.currency_code, d1.currency_usage
FROM (
	SELECT c.continent_code, c.currency_code, COUNT(c.currency_code) AS currency_usage
    FROM countries AS c
    GROUP BY c.currency_code, c.continent_code
    HAVING currency_usage > 1
) AS d1

LEFT JOIN (
	SELECT c.continent_code, c.currency_code, COUNT(c.currency_code) AS currency_usage
    FROM countries AS c
    GROUP BY c.currency_code, c.continent_code
    HAVING currency_usage > 1
) AS d2
ON d1.continent_code = d2.continent_code AND d2.currency_usage > d1.currency_usage

WHERE d2.currency_usage IS NULL
ORDER BY d1.continent_code, d1.currency_code;



#16. Countries without any Mountains
SELECT COUNT(c.country_code)
FROM countries c
LEFT JOIN mountains_countries mc
ON c.country_code = mc.country_code
LEFT JOIN mountains m
ON mc.mountain_id = m.id
WHERE m.mountain_range IS NULL;


#17. Highest Peak and Longest River by Country
SELECT
	c.country_name,
	MAX(p.elevation) AS highest_peak_elevation,
    MAX(r.length) AS longest_river_length
FROM countries c

JOIN mountains_countries mc
ON c.country_code = mc.country_code

JOIN countries_rivers cr
ON c.country_code = cr.country_code

JOIN mountains m
ON mc.mountain_id = m.id

JOIN rivers r
ON cr.river_id = r.id

JOIN peaks p
ON m.id = p.mountain_id

GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC, longest_river_length DESC
LIMIT 5;

































