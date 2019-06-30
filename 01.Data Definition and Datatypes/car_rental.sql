CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(100) NOT NULL,
    daily_rate INT NOT NULL,
    weekly_rate INT NOT NULL,
    monthly_rate INT NOT NULL,
    weekend_rate INT NOT NULL
);

CREATE TABLE cars (
	id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL UNIQUE,
    make VARCHAR(20) NOT NULL,
    model VARCHAR(20) NOT NULL,
    car_year YEAR NOT NULL,
    category_id INT,
    doors INT,
    picture BLOB,
    car_condition TEXT, 
    available BIT NOT NULL,
    CONSTRAINT fk_category_car FOREIGN KEY (category_id) REFERENCES categories (id)
);

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(100),
    notes TEXT
);

CREATE TABLE customers (
	id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(20) NOT NULL,
    zip_code VARCHAR(20),
    notes TEXT
);

CREATE TABLE rental_orders (
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition TEXT,
    tank_level INT NOT NULL,
	kilometrage_start INT NOT NULL,
    kilometrage_end INT NOT NULL,
    total_kilometrage INT AS (kilometrage_end - kilometrage_start),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days INT AS (end_date - start_date),
    rate_applied INT NOT NULL,
    tax_rate DOUBLE AS (rate_applied * 0.2),
    order_status BIT NOT NULL,
    notes TEXT,
    CONSTRAINT fk_employee_rental FOREIGN KEY (employee_id) REFERENCES employees(id),
    CONSTRAINT fk_customer_rental FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_car_rental FOREIGN KEY (car_id) REFERENCES cars (id)
);


INSERT INTO categories VALUES
	(1, 'Limousine', 65, 350, 1350, 120),
	(2, 'SUV', 85, 500, 1800, 160),
	(3, 'Economic', 40, 230, 850, 70);

INSERT INTO cars VALUES
	(1, 'B8877PP', 'Audi', 'A6', 2001, 1, 4, NULL, 'Good', 1),
	(2, 'GH17GH78', 'Opel', 'Corsa', 2014, 3, 5, NULL, 'Very good', 0),
	(3, 'CT17754GT', 'VW', 'Touareg', 2008, 2, 5, NULL, 'Zufrieden', 1);


INSERT INTO employees VALUES
	(1, 'Stancho', 'Mihaylov', NULL, NULL),
	(2, 'Doncho', 'Petkov', NULL, NULL),
	(3, 'Stamat', 'Jelev', 'DevOps', 'Employee of the year');


INSERT INTO customers VALUES
	(1, 'AZ18555PO', 'Michael Smith', 'Medley str. 25', 'Chikago', NULL, NULL),
	(2, 'LJ785554478', 'Sergey Ivankov', 'Shtaigich 37', 'Perm', NULL, NULL),
	(3, 'LK8555478', 'Franc Joshua', 'Dorcel str. 56', 'Paris', NULL, NULL);

INSERT INTO rental_orders(id, employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, start_date, end_date, rate_applied, order_status, notes)
VALUES
	(1, 1, 2, 3, NULL, 45, 18005, 19855, '2007-08-08', '2007-08-10', 250, 1, NULL),
	(2, 3, 2, 1, NULL, 50, 55524, 56984, '2009-09-06', '2009-09-28', 1500, 0, NULL),
	(3, 2, 2, 1, NULL, 18, 36005, 38547, '2017-05-08', '2017-06-09', 850, 0, NULL);



