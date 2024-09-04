CREATE DATABASE `car_rental`;

USE `car_rental`;

CREATE TABLE `categories`
(
    `id`           INT PRIMARY KEY AUTO_INCREMENT,
    `category`     VARCHAR(100) NOT NULL,
    `daily_rate`   INT,
    `weekly_rate`  INT,
    `monthly_rate` INT,
    `weekend_rate` INT
);

INSERT INTO `categories` (`category`, `daily_rate`, `weekly_rate`, `monthly_rate`, `weekend_rate`)
VALUES ('Minicompact ', 4, 5, 3, 6),
       ('Mid-size', 5, 6, 5, 9),
       ('Full-size luxury', 10, 10, 10, 10);

CREATE TABLE `cars`
(
    `id`            INT PRIMARY KEY AUTO_INCREMENT,
    `plate_number`  VARCHAR(7),
    `make`          VARCHAR(50) NOT NULL,
    `model`         VARCHAR(50),
    `car_year`      INT(4),
    `category_id`   INT         NOT NULL,
    `doors`         INT(1),
    `picture`       BLOB,
    `car_condition` VARCHAR(20),
    `available`     BOOLEAN     NOT NULL
);

INSERT INTO `cars` (`plate_number`, `make`, `model`, `car_year`, `category_id`, `doors`, `car_condition`, `available`)
VALUES ('22TY921', 'Gillig', 'Fs65', 1998, 1, 4, 'Bad', TRUE),
       ('SC39683', 'Hyundai', '4Runner Limited', 1999, 2, 4, 'Average', TRUE),
       ('6UMN164', 'Nissan', 'Altima S', 2012, 3, 4, 'Excellent!', TRUE);

CREATE TABLE `employees`
(
    `id`         INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name`  VARCHAR(50) NOT NULL,
    `title`      VARCHAR(50) NOT NULL,
    `notes`      TEXT
);

INSERT INTO `employees` (`first_name`, `last_name`, `title`)
VALUES ('Shawn', 'Reynolds', 'CEO'),
       ('Sean', 'Reynolds', 'CTO'),
       ('Stephen', 'Shaun', 'Administrator');

CREATE TABLE `customers`
(
    `id`                    INT PRIMARY KEY AUTO_INCREMENT,
    `driver_licence_number` VARCHAR(20)  NOT NULL,
    `full_name`             VARCHAR(100) NOT NULL,
    `address`               VARCHAR(100),
    `city`                  VARCHAR(55),
    `zip_code`              INT(4),
    `notes`                 TEXT
);

INSERT INTO `customers` (`driver_licence_number`, `full_name`, `address`, `city`, `zip_code`, `notes`)
VALUES ('JAMIE901059VI9LA', 'Jamie Garland', 'street Nezabravka 10', 'Cambridge', 2114, NULL),
       ('EMBUR703254NI9AT', 'Florence Embury', 'street Nezabravka 10', 'Frankfurt', 60308, NULL),
       ('OWEN9802273GA9WO', 'Gary Owen', 'street Nezabravka 10', 'London', 5208, NULL);

CREATE TABLE `rental_orders`
(
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `employee_id`       INT      NOT NULL,
    `customer_id`       INT      NOT NULL,
    `car_id`            INT      NOT NULL,
    `car_condition`     ENUM ('Bad', 'Average', 'Excellent!'),
    `tank_level`        ENUM ('Empty', 'Half', 'Full'),
    `kilometrage_start` INT      NOT NULL,
    `kilometrage_end`   INT,
    `total_kilometrage` INT                                                     DEFAULT 0,
    `start_date`        DATETIME NOT NULL,
    `end_date`          DATE,
    `total_days`        INT                                                     DEFAULT 0,
    `rate_applied`      BOOLEAN,
    `tax_rate`          DECIMAL  NOT NULL,
    `order_status`      ENUM ('Processing', 'Created', 'Released', 'Fulfilled'),
    `notes`             TEXT
);

INSERT INTO `rental_orders`(`employee_id`, `customer_id`, `car_id`, `car_condition`, `tank_level`, `kilometrage_start`,
                            `start_date`, `tax_rate`, `order_status`)
VALUES (1, 1, 3, 'Excellent!', 'Full', 217, DATE('2012-12-12'), 3.12, 'Released'),
       (2, 2, 2, 'Average', 'Half', 987, DATE('1999-10-02'), 2.07, 'Created'),
       (3, 3, 1, 'Bad', 'Half', 1723, DATE('1998-07-24'), 4.11, 'Processing');
