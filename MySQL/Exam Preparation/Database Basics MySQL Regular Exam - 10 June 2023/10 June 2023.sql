CREATE DATABASE universities_db;
USE universities_db;

#01. Table Design
CREATE TABLE `countries` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `cities` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `population` INT,
    `country_id` INT NOT NULL,
    FOREIGN KEY (`country_id`)
        REFERENCES countries (`id`)
);


CREATE TABLE `universities` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(60) NOT NULL UNIQUE,
    `address` VARCHAR(80) NOT NULL UNIQUE,
    `tuition_fee` DECIMAL(19 , 2 ) NOT NULL,
    `number_of_staff` INT,
    `city_id` INT,
    FOREIGN KEY (`city_id`)
        REFERENCES cities (`id`)
);

CREATE TABLE `students` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `age` INT,
    `phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `is_graduated` BOOLEAN NOT NULL,
    `city_id` INT,
    FOREIGN KEY (`city_id`)
        REFERENCES cities (`id`)
);

CREATE TABLE `courses` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `duration_hours` DECIMAL(19 , 2 ),
    `start_date` DATE,
    `teacher_name` VARCHAR(60) NOT NULL UNIQUE,
    `description` TEXT,
    `university_id` INT,
    FOREIGN KEY (`university_id`)
        REFERENCES universities (`id`)
);

CREATE TABLE `students_courses` (
    `grade` DECIMAL(19 , 2 ) NOT NULL,
    `student_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    FOREIGN KEY (`student_id`)
        REFERENCES students (`id`),
    FOREIGN KEY (`course_id`)
        REFERENCES courses (`id`)
);





#02. Insert

INSERT INTO `courses` (`name`,`duration_hours`,`start_date`,`teacher_name`,`description`,`university_id`)
SELECT 
      CONCAT(`teacher_name`, ' course'),
      CHAR_LENGTH(`name`) / 10,
      DATE_ADD(`start_date`,INTERVAL 5 DAY),
      REVERSE(`teacher_name`),
      CONCAT('Course ',`teacher_name`,REVERSE(`description`)),
      DAY(`start_date`)
     FROM `courses` 
WHERE  `id` <= 5; 



#03. Update
UPDATE  `universities`
SET  `tuition_fee` = `tuition_fee` + 300
WHERE `id` BETWEEN 5 AND 12;




#04. Delete
DELETE FROM `universities`
WHERE number_of_staff IS NULL;




#05. Cities
SELECT 
    *
FROM
    `cities`
ORDER BY `population` DESC;


#06. Students age

SELECT `first_name`,`last_name`,`age`,`phone`,`email`
FROM `students` 
WHERE `age` >= 21
ORDER BY `first_name` DESC,`email` ASC,`id`ASC
LIMIT 10;



#07. New students
SELECT 
    CONCAT(s.`first_name`,' ', s.`last_name`) AS 'full_name',
    SUBSTRING(s.`email`, 2, 10) AS 'user_name',
    REVERSE(s.`phone`) AS 'password'
FROM
    `students` AS s
        LEFT JOIN
    `students_courses` AS st ON s.`id` = st.`student_id`
WHERE
    st.`course_id` IS NULL
ORDER BY `password` DESC;



#08. Students count
SELECT 
    COUNT(*) AS `students_count`,
    u.`name` AS `university_name`
FROM
    `universities` AS u
        JOIN
    `courses` AS c ON u.`id` = c.`university_id`
        JOIN
    `students_courses` AS sc ON c.`id` = sc.`course_id`
GROUP BY `university_name`
HAVING `students_count` >=8
ORDER BY `students_count` DESC,`university_name` DESC;



#09. Price rankings

 SELECT 
    u.`name` AS 'university_name',
    c.`name` AS 'city_name',
    u.`address`,
    CASE
        WHEN u.`tuition_fee` < 800 THEN 'cheap'
        WHEN u.`tuition_fee` < 1200 THEN 'normal'
        WHEN u.`tuition_fee` < 2500 THEN 'high'
        ELSE 'expensive'
    END AS 'price_rank',
    u.`tuition_fee`
FROM
    `universities` AS u
        JOIN
    `cities` AS c ON u.`city_id` = c.`id`
ORDER BY `tuition_fee`ASC;




#10. Average grades

DELIMITER $$
CREATE FUNCTION `udf_average_alumni_grade_by_course_name` (course_name VARCHAR(60))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
   DECLARE result DECIMAL (10,2);
   SET result :=(SELECT AVG(sc.`grade`) FROM `courses` c
          JOIN `students_courses` as sc ON c.`id` = sc.`course_id`
          JOIN `students` as s ON sc.`student_id` = s.`id`
          WHERE c.`name` = course_name AND s.`is_graduated` = TRUE
          GROUP BY c.`id`);
   RETURN result;
END$$

SELECT c.name, udf_average_alumni_grade_by_course_name('Quantum Physics') asaverage_alumni_grade FROM courses c
WHERE c.name = 'Quantum Physics';







#11. Graduate students
DELIMITER $$
CREATE PROCEDURE `udp_graduate_all_students_by_year`(year_started INT)
BEGIN 
     UPDATE `students` as s
     JOIN `students_courses` as sc ON s.`id` = sc.`student_id`
     JOIN `courses` as c ON sc.`course_id` = c.`id`
	 SET s.`is_graduated` = 1
     WHERE YEAR(c.`start_date`) = year_started;
END$$

CALL udp_graduate_all_students_by_year(2017);



