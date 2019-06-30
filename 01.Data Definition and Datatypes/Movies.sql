CREATE DATABASE movies;
USE movies;

CREATE TABLE directors (
	id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(100) NOT NULL,
    notes TEXT
);

CREATE TABLE genres (
	id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(100) NOT NULL,
    notes TEXT
);

CREATE TABLE categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    notes TEXT
);

CREATE TABLE movies (
	id INT PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(50) NOT NULL,
    director_id INT,
    copyright_year YEAR NOT NULL,
    length TIME,
    genre_id INT,
    category_id INT,
    rating DOUBLE(2, 1),
    notes TEXT,
    CONSTRAINT fk_director_movie FOREIGN KEY (director_id) REFERENCES directors (id),
    CONSTRAINT fk_genre_movie FOREIGN KEY (genre_id) REFERENCES genres (id),
    CONSTRAINT fk_category_movie FOREIGN KEY (category_id) REFERENCES categories (id)
);


INSERT INTO directors (id, director_name, notes)
VALUES
	(1, 'Ivan Ivanov', 'Golden boot Winner'),
	(2, 'Stan Petrov', 'Multiple international awards'),
	(3, 'James Cameron', 'FC Liverpool legend'),
	(4, 'Sam Mayor', 'MK3 World Champion'),
	(5, 'Dany De La Hoya', 'Very talented');


INSERT INTO genres (id, genre_name, notes)
VALUES
	(1, 'Comedy', 'Very funny...'),
	(2, 'Action', 'Weapons mepons'),
	(3, 'Horror', 'Not for children'),
	(4, 'SciFi', 'Space and aliens'),
	(5, 'Drama', 'OMG');

INSERT INTO categories
VALUES
	(1, 'category_test_1', 'some note'),
	(2, 'category_test_2', 'some note'),
    (3, 'category_test_3', 'some note'),
    (4, 'category_test_4', 'some note'),
    (5, 'category_test_5', 'some note');

INSERT INTO movies
VALUES
	(1, 'Captain America', 1, 1988, '1:22:00', 1, 5, 9.5, 'Superhero'),
	(2, 'Mean Machine', 1, 1998, '1:40:00', 2, 4, 8.0, 'Prison'),
	(3, 'Little Cow', 2, 2007, '1:35:55', 3, 3, 2.3, 'Agro'),
	(4, 'Smoked Almonds', 5, 2013, '2:22:25', 4, 2, 7.8, 'Whiskey in the Jar'),
	(5, 'I''m very mad!', 4, 2018, '1:30:02', 5, 1, 9.9, 'Rating 10 not supported');

