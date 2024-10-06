CREATE DATABASE go_roadie;
USE go_roadie;

-- ---------------------------------------------------------
#1 01. Table Design
CREATE TABLE `cities`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `cars`
(
    `id`    INT PRIMARY KEY AUTO_INCREMENT,
    `brand` VARCHAR(20) NOT NULL,
    `model` VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE `instructors`
(
    `id`                 INT PRIMARY KEY AUTO_INCREMENT,
    `first_name`         VARCHAR(40) NOT NULL,
    `last_name`          VARCHAR(40) NOT NULL UNIQUE,
    `has_a_license_from` DATE        NOT NULL
);

CREATE TABLE `driving_schools`
(
    `id`                   INT PRIMARY KEY AUTO_INCREMENT,
    `name`                 VARCHAR(40) NOT NULL UNIQUE,
    `night_time_driving`   TINYINT(1)  NOT NULL,
    `average_lesson_price` DECIMAL(10, 2),
    `car_id`               INT         NOT NULL,
    `city_id`              INT         NOT NULL,
    CONSTRAINT fk_driving_schools_cars
        FOREIGN KEY (`car_id`) REFERENCES cars (`id`),
    CONSTRAINT fk_driving_schools_cities
        FOREIGN KEY (`city_id`) REFERENCES cities (`id`)

);


CREATE TABLE `students`
(
    `id`           INT PRIMARY KEY AUTO_INCREMENT,
    `first_name`   VARCHAR(40) NOT NULL,
    `last_name`    VARCHAR(40) NOT NULL UNIQUE,
    `age`          INT,
    `phone_number` VARCHAR(20) UNIQUE

);

CREATE TABLE `instructors_driving_schools`
(
    `instructor_id`     INT,
    `driving_school_id` INT NOT NULL,

    KEY (instructor_id, driving_school_id),
    CONSTRAINT fk_instructors_driving_schools_instructors
        FOREIGN KEY (`instructor_id`) REFERENCES instructors (`id`),
    CONSTRAINT fk_instructors_driving_schools_driving_schools
        FOREIGN KEY (`driving_school_id`) REFERENCES driving_schools (`id`)
);

CREATE TABLE `instructors_students`
(
    `instructor_id` INT NOT NULL,
    `student_id`    INT NOT NULL,

    KEY (instructor_id, student_id),
    CONSTRAINT fk_instructors_students_instructors
        FOREIGN KEY (`instructor_id`) REFERENCES instructors (`id`),
    CONSTRAINT fk_instructors_students_students
        FOREIGN KEY (`student_id`) REFERENCES students (`id`)
);





-- ----------------------------------------------------------------------
#02. Insert

INSERT INTO students (first_name, last_name, age, phone_number)
SELECT LOWER(REVERSE(first_name)),
       LOWER(REVERSE(last_name)),
       age + LEFT(phone_number, 1),
       CONCAT('1+', phone_number)
FROM students
WHERE age < 20;

-- --------------------------------------------------------------------
#03. Update

UPDATE driving_schools
    JOIN cities c on driving_schools.city_id = c.id
SET average_lesson_price= average_lesson_price + 30
WHERE night_time_driving = 1
  AND c.name = 'London';


-- --------------------------------------------------------------------
#04. Delete

DELETE
FROM driving_schools
WHERE night_time_driving = 0;



-- ----------------------------------------------------------------
#05. Youngest students

SELECT CONCAT(first_name, ' ', last_name) AS 'full_name',
       age
FROM students
WHERE first_name LIKE '%a%'
  AND age = (SELECT MIN(age) from students)
ORDER BY id;





-- ---------------------------------------------------------------
#06. Driving schools without instructors

SELECT dc.`id`,
       dc.`name`,
       c.`brand`
FROM driving_schools AS dc
         JOIN cars AS c on dc.car_id = c.id
         LEFT JOIN instructors_driving_schools AS ids on dc.id = ids.driving_school_id
WHERE ids.instructor_id IS NULL
ORDER BY c.brand, dc.id
LIMIT 5;





-- -----------------------------------------------------------------------------------
#07. Instructors with more than one student

SELECT i.first_name,
       i.last_name,
       COUNT(*)                         AS 'students_count',
       (SELECT c.name
        FROM cities AS c
                 JOIN driving_schools dc on c.id = dc.city_id
                 JOIN instructors_driving_schools ids on dc.id = ids.driving_school_id
        WHERE i.id = ids.instructor_id) As 'name'

FROM instructors AS i
         JOIN instructors_students AS `is` on i.id = `is`.instructor_id
         JOIN instructors_driving_schools AS sd on i.id = sd.instructor_id
GROUP BY i.first_name, i.last_name
HAVING students_count > 1
ORDER BY students_count DESC, i.first_name;




# Вариант №2 ----------------------------------------
SELECT i.first_name,
       i.last_name,
       COUNT(*) AS students_count,
       ci.name  AS city
FROM instructors i
         JOIN instructors_students `is` ON i.id = `is`.instructor_id
         JOIN driving_schools ds ON ds.id =
                                    (SELECT driving_school_id
                                     FROM instructors_driving_schools AS ids
                                     WHERE ids.instructor_id = i.id
                                     LIMIT 1)
         JOIN cities AS ci ON ds.city_id = ci.id
GROUP BY i.id, i.first_name, i.last_name, ci.name
HAVING students_count > 1
ORDER BY students_count DESC, i.first_name ASC;








-- ------------------------------------------------------------
#08. Instructor's count by city


SELECT c.name,
       COUNT(i.id) AS 'instructors_count'
FROM instructors AS i
         JOIN instructors_driving_schools AS ids on i.id = ids.instructor_id
         JOIN driving_schools ds on ids.driving_school_id = ds.id
         JOIN cities c on ds.city_id = c.id
GROUP BY c.name
HAVING instructors_count > 0
ORDER BY instructors_count DESC;








-- --------------------------------------------------------------------
#09. Instructor's experience level ?????????


SELECT CONCAT_WS(' ', i.first_name, i.last_name) AS `full_name`,
       CASE
           WHEN YEAR(i.has_a_license_from) < 1990 THEN 'Specialist'
           WHEN YEAR(i.has_a_license_from) < 2000 THEN 'Advanced'
           WHEN YEAR(i.has_a_license_from) < 2008 THEN 'Experienced'
           WHEN YEAR(i.has_a_license_from) < 2015 THEN 'Qualified'
           WHEN YEAR(i.has_a_license_from) < 2020 THEN 'Provisional'
           WHEN YEAR(i.has_a_license_from) >= 2020 THEN 'Trainee'
           END                                   AS `level`
FROM instructors AS i
ORDER BY YEAR(i.has_a_license_from), i.first_name;







-- ----------------------------------------------------------------------------
#10. Extract the average lesson price by city

DELIMITER $$

CREATE FUNCTION `udf_average_lesson_price_by_city`(name VARCHAR(40))
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
BEGIN
    RETURN (SELECT AVG(average_lesson_price)
            FROM driving_schools As ds
                     JOIN cities c on ds.city_id = c.id
            WHERE c.name = `name`);
END$$
DELIMITER ;

#TEST
SELECT c.name, udf_average_lesson_price_by_city('London') as average_lesson_price
FROM cities c
WHERE c.name = 'London'







-- -------------------------------------------------------------------------
#11. Find a driving school by the desired car brand


CREATE PROCEDURE `udp_find_school_by_car`(brand VARCHAR(20))
BEGIN
    SELECT ds.name,
           ds.average_lesson_price
    FROM driving_schools AS ds
             JOIN cars AS c ON ds.car_id = c.id
    WHERE c.brand = `brand`
    ORDER BY ds.average_lesson_price DESC;
END;

# TEST
CALL udp_find_school_by_car ('Mercedes-Benz');












