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


#8.	Find Full Name
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM account_holders
    ORDER BY full_name, id;
END $$

CALL usp_get_holders_full_name();


#9.	People with Balance Higher Than
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(num DOUBLE)
BEGIN
	SELECT ah.first_name, ah.last_name
	FROM account_holders ah
	JOIN (
		SELECT id, account_holder_id, SUM(balance) AS balance
		FROM accounts
		GROUP BY account_holder_id
		) a
	ON ah.id = a.account_holder_id
	WHERE balance > num
	ORDER BY a.id, ah.first_name, ah.last_name;
END $$

CALL usp_get_holders_with_balance_higher_than(7000);


#10. Future Value Function
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(sum DOUBLE, int_rate DOUBLE, years INT)
RETURNS DOUBLE
BEGIN
	DECLARE result DOUBLE;
    SET result := sum * POW(1 + int_rate, years);
    RETURN result;
END; $$

SELECT ufn_calculate_future_value(1000, 0.1, 5);


#11. Calculating Interest
DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(acc_id INT, interest_rate DOUBLE(10,4))
BEGIN
	SELECT
		a.id AS account_id,
		ah.first_name,
        ah.last_name,
        a.balance AS current_balance,
        ROUND(ufn_calculate_future_value(a.balance, interest_rate, 5), 4) AS balance_in_5_years
	FROM account_holders ah
    JOIN accounts a
    ON ah.id = a.account_holder_id
    WHERE a.id = acc_id;
END $$

CALL usp_calculate_future_value_for_account(1, 0.1);


#12. Deposit Money

DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DOUBLE(12, 4))
BEGIN
	START TRANSACTION;
	IF money_amount <= 0 THEN
	ROLLBACK;
    ELSE
		UPDATE accounts
        SET balance = balance + money_amount
        WHERE id = account_id;
	END IF;
END $$

CALL usp_deposit_money(1, 10);


#13. Withdraw Money
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DOUBLE(16,4))
BEGIN
	START TRANSACTION;
		# SELECT balance
        IF((SELECT balance FROM accounts WHERE id = account_id) < money_amount
			OR money_amount <= 0) THEN
		ROLLBACK;
        ELSE
			UPDATE accounts
            SET balance = balance - money_amount
            WHERE id = account_id;
		END IF;
END $$

CALL usp_withdraw_money(1, 10);
SELECT balance FROM accounts WHERE id = 1;



# 14. Money Transfer
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DOUBLE(16,4))
BEGIN
	START TRANSACTION;
    IF (from_account_id NOT IN (SELECT id FROM accounts) AND to_account_id NOT IN (SELECT id FROM accounts)) OR
		amount < 0 OR
		(SELECT balance FROM accounts WHERE id = from_account_id) < amount OR
        from_account_id = to_account_id THEN
        ROLLBACK;
	ELSE
		UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
        
        UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
	END IF;
END $$



#15. Log Accounts Trigger

DELIMITER $$
CREATE TABLE logs (
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    old_sum DECIMAL(19, 4),
    new_sum DECIMAL(19, 4)
);

CREATE TRIGGER tr_updated_balance
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO logs (account_id, old_sum, new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);
END; $$



# 16. Emails Trigger

CREATE TABLE notification_emails (
	id INT PRIMARY KEY AUTO_INCREMENT,
    recipient INT,
    subject VARCHAR(50),
    body VARCHAR(255)
);

DELIMITER $$
CREATE TRIGGER `tr_notification_emails`
AFTER INSERT ON `logs`
FOR EACH ROW
BEGIN
	INSERT INTO `notification_emails` (`recipient`, `subject`, `body`)
    VALUES (
		NEW.account_id,
        CONCAT('Balance change for account: ', NEW.account_id),
        CONCAT('On ', DATE_FORMAT(NOW(), '%b %e %Y at %r'), ' your balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum, '.'));
END; $$
