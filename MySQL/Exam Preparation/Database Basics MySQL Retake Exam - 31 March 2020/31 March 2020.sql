CREATE DATABASE instd;
USE instd;	

#01. Table Design

CREATE TABLE `users` (
    `id` INT PRIMARY KEY,
    `username` VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(30) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `gender` CHAR(1) NOT NULL CHECK (gender IN ('M' , 'F')),
    `age` INT NOT NULL,
    `job_title` VARCHAR(40) NOT NULL,
    `ip` VARCHAR(30) NOT NULL
);

CREATE TABLE `addresses` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `address` VARCHAR(30) NOT NULL,
    `town` VARCHAR(30) NOT NULL,
    `country` VARCHAR(30) NOT NULL,
    `user_id` INT NOT NULL,
    CONSTRAINT fk_addresses_users FOREIGN KEY (`user_id`)
        REFERENCES users (`id`)
);

CREATE TABLE `photos` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT NOT NULL,
    `date` DATETIME NOT NULL,
    `views` INT NOT NULL DEFAULT 0
);


CREATE TABLE `comments` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `comment` VARCHAR(255) NOT NULL,
    `date` DATETIME NOT NULL,
    `photo_id` INT NOT NULL,
    CONSTRAINT fk_comments_photos FOREIGN KEY (`photo_id`)
        REFERENCES photos (`id`)
);

CREATE TABLE `users_photos` (
    `user_id` INT NOT NULL,
    `photo_id` INT NOT NULL,
    CONSTRAINT fk_users_photos_users FOREIGN KEY (`user_id`)
        REFERENCES users (`id`),
    CONSTRAINT fk_users_photos_photos FOREIGN KEY (`photo_id`)
        REFERENCES photos (`id`)
);

CREATE TABLE `likes` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `photo_id` INT,
    `user_id` INT,
    CONSTRAINT fk_likes_photos FOREIGN KEY (`photo_id`)
        REFERENCES photos (`id`),
    CONSTRAINT fk_likes_users FOREIGN KEY (`user_id`)
        REFERENCES users (`id`)
);

-- ------------------------------------------------------
#02. Insert
INSERT INTO `addresses` (`address`,`town`,`country`,`user_id`)
SELECT  
     u.`username`,
     u.`password`,
     u.`ip`,
     u.`age` 
FROM `users` AS u
WHERE  u.`gender` ='M';



-- ------------------------------------------------
#03. Update

UPDATE `addresses` As a
SET `country` = 
                CASE
                   WHEN `country` LIKE 'B%' THEN 'Blocked'
                   WHEN `country` LIKE  'T%' THEN 'Test'
                   WHEN `country` LIKE  'P%' THEN 'In Progress'
                   ELSE `country`
                END;  


-- ----------------------------------------	
#04. Delete

DELETE FROM `addresses` AS a
WHERE a.`id` % 3 = 0;



-- ------------------------------------
#05. Users
SELECT u.`username`,u.`gender`,u.`age`
FROM `users` AS u
ORDER BY u.`age` DESC, u.`username` ASC;

-- ---------------------------------------
#06. Extract 5 most commented photos

SELECT 
    p.`id`,
    p.`date` AS 'date_and_time',
    p.`description`,
    COUNT(c.`id`) AS 'commentsCount'
FROM
    `photos` AS p
        JOIN
    `comments` AS c ON p.`id` = c.`photo_id`
GROUP BY p.`id`
ORDER BY commentsCount DESC, p.`id`
LIMIT 5;

-- ------------------------------------------
#07. Lucky users

SELECT 
       CONCAT_WS(' ', u.`id`, u.`username`) AS 	'id_username',
       u.`email`
FROM
    `users` AS u
        JOIN
    `users_photos` AS up ON u.`id` = up.`user_id`
        AND u.`id` = up.`photo_id`
ORDER BY u.`id`;


-- ------------------------------------------------
#08. Count likes and comments

SELECT 
    p.`id` AS 'photo_id',
    COUNT(DISTINCT l.`id`) AS 'likes_count',
    COUNT(DISTINCT c.`id`) AS 'comments_count'
FROM
    `photos` AS p
        LEFT JOIN
    `likes` AS l ON p.`id` = l.`photo_id`
        LEFT JOIN
    `comments` AS c ON p.`id` = c.`photo_id`
GROUP BY p.`id`
ORDER BY likes_count DESC , comments_count DESC ,   p.`id`;


-- -----------
#2 вариант
SELECT p.id AS 'photo_id', 
       (SELECT COUNT(*) FROM `likes` AS l 
                      WHERE l.photo_id = p.id) AS 'likes_count',
       (SELECT COUNT(*) FROM `comments`AS c 
                      WHERE c.photo_id = p.id) AS 'comments_count'
FROM photos AS p
ORDER BY likes_count DESC, comments_count DESC, p.id ASC;




-- ---------------------------------------------------
#09. The photo on the tenth day of the month

SELECT 
    CONCAT(LEFT(p.`description`, 30), '...') AS 'summary',
    p.`date`
FROM
    `photos` AS p
WHERE
    DAY(p.`date`) = 10
ORDER BY p.`date` DESC;




-- ------------------------------------------------------
# 4.1 User Defined Function: Get User's Photos Count
#10. Get user’s photos count

DELIMITER $$
CREATE FUNCTION udf_users_photos_count(username VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN 
    DECLARE photosCount INT;
SELECT 
    COUNT(*)
INTO photosCount 
FROM `users` AS u
        JOIN
    `users_photos` AS up ON u.`id` = up.`user_id`
WHERE
    u.`username` = username;
    RETURN photosCount;
END$$



SELECT udf_users_photos_count('ssantryd') AS photosCount;

  




-- -----------------------------------------------------------
#4.2 Stored Procedure: Increase User Age
#11. Increase user age
DELIMETER $$
CREATE PROCEDURE `udp_modify_user` (address VARCHAR(30), town VARCHAR(30)) 
BEGIN 
    IF(( SELECT u.`username` 
 FROM `addresses` AS a
       JOIN 
          `users` AS u ON a.`user_id` = u.`id`
 WHERE `address` =  a.`address`) IS NOT NULL)
	THEN UPDATE `users` AS u
              JOIN 
              `addresses` AS aa ON u.`id` = aa.`user_id`
	SET u.`age` = u.`age` + 10
    WHERE aa.`address` = address AND aa.`town` = town;
    END IF;
END$$

CALL udp_modify_user ('97 Valley Edge Parkway', 'Divinópolis');


#test
SELECT u.username, u.email,u.gender,u.age,u.job_title 
FROM users AS u 
WHERE u.username = 'eblagden21';














