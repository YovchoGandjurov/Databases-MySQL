CREATE DATABASE hotel;
USE hotel;

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    title VARCHAR(100),
    notes TEXT
);

CREATE TABLE customers (
	account_number INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone_number VARCHAR(30) NOT NULL UNIQUE,
    emergency_name VARCHAR(50) NOT NULL,
    emergency_number VARCHAR(30) NOT NULL,
    notes TEXT
);

CREATE TABLE room_status (
	room_status VARCHAR(50) PRIMARY KEY,
    notes TEXT
);

CREATE TABLE room_types (
	room_type VARCHAR(30) PRIMARY KEY,
    notes TEXT
);

CREATE TABLE bed_types (
	bed_type VARCHAR(30) PRIMARY KEY,
    notes TEXT
);

CREATE TABLE rooms (
	room_number INT PRIMARY KEY,
    room_type VARCHAR(30),
    bed_type VARCHAR(30),
    rate DOUBLE(6, 2),
    room_status VARCHAR(50),
    notes TEXT,
    FOREIGN KEY (room_type) REFERENCES room_types(room_type),
    FOREIGN KEY (bed_type) REFERENCES bed_types(bed_type),
    FOREIGN KEY (room_status) REFERENCES room_status(room_status)
);


CREATE TABLE payments (
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    payment_date DATETIME NOT NULL,
    account_number INT NOT NULL,
    first_date_occupied DATETIME NOT NULL,
    last_date_occupied DATETIME	NOT NULL,
    total_days INT AS (last_date_occupied - first_date_occupied),
    amount_charged DOUBLE(7, 2),
    tax_rate DOUBLE(6, 2),
    tax_amount DOUBLE AS (amount_charged * tax_rate),
    payment_total DOUBLE AS (amount_charged + amount_charged * tax_rate),
    notes TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (account_number) REFERENCES customers(account_number)
);

CREATE TABLE occupancies (
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    date_occupied DATE NOT NULL,
    account_number INT NOT NULL,
    room_number INT NOT NULL,
    rate_applied DOUBLE(7, 2) NOT NULL,
    phone_charge DOUBLE(10, 2) NOT NULL,
    notes TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees (id),
    FOREIGN KEY (account_number) REFERENCES customers (account_number),
    FOREIGN KEY (room_number) REFERENCES rooms (room_number)
);


INSERT INTO employees (id, first_name, last_name)
VALUES
	(1, 'Galin', 'Zhelev'),
	(2, 'Stoyan', 'Ivanov'),
	(3, 'Petar', 'Ikonomov');


INSERT INTO customers 
VALUES
	(201, 'Monio', 'Ushev', '+359888666555', 'monio', '555', NULL),
	(202, 'Gancho', 'Stoykov', '+359866444222', 'gancho', '666', NULL),
	(203, 'Genadi', 'Dimchov', '+35977555333', 'genadi', '777', NULL);

INSERT INTO room_status (room_status)
VALUES
	('occupied'),
	('non occupied'),
	('repairs');


INSERT INTO room_types (room_type)
VALUES
	('single'),
	('double'),
	('appartment');


INSERT INTO bed_types(bed_type)
VALUES
	('single'),
	('double'),
	('couch');

INSERT INTO rooms
VALUES
	(201, 'single', 'single', 40.0, 'occupied', NULL),
	(205, 'double', 'double', 70.0, 'occupied', NULL),
	(208, 'appartment', 'couch', 110.0, 'repairs', NULL);

INSERT INTO payments (id, employee_id, payment_date, account_number, first_date_occupied, last_date_occupied, amount_charged, tax_rate)
VALUES
	(1, 1, '2011-11-25', 201, '2017-11-30', '2017-12-04', 250.0, 0.2),
	(2, 3, '2014-06-03', 202, '2014-06-06', '2014-06-09', 340.0, 0.2),
	(3, 3, '2016-02-25', 203, '2016-02-27', '2016-03-04', 500.0, 0.2);

INSERT INTO occupancies
VALUES
	(1, 2, '2011-02-04', 202, 205, 70.0, 12.54, NULL),
	(2, 2, '2015-04-09', 202, 201, 40.0, 11.22, NULL),
	(3, 3, '2012-06-08', 203, 208, 110.0, 10.05, NULL);






















