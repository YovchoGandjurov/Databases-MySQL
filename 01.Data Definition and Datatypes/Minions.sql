CREATE database minions;
USE minions;

# 1. Create Tables
CREATE TABLE minions(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    age INT(11)
);

CREATE TABLE towns(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

# 2. Alter Minions Table
ALTER TABLE minions
ADD town_id INT(11);

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns FOREIGN KEY(town_id) REFERENCES towns(id);

# 3. Insert Records in Both Tables
INSERT INTO towns (id, name) VALUES (1, 'Sofia'), (2, 'Plovdiv'), (3, 'Varna');

INSERT INTO minions (id, name, age, town_id)
VALUES
	(1, 'Kevin', 22, 1),
    (2, 'Bob', 15, 3),
    (3, 'Steward', NULL, 2);

# 4. Truncate Table Minions
TRUNCATE TABLE minions;

# 5. Drop All Tables
DROP TABLE minions;
DROP TABLE towns;
