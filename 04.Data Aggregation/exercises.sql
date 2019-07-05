USE gringotts;

# 1. Records’ Count
SELECT COUNT(id) AS count FROM wizzard_deposits;


#2. Longest Magic Wand
SELECT MAX(magic_wand_size) AS longest_magic_wand FROM wizzard_deposits;


#3. Longest Magic Wand per Deposit Groups
SELECT deposit_group, MAX(magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY longest_magic_wand, deposit_group;


#4. Smallest Deposit Group per Magic Wand Size*
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY AVG(magic_wand_size)
LIMIT 1;


#5. Deposits Sum
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY total_sum;


#6. Deposits Sum for Ollivander family
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group;


#7.	Deposits Filter
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;


#8. Deposit charge
SELECT deposit_group, magic_wand_creator, MIN(deposit_charge) AS min_deposit_charge
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;


#9. Age Groups
SELECT
	CASE
		WHEN age <= 10 THEN '[0-10]'
        WHEN age <= 20 THEN '[11-20]'
		WHEN age <= 30 THEN '[21-30]'
        WHEN age <= 40 THEN '[31-40]'
        WHEN age <= 50 THEN '[41-50]'
        WHEN age <= 60 THEN '[51-60]'
        ELSE '[61+]'
	END AS age_group,
    COUNT(age) AS wizard_count
FROM wizzard_deposits
GROUP BY age_group
ORDER BY age_group;


#10. First Letter
SELECT LEFT(first_name, 1) AS fist_name
FROM wizzard_deposits
WHERE deposit_group = 'Troll Chest'
GROUP BY fist_name
ORDER BY fist_name;


#11. Average Interest 
SELECT
	deposit_group,
    is_deposit_expired,
    AVG(deposit_interest) AS average_interest
FROM wizzard_deposits
WHERE deposit_start_date > '1985/01/01'
GROUP BY is_deposit_expired, deposit_group
ORDER BY deposit_group DESC, is_deposit_expired;


#12. Rich Wizard, Poor Wizard*
SELECT SUM(next) AS sum_difference
FROM (
	SELECT deposit_amount - 
			(SELECT deposit_amount
			FROM wizzard_deposits
            WHERE id = wd.id + 1) AS next
	FROM wizzard_deposits AS wd) AS diff;

USE soft_uni;

#13. Employees Minimum Salaries
SELECT department_id, MIN(salary) AS minumum_salary
FROM employees
WHERE hire_date > '2000-01-01' AND department_id IN (2, 5, 7)
GROUP BY department_id
ORDER BY department_id;


#14. Employees Average Salaries
CREATE TABLE highest_paid_employees 
SELECT * FROM employees
WHERE salary > 30000;

DELETE FROM highest_paid_employees
WHERE manager_id = 42;

UPDATE highest_paid_employees
SET salary = salary + 5000
WHERE department_id = 1;

SELECT department_id, AVG(salary) AS avg_salary
FROM highest_paid_employees
GROUP BY department_id
ORDER BY department_id;


#15. Employees Maximum Salaries
SELECT department_id, MAX(salary) AS max_salary
FROM employees
GROUP BY department_id
HAVING max_salary NOT BETWEEN 30000 AND 70000
ORDER BY department_id;


#16. Employees Count Salaries
SELECT COUNT(salary) AS salaries_without_manager
FROM employees
WHERE manager_id IS NULL;


#17. 3rd Highest Salary*
SET @pk1 = '';
SET @rn1 = 1;

CREATE VIEW highest_salary AS
SELECT  department_id,
        salary,
        row_number
FROM (
  SELECT  department_id,
          salary,
          @rn1 := if(@pk1=department_id, @rn1+1,1) as row_number,
          @pk1 := department_id
               
  FROM (
    SELECT  department_id,
            salary
    FROM    employees
    ORDER BY department_id, salary DESC
  ) A
) B;

SELECT department_id, salary
FROM highest_salary
WHERE row_number = 3;


#17_2. 3rd Highest Salary*
SELECT 
	department_id,
    (SELECT DISTINCT e2.salary
        FROM employees AS e2
        WHERE e2.department_id = e1.department_id
        ORDER BY e2.salary DESC
        LIMIT 2 , 1) AS third_highest_salary
FROM employees AS e1
GROUP BY department_id
HAVING third_highest_salary IS NOT NULL;



#18. Salary Challenge**
SELECT em.first_name, em.last_name, em.department_id
FROM employees AS em
JOIN
	(SELECT e.department_id, AVG(e.salary) AS avg_salary
	FROM employees AS e
	GROUP BY e.department_id) AS avg_salaries
ON em.department_id = avg_salaries.department_id
WHERE em.salary > avg_salaries.avg_salary
ORDER BY em.department_id
LIMIT 10;


#19. Departments Total Salaries
SELECT department_id, SUM(salary) AS total_salay
FROM employees
GROUP BY department_id
ORDER BY department_id;
