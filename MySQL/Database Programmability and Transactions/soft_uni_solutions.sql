USE `soft_uni`;

# 1

CREATE FUNCTION `ufn_count_employees_by_town`(`town_name` VARCHAR(50))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE `employee_count` INT;
    SET `employee_count` := (SELECT COUNT(`employee_id`)
                             FROM `employees` `e`
                                      INNER JOIN `addresses` `a` USING (`address_id`)
                                      INNER JOIN `towns` `t` USING (`town_id`)
                             WHERE `t`.`name` = `town_name`);
    RETURN `employee_count`;
END;

# 2

CREATE PROCEDURE `usp_raise_salaries`(`department_name` VARCHAR(50))
BEGIN
    UPDATE `employees`
        INNER JOIN `departments` `d` USING (`department_id`)
    SET `salary` = `salary` * 1.05
    WHERE `name` = `department_name`;
END;


# 3

CREATE PROCEDURE `usp_raise_salary_by_id`(`id` INT)
BEGIN
    IF ((SELECT COUNT(`employee_id`)
         FROM `employees`
         WHERE `employee_id` = `id`) > 0) THEN
        UPDATE `employees`
        SET `salary` = `salary` * 1.05
        WHERE `employee_id` = `id`;
    END IF;
END;

# 3.1

CREATE PROCEDURE `usp_raise_salary_by_id`(`id` INT)
BEGIN
    START TRANSACTION;
    IF ((SELECT COUNT(`employee_id`)
         FROM `employees`
         WHERE `employee_id` = `id`) <> 1) THEN
        ROLLBACK;
    ELSE
        UPDATE `employees`
        SET `salary` = `salary` * 1.05
        WHERE `employee_id` = `id`;
    END IF;
END;

# 4

CREATE TABLE `deleted_employees`
(
    `employee_id`   INT PRIMARY KEY AUTO_INCREMENT,
    `first_name`    VARCHAR(50),
    `last_name`     VARCHAR(50),
    `middle_name`   VARCHAR(50),
    `job_title`     VARCHAR(50),
    `department_id` INT,
    `salary`        DECIMAL
);

CREATE TRIGGER `tr_deleted_employees`
    AFTER DELETE
    ON `employees`
    FOR EACH ROW
BEGIN
    INSERT INTO `deleted_employees`(`first_name`, `last_name`, `middle_name`, `job_title`, `department_id`, `salary`)
    VALUES (`OLD`.`first_name`, `OLD`.`last_name`, `OLD`.`middle_name`, `OLD`.`job_title`, `OLD`.`department_id`,
            `OLD`.`salary`);
END;