USE `soft_uni`;

# 1

SELECT `first_name`, `last_name`
FROM `employees`
WHERE UPPER(LEFT(`first_name`, 2)) = 'SA';

# 2

SELECT `first_name`, `last_name`
FROM `employees`
WHERE REGEXP_LIKE(`last_name`, 'ei');

# 3

SELECT `first_name`
FROM `employees`
WHERE `department_id` IN (3, 10)
  AND YEAR(`hire_date`) BETWEEN '1995' AND '2005'
ORDER BY `employee_id`;

# 4

SELECT `first_name`, `last_name`
FROM `employees`
WHERE NOT REGEXP_LIKE(`job_title`, 'engineer')
ORDER BY `employee_id`;

# 5

SELECT `name`
FROM `towns`
WHERE LENGTH(`name`) IN (5, 6)
ORDER BY `name`;

# 6

SELECT `town_id`, `name`
FROM `towns`
WHERE UPPER(LEFT(`name`, 1)) IN ('M', 'K', 'B', 'E')
ORDER BY `name`;

# 7

SELECT `town_id`, `name`
FROM `towns`
WHERE UPPER(LEFT(`name`, 1)) NOT IN ('R', 'B', 'D')
ORDER BY `name`;

# 8

CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name`
FROM `employees`
WHERE YEAR(`hire_date`) > 2000;

SELECT *
FROM `v_employees_hired_after_2000`;

# 9

SELECT `first_name`, `last_name`
FROM `employees`
WHERE LENGTH(`last_name`) = 5;

