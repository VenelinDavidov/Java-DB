USE minions;

# 1

CREATE TABLE `minions`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `age`  INT          NOT NULL
);

CREATE TABLE `towns`
(
    `town_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name`    VARCHAR(255) NOT NULL
);


## MIDDLE (NOT FOR JUDGE)
alter table towns
    change town_id id int auto_increment;

# 2

ALTER TABLE minions
    ADD COLUMN town_id INT NOT NULL,
    ADD FOREIGN KEY (town_id) REFERENCES towns (id);

# 3

INSERT INTO towns(`id`, `name`)
VALUES (1, 'Sofia'),
       (2, 'Plovdiv'),
       (3, 'Varna');

INSERT INTO minions(`id`, `name`, `age`, `town_id`)
VALUES (1, 'Kevin', '22', '1'),
       (2, 'Bob', '15', '3'),
       (3, 'Steward', NULL, '2');

# 4

TRUNCATE TABLE `minions`;

# 5

DROP TABLE `minions`;
DROP TABLE `towns`;