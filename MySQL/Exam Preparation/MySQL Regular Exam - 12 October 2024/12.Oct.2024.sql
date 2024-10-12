
CREATE DATABASE regular_exam_2024;
USE regular_exam_2024;



CREATE TABLE `countries`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE

);

CREATE TABLE `sports`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE `disciplines`
(
    `id`       INT PRIMARY KEY AUTO_INCREMENT,
    `name`     VARCHAR(40) NOT NULL UNIQUE,
    `sport_id` INT         NOT NULL,
    CONSTRAINT fk_disciplines_sports
        FOREIGN KEY (`sport_id`) REFERENCES sports (`id`)
);

CREATE TABLE `athletes`
(
    `id`         INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name`  VARCHAR(40) NOT NULL,
    `age`        INT,
    `country_id` INT         NOT NULL,
    CONSTRAINT fk_athletes_countries
        FOREIGN KEY (`country_id`) REFERENCES countries (`id`)

);

CREATE TABLE `medals`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `type` VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE `disciplines_athletes_medals`
(
    `discipline_id` INT NOT NULL,
    `athlete_id`    INT NOT NULL,
    `medal_id`      INT NOT NULL,

    PRIMARY KEY pk_disciplines_athletes_medals (discipline_id, athlete_id),

    CONSTRAINT fk_disciplines_athletes_medals_disciplines
        FOREIGN KEY (`discipline_id`) REFERENCES disciplines (`id`),
    CONSTRAINT fk_disciplines_athletes_medals_athletes
        FOREIGN KEY (`athlete_id`) REFERENCES athletes (`id`),
    CONSTRAINT fk_disciplines_athletes_medals_medals
        FOREIGN KEY (`medal_id`) REFERENCES medals (`id`)
);


-- -------------------------------------------------------------------
#2
INSERT INTO athletes (first_name, last_name, age, country_id)
SELECT UPPER(a.`first_name`),
       CONCAT(a.last_name, ' comes from ', c.`name`),
       a.`age` + a.country_id,
       a.country_id

FROM athletes As a
         JOIN countries As c On a.country_id = c.id
WHERE c.name Like 'A%';


#3
UPDATE disciplines
SET name = REPLACE(`name`, 'weight', '')
WHERE name like '%weight%';


#4
DELETE
FROM athletes
WHERE age > 35;




#5
SELECT c.`id`,
       c.`name`
FROM countries As c
         LEFT JOIN athletes a on c.id = a.country_id
WHERE a.`id` IS NULL
ORDER BY c.`name` DESC
LIMIT 15;





#6
SELECT CONCAT(a.`first_name`, ' ', a.`last_name`) AS 'full_name',
     (SELECT MIN(age) FROM athletes) As 'age'
FROM athletes As a
         JOIN `disciplines_athletes_medals` As dam on a.id = dam.athlete_id
ORDER BY a.age ASC , a.id ASC
LIMIT 2;





#7
SELECT a.id,
       a.first_name,
       a.last_name
FROM athletes As a
         LEFT JOIN disciplines_athletes_medals dam on a.id = dam.athlete_id
WHERE dam.medal_id IS NULL
ORDER BY a.`id`;





#8
SELECT a.`id`,
       a.`first_name`,
       a.`last_name`,
       COUNT(dam.medal_id) As 'medals_count ',
       s.`name`            As 'sport'
FROM athletes AS a
         JOIN disciplines_athletes_medals dam on a.id = dam.athlete_id
         JOIN disciplines As d ON dam.discipline_id = d.id
         JOIN sports As s On d.sport_id = s.id
GROUP BY a.`id`, a.`first_name`, a.`last_name`, s.`name`
ORDER BY `medals_count ` DESC, a.`first_name` ASC
LIMIT 10;






#9
SELECT CONCAT(a.`first_name`, ' ', a.`last_name`),
       CASE
           WHEN a.`age` <= 18 THEN 'Teenager'
           WHEN a.`age` > 18 AND a.`age` <= 25 THEN 'Young adult'
           WHEN a.`age` >= 26 THEN 'Adult'
           END As 'age_group'
FROM athletes As a
ORDER BY a.`age` DESC, a.`first_name` ASC;





#10
DELIMITER $$

CREATE FUNCTION `udf_total_medals_count_by_country`(name VARCHAR(40))
 RETURNS INT
 DETERMINISTIC
BEGIN
    DECLARE total_medals INT;
SELECT COUNT(dam.medal_id)
           INTO total_medals
FROM athletes a
         JOIN disciplines_athletes_medals dam ON a.id = dam.athlete_id
         JOIN countries c ON a.country_id = c.id
WHERE c.`name` = name;
RETURN total_medals;
END$$
DELIMITER ;

# Test

SELECT c.name, udf_total_medals_count_by_country ('Bahamas') as count_of_medals
FROM countries c
WHERE c.name = 'Bahamas';







#11
DELIMITER $$

CREATE PROCEDURE `udp_first_name_to_upper_case`(letter CHAR(1))
BEGIN
    UPDATE athletes
    SET first_name = UPPER(first_name)
    WHERE first_name LIKE CONCAT('%', letter);
END$$

DELIMITER ;



#Test
CALL `udp_first_name_to_upper_case` ('s');




