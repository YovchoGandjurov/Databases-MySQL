USE exercises;

# 6. Create Table People
CREATE TABLE people(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB(2048),
    height DOUBLE(3, 2),
    weight DOUBLE(5, 2),
    gender ENUM('m', 'f') NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

INSERT INTO people (id, name, picture, height, weight, gender, birthdate, biography)
VALUES
(1, 'name_test_1', NULL, 1.66, 81.5, 'm', '1995-01-21', 'test_bio'),
(2, 'name_test_2', NULL, 1.76, 82.5, 'm', '1995-01-22', 'test_bio'),
(3, 'name_test_3', NULL, 1.86, 83.5, 'm', '1995-01-23', 'test_bio'),
(4, 'name_test_4', NULL, 1.96, 84.5, 'm', '1995-01-24', 'test_bio'),
(5, 'name_test_5', NULL, 1.56, 85.5, 'm', '1995-01-25', 'test_bio');


# 7. Create Table Users
CREATE TABLE users(
	id INT(19) PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB(900),
    last_login_time DATETIME,
    is_deleted BIT
);

INSERT INTO users (id, username, password, profile_picture, last_login_time, is_deleted)
VALUES
	(1, 'user_1', 'password', NULL, date(now()), 0),
    (2, 'user_2', 'password', NULL, date(now()), 1),
    (3, 'user_3', 'password', NULL, date(now()), 1),
    (4, 'user_4', 'password', NULL, date(now()), 0),
    (5, 'user_5', 'password', NULL, date(now()), 0);


# 8. Change Primary Key
ALTER TABLE users
MODIFY COLUMN id INT(19);

ALTER TABLE users
DROP PRIMARY KEY;

ALTER TABLE users
ADD PRIMARY KEY (id, username);


# 9. Set Default Value of a Field
ALTER TABLE users
MODIFY last_login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


# 10. Set Unique Field
ALTER TABLE users
MODIFY id INT(19) NOT NULL;

ALTER TABLE users
DROP PRIMARY KEY;

ALTER TABLE users
ADD PRIMARY KEY (id);

ALTER TABLE users
ADD UNIQUE(username);
