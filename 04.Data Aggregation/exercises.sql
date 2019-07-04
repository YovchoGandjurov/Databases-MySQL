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

















































