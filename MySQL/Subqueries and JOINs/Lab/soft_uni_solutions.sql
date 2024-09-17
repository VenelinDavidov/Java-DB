USE `soft_uni`;

# 1

SELECT `employee_id`,
       `CONCAT_WS`(' ', `first_name`, `last_name`) AS 'full_name',
       `departments`.`department_id`,
       `name`                                      AS 'department_name'
FROM `employees`
         JOIN `departments`
              ON `departments`.`manager_id` = `employees`.`employee_id`
ORDER BY `employee_id`
LIMIT 5;

# 2

SELECT `towns`.`town_id`, `name` AS 'town_name', `address_text`
FROM `towns`
         JOIN `addresses` ON `towns`.`town_id` = `addresses`.`town_id`
WHERE `towns`.`town_id` IN (9, 15, 32)
ORDER BY `town_id`, `address_id`;

# 3

SELECT `employee_id`, `first_name`, `last_name`, `department_id`, `salary`
FROM `employees`
WHERE `manager_id` IS NULL;

# 4

SELECT COUNT(*) AS 'count'
FROM `employees`
WHERE `salary` > (SELECT AVG(`salary`)
                  FROM `employees`);



