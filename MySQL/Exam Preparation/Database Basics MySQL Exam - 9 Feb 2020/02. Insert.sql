#2
INSERT INTO coaches(`first_name`,`last_name`,`salary`,`coach_level`)(
SELECT 
	p.`first_name`,
    p.`last_name`,
    (p.`salary` * 2)  AS `salary`,
    CHAR_LENGTH(p.`first_name`) as 'coach_level'
FROM `players` AS p
WHERE  p.`age` >= 45
); 

#3
UPDATE `coaches` AS c
SET  c.coach_level = coach_level + 1
WHERE c.`id` IN (SELECT `coach_id` FROM `players_coaches`)
             AND `first_name` LIKE 'A%';
#3
UPDATE `coaches` as c
JOIN `players_coaches` AS pc on c.`id` = pc.`coach_id`
SET c.`coach_level` = `coach_level` + 1
WHERE `first_name` LIKE 'A%';

#4
DELETE FROM players
  WHERE 
     age >= 45;




#05. Players

SELECT `first_name`,
       `age`,
	   `salary`
FROM `players`  
ORDER BY `salary`DESC;     



#06. Young offense players without contract
SELECT 
    p.`id`,
    CONCAT_WS(' ', p.`first_name`, p.`last_name`) AS 'full_name',
    p.`age`,
    p.`position`,
    p.`hire_date`
FROM
    `players` AS p
        JOIN
    `skills_data` AS sd ON p.`skills_data_id` = sd.`id`
WHERE
    p.`age` < 23 
    AND sd.`strength`> 50 
    AND p.`hire_date` IS NULL 
    AND p.`position` = 'A'
ORDER BY p.`salary` , p.`age`;    
      


#07. Detail info for all teams
SELECT 
    t.`name` AS 'team_name',
    t.`established`, 
    t.`fan_base`,
    COUNT(p.`id`) AS 'players_cout'
FROM
    `teams` AS t
        LEFT JOIN
    `players` AS p ON t.`id` = p.`team_id`
GROUP BY t.`id`
ORDER BY `players_cout` DESC , t.`fan_base` DESC;


#08. The fastest player by towns
SELECT
 MAX(sd.`speed`) AS 'max_speed',
     tw.`name`
FROM  `skills_data` AS sd 
RIGHT JOIN `players` as  p ON sd.`id` =  p.`skills_data_id`
RIGHT JOIN `teams` as t ON p.`team_id` = t.`id`
INNER JOIN `stadiums` as s ON t.`stadium_id` = s.`id`
RIGHT JOIN `towns` as tw ON  s.`town_id`= tw.`id`
WHERE t.name != 'Devify'
GROUP BY tw.`id`
ORDER BY `max_speed` DESC, tw.`name`;


#09. Total salaries and players by country

SELECT 
    c.`name`,
    COUNT(p.`id`) AS 'total_count_of_players',
    SUM(p.`salary`) AS 'total_sum_of_salaries'
FROM
    `countries` AS c
        LEFT JOIN
    `towns` AS tw ON c.`id` = tw.`country_id`
        LEFT JOIN
    `stadiums` AS s ON tw.`id` = s.`town_id`
        LEFT JOIN
    `teams` AS t ON s.`id` = t.`stadium_id`
        LEFT JOIN
    `players` AS p ON t.`id` = p.`team_id`
 GROUP BY c.`id`
 ORDER BY `total_count_of_players` DESC,c.`name`; 


#10. Find all players that play on stadium
DELIMITER $$
CREATE FUNCTION `udf_stadium_players_count` (`stadium_name` VARCHAR (30))
RETURNS int
DETERMINISTIC
BEGIN	
  RETURN( SELECT 
    count(p.`id`)
FROM
    `players` AS p
        RIGHT JOIN
    `teams` AS t ON p.`team_id` = t.`id`
        RIGHT JOIN
    `stadiums` AS s ON t.`stadium_id` = s.`id`
WHERE s.`name` = stadium_name
GROUP BY s.`id`);
END$$
DELIMITER ;

SELECT udf_stadium_players_count ('Linklinks') as `count`;




#11. Find good playmaker by teams
DELIMITER $$

CREATE PROCEDURE `udp_find_playmaker` (`min_dribble_points` INT, `team_name` VARCHAR (45))
BEGIN 
SELECT 
    CONCAT_WS(' ', p.`first_name`, p.`last_name`) AS 'full_name',
    p.`age`,
    p.`salary`,
    sd.`dribbling`,
    sd.`speed`,
    t.`name` AS 'team_name'
FROM
    `players` AS p
        JOIN
    `skills_data` AS sd ON p.`skills_data_id` = sd.`id`
        JOIN
    `teams` AS t ON p.`team_id` = t.`id`
WHERE
    sd.`dribbling` > min_dribble_points AND t.`name` = team_name
        AND sd.`speed` > (SELECT 
            AVG(`speed`)
        FROM
            `skills_data`)
ORDER BY sd.`speed` DESC
LIMIT 1;
END$$
DELIMITER ;











