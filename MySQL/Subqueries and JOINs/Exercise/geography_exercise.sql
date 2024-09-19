use `geography`;

#12. Highest Peaks in Bulgaria

SELECT mc.`country_code`,
 m.`mountain_range`, 
 p.`peak_name`, 
 p.`elevation`
FROM `peaks` AS p
    JOIN `mountains` AS m ON p.`mountain_id` = m.`id`
    JOIN `mountains_countries` AS mc ON m.`id` = mc.`mountain_id`
    WHERE mc.`country_code` = 'BG'  AND p.`elevation` > 2835
    ORDER BY p.`elevation` DESC;





#13. Count Mountain Ranges

SELECT 
         mc.`country_code`,
         COUNT(m.`mountain_range`) AS 'mountain_range_count'
FROM `mountains` AS m
        JOIN `mountains_countries` AS mc ON m.`id` = mc.`mountain_id`
WHERE mc.`country_code` IN ('BG', 'RU', 'US')
GROUP BY mc.`country_code`
ORDER BY `mountain_range_count`DESC;





#14. Countries with Rivers

SELECT 
   c.`country_name`,
   r.`river_name`
FROM `countries` AS c
        LEFT JOIN `countries_rivers` AS cr ON c.`country_code` = cr.`country_code`
        LEFT JOIN `rivers` AS r ON cr.`river_id` = r.`id`
        WHERE c.`continent_code` = 'AF'
        ORDER BY c.`country_name` 
        LIMIT 5;
        



#15. *Continents and Currencies

SELECT 
    `continent_code`,
	`currency_code`,
    COUNT(`currency_code`) AS `currency_usage`
FROM `countries` AS c1
GROUP BY `continent_code` , `currency_code`
HAVING `currency_usage` = (SELECT COUNT(`currency_code`) AS `count`
                              FROM `countries` AS c2
                              WHERE c2.`continent_code` = c1 .`continent_code`
							  GROUP BY c2.`currency_code`
                              ORDER BY `count` DESC
                              LIMIT 1)
    AND `currency_usage` > 1
ORDER BY `continent_code` , `currency_code`;



#16. Countries without any Mountains

SELECT 
    COUNT(*) AS 'country_count'
FROM `countries` AS c
        LEFT JOIN `mountains_countries` AS mc USING (`country_code`)
        LEFT JOIN `mountains` AS m ON mc.`mountain_id` =  m.`id`
WHERE m.`id` IS NULL;






#17. Highest Peak and Longest River by Country

SELECT 
    c.`country_name`,
    MAX(p.`elevation`) as 'highest_peak_elevation',
    MAX(r.`length`) as 'longest_river_length'
    
FROM `countries` AS c
        LEFT JOIN `mountains_countries` AS mc USING (`country_code`)
        LEFT JOIN `peaks` AS p USING (`mountain_id`)
        LEFT JOIN `countries_rivers` AS cr USING (`country_code`)
        LEFT JOIN `rivers` AS r ON cr.`river_id` = r.`id`
GROUP BY c.`country_name`
ORDER BY `highest_peak_elevation` DESC, `longest_river_length` DESC, c.`country_name`
LIMIT 5; 
























