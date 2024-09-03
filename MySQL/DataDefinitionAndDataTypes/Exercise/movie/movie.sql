USE movie;

CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(200) NOT NULL,
    notes TEXT
);

INSERT INTO directors (`director_name`, `notes`)
VALUES
('Ivan', 'I\'m film director.'),
       ('John', 'I\'m film director.'),
       ('Lily', 'I\'m film director.'),
       ('Sarah', 'I\'m film director.'),
       ('James', 'I\'m film director.');
       
  CREATE TABLE genres (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `genre_name` VARCHAR(200) NOT NULL,
    `notes` TEXT
);  

INSERT INTO genres (genre_name, notes) 
VALUES ('Action', 'This is just a movie genre.'),
       ('Drama', 'This is just a movie genre.'),
       ('Western', 'This is just a movie genre.'),
       ('Horror', 'This is just a movie genre.'),
       ('Comedy', 'This is just a movie genre.');
       
CREATE TABLE categories (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(200) NOT NULL,
    `notes` TEXT
);

INSERT INTO categories (category_name,notes)
VALUES ('Kids', 'Film category.'),
       ('Adults', 'Film category.'),
       ('Teen', 'Film category.'),
       ('Series', 'Film category.'),
       ('Long movies', 'Film category.');
       
CREATE TABLE movies (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(200) NOT NULL,
    `director_id` INT NOT NULL,
    `copyright_year` VARCHAR(4) NOT NULL,
    `length` DOUBLE,
    `genre_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    `rating` INT,
    `notes` TEXT
);

INSERT INTO movies (title,director_id, copyright_year, length, genre_id, category_id, rating,notes)
VALUES
        ('Spiderman', 1, '2022', 2.15, 1, 1, 2, 'A great movie.'),
       ('Eternals', 2, '2021', 2.10, 2, 2, 3, 'A great movie.'),
       ('Bench', 3, '2022', 2.42, 3, 3, 8, 'A great movie.'),
       ('Batman ', 4, '2022', 1.57, 4, 4, 8, 'A great movie.'),
       ('The Lord of the Rings 1', 5, '2001', 3.36, 5, 5, 10, 'A great movie.');
