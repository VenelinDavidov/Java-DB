use `soft_uni`;


# use join

SELECT COUNT(*)
FROM`employees` AS e
        JOIN `addresses` AS a ON e.`employee_id` = a.`address_id`
        JOIN `towns` AS t ON a.`town_id` = t.`town_id`
WHERE t.`name` = 'Sofia';


#use other select

SELECT COUNT(*)
FROM `employees` AS e
WHERE e.`address_id` IN (SELECT `address_id`
        FROM `addresses` AS a
        WHERE a.`town_id` = (SELECT `town_id`
        FROM`towns`
                WHERE `name` = 'Sofia'));