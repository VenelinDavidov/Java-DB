CREATE DATABASE `softuni_imdb2`;
USE `softuni_imdb2`;

#1 TABLE DESING

CREATE TABLE `countries` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE,
    `continent` VARCHAR(30) NOT NULL,
    `currency` VARCHAR(5) NOT NULL
);

CREATE TABLE `genres` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE `actors` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `birthdate` DATE NOT NULL,
    `height` INT,
    `awards` INT,
    `country_id` INT NOT NULL,
    CONSTRAINT `fk_actors_countries` FOREIGN KEY (`country_id`)
        REFERENCES `countries` (`id`)
);

CREATE TABLE `movies_additional_info` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `rating` DECIMAL(10 , 2 ) NOT NULL,
    `runtime` INT NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
    `budget` DECIMAL(10 , 2 ),
    `release_date` DATE NOT NULL,
    `has_subtitles` TINYINT(1),
    `description` TEXT
);

CREATE TABLE `movies` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(70) NOT NULL UNIQUE,
    `country_id` INT NOT NULL,
    `movie_info_id` INT NOT NULL UNIQUE,
    CONSTRAINT `fk_movies_countries` FOREIGN KEY (`country_id`)
        REFERENCES `countries` (`id`),
    CONSTRAINT `fk_moves_move_info` FOREIGN KEY (`movie_info_id`)
        REFERENCES `movies_additional_info` (`id`)
);


CREATE TABLE `movies_actors` (
    `movie_id` INT,
    `actor_id` INT,
    KEY pk_movies_actors (`movie_id` , `actor_id`),
    CONSTRAINT `fk_movies_actors_moves` FOREIGN KEY (`movie_id`)
        REFERENCES `movies` (`id`),
    CONSTRAINT `fk_movies_actors_actors` FOREIGN KEY (`actor_id`)
        REFERENCES `actors` (`id`)
);

CREATE TABLE `genres_movies` (
    `genre_id` INT,
    `movie_id` INT,
    KEY pk_genres_movies (`genre_id` , `movie_id`),
    CONSTRAINT `fk_genres_movies_genres` FOREIGN KEY (`genre_id`)
        REFERENCES `genres` (`id`),
    CONSTRAINT `fk_genres_movies_movies` FOREIGN KEY (`movie_id`)
        REFERENCES `movies` (`id`)
);



# 02. Insert

INSERT INTO `actors` (`first_name`,`last_name`,`birthdate`,`height`,`awards`,`country_id`)
SELECT
       (reverse(`first_name`)),
       (reverse(`last_name`)),
       (date(`birthdate` - 2)),
       (`height` + 10),
       (`country_id`),
       (3) 
FROM `actors`
WHERE `id` <= 10; 



#03. Update

UPDATE `movies_additional_info` 
SET 
    `runtime` = `runtime` - 10
WHERE
    `id` BETWEEN 15 AND 25;
       


#04. Delete
DELETE c FROM `countries` AS c
        LEFT JOIN `movies` AS m ON c.`id` = m.`country_id` 
WHERE m.`country_id` IS NULL;


#B)
DELETE FROM `countries` 
WHERE
    `id` NOT IN (SELECT 
        `country_id`
    FROM
        `movies`);





#05. Countries
SELECT 
    *
FROM
    `countries` AS c
ORDER BY `currency` DESC , `id`;





#06. Old movies

SELECT 
    m.`id`,
    m.`title`,
    mi.`runtime`,
    mi.`budget`,
    mi.`release_date`
FROM
    `movies` AS m
        INNER JOIN
    `movies_additional_info` AS mi ON m.`movie_info_id` = mi.`id`
WHERE
    YEAR(mi.`release_date`) BETWEEN 1996 AND 1999
ORDER BY mi.`runtime` , m.`id`
LIMIT 20;





#07. Movie casting
SELECT 
    CONCAT_WS(' ', `first_name`, `last_name`) AS 'full_name',
    CONCAT(REVERSE(`last_name`),
    LENGTH(`last_name`),
    '@cast.com') AS 'email',
    2022 - YEAR(`birthdate`) AS 'age',
    `height`
FROM
    `actors`
WHERE
    `id` NOT IN (SELECT `actor_id` FROM `movies_actors`)
ORDER BY `height`;






#08. International festival
SELECT 
    c.`name`, 
    COUNT(m.`id`) AS 'movies_count'
FROM
    `countries` AS c
        JOIN
    `movies` AS m ON c.`id` = m.`country_id`
GROUP BY c.`name`
HAVING `movies_count` >= 7
ORDER BY c.`name` DESC;






#09. Rating system
SELECT 
    m.`title`,
    (CASE
        WHEN mi.`rating` <= 4 THEN 'poor'
        WHEN mi.`rating` <= 7 THEN 'good'
        WHEN mi.`rating` > 7 THEN 'excellent'
    END) AS 'rating',
    IF(mi.`has_subtitles` = 1,
        'english',
        '-') AS 'subtitle',
    mi.`budget`
FROM `movies` AS m
        JOIN
    `movies_additional_info` AS mi ON m.`movie_info_id` = mi.`id`
ORDER BY `budget` DESC;






#10. History movies
delimiter $$
create function `udf_actor_history_movies_count`(full_name varchar (50))
returns int 
deterministic
begin
     declare history_movies_count int; # съхранява броя на ист.филми за даден актьор
     set history_movies_count := (
       select count(g.`name`) as 'history movies'
          from `actors` as a
          join `movies_actors` as ma on a.`id` = ma.`actor_id`
          join `genres_movies` as gm using (`movie_id`)  # -> когато в двете таблици имаме еднакви колони се ползва using
          join `genres` as g on gm.`genre_id` = g.`id`
          where g.`name` = 'History' and full_name = concat_ws(' ', a.`first_name`,a.`last_name`)
          group by g.`name`
     );
      return history_movies_count;
end$$

delimiter ;








#11. Movie awards
DELIMITER $$

CREATE PROCEDURE `udp_award_movie`(`movie_title` VARCHAR(50))
BEGIN
    UPDATE `actors` as a
        JOIN `movies_actors` as ma on a.`id` = ma.`actor_id`
        JOIN `movies` as m on  ma.`movie_id` = m.`id`
    SET  a.`awards` = a.`awards` + 1
    WHERE m.`title` = movie_title;
END $$
DELIMITER ;

CALL udp_award_movie('Tea For Two');
CALL udp_award_movie('Miss You Can Do It');















