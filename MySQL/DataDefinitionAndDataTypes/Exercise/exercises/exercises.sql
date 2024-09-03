# 6

CREATE DATABASE `exercises`;

USE exercises;

CREATE TABLE `people`
(
    `id`        INT AUTO_INCREMENT PRIMARY KEY,
    `name`      VARCHAR(200)    NOT NULL,
    `picture`   BLOB,
    `height`    DOUBLE(10, 2),
    `weight`    DOUBLE(10, 2),
    `gender`    ENUM ('m', 'f') NOT NULL,
    `birthdate` DATE            NOT NULL,
    `biography` TEXT
);

INSERT INTO people(`name`, `gender`, `birthdate`)
VALUES ('Boris', 'm', DATE(NOW())),
       ('Aleksander', 'm', DATE(NOW())),
       ('Peter', 'm', DATE(NOW())),
       ('Ivana', 'f', DATE(NOW())),
       ('Suzan', 'f', DATE(NOW()));

# MIDDLE (NOT FOR JUDGE)
ALTER TABLE people
    MODIFY COLUMN gender ENUM ('m', 'f');

# 7

CREATE TABLE `users`
(
    `id`              INT AUTO_INCREMENT PRIMARY KEY,
    `username`        VARCHAR(30) NOT NULL,
    `password`        VARCHAR(26) NOT NULL,
    `profile_picture` BLOB,
    `last_login_time` TIME,
    `is_deleted`      BOOLEAN
);

INSERT INTO `users`(`username`, `password`)
VALUES ('pesho123', 'password123'),
       ('ivan123', 'password123'),
       ('maria123', 'password123'),
       ('peter123', 'password123'),
       ('viktor123', 'password123');

# 8

ALTER TABLE users
    DROP PRIMARY KEY,
    ADD PRIMARY KEY `pk_users` (`id`, `username`);

# 9

ALTER TABLE users
    MODIFY COLUMN `last_login_time` DATETIME DEFAULT NOW();

# MIDDLE (NOT FOR JUDGE)
INSERT INTO `users` (`username`, `password`) VALUE ('test1', 'password');

# 10

ALTER TABLE `users`
    DROP PRIMARY KEY,
    ADD CONSTRAINT pk_users
    PRIMARY KEY `users` (`id`),
    MODIFY COLUMN `username` VARCHAR(30) UNIQUE;

