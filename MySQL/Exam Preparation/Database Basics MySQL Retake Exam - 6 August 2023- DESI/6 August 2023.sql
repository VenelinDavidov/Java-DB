CREATE DATABASE `real_estate_db`;
USE `real_estate_db`;


#01. Table Design

CREATE TABLE `cities` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(60) NOT NULL UNIQUE
);


CREATE TABLE `property_types` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `type` VARCHAR(40) NOT NULL UNIQUE,
    `description` TEXT
);

CREATE TABLE `properties` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `address` VARCHAR(80) NOT NULL UNIQUE,
    `price` DECIMAL(19 , 2 ) NOT NULL,
    `area` DECIMAL(19 , 2 ),
    `property_type_id` INT,
    `city_id` INT,
    CONSTRAINT fk_properties_property_types FOREIGN KEY (`property_type_id`)
        REFERENCES property_types (`id`),
    CONSTRAINT fk_properties_cities FOREIGN KEY (`city_id`)
        REFERENCES cities (`id`)
);

CREATE TABLE `agents` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(50) NOT NULL UNIQUE,
    `city_id` INT,
    CONSTRAINT fk_agents_cities FOREIGN KEY (`city_id`)
        REFERENCES cities (`id`)
);


CREATE TABLE `buyers` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(50) NOT NULL UNIQUE,
    `city_id` INT,
    CONSTRAINT fk_buyers_cities FOREIGN KEY (`city_id`)
        REFERENCES cities (`id`)
);


CREATE TABLE `property_offers` (
    `property_id` INT NOT NULL,
    `agent_id` INT NOT NULL,
    `price` DECIMAL(19 , 2 ),
    `offer_datetime` DATETIME,
    CONSTRAINT fk_property_offers_properties FOREIGN KEY (`property_id`)
        REFERENCES properties (`id`),
    CONSTRAINT fk_roperty_offers_agents FOREIGN KEY (`agent_id`)
        REFERENCES agents (`id`)
);


CREATE TABLE `property_transactions` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `property_id` INT NOT NULL,
    `buyer_id` INT NOT NULL,
    `transaction_date` DATE,
    `bank_name` VARCHAR(30),
    `iban` VARCHAR(40) UNIQUE,
    `is_successful` BOOLEAN,
    CONSTRAINT fk_property_transactions_properties FOREIGN KEY (`property_id`)
        REFERENCES properties (`id`),
    CONSTRAINT fk_property_transactions_buyers FOREIGN KEY (`buyer_id`)
        REFERENCES buyers (`id`)
);




#02. Insert

INSERT INTO `property_transactions` (`property_id`,`buyer_id`,`transaction_date`,`bank_name`,`iban`,`is_successful`)
SELECT 
     po.`agent_id` + day(po.`offer_datetime`),
     po.`agent_id` + month(po.`offer_datetime`),
     date(po.`offer_datetime`),
     concat('Bank ',po.`agent_id`),
     concat('BG',po.`price`,po.`agent_id`),
     true
FROM `property_offers` as po
WHERE po.`agent_id` <= 2;





#03. Update
UPDATE `properties` as p 
    SET p.`price` = p.`price` - 50000
WHERE p.`price` >= 800000;



#04. Delete
DELETE trans FROM `property_transactions` AS trans 
WHERE
    trans.`is_successful` = 0;




#05. Agents
SELECT 
    *
FROM
    `agents`
ORDER BY `city_id` DESC , `phone` DESC;





#06. Offers from 2021

SELECT 
    *
FROM
    `property_offers` AS po
WHERE
    YEAR(po.`offer_datetime`) = 2021
ORDER BY po.`price` ASC
LIMIT 10;





#07. Properties without offers
SELECT 
    SUBSTRING(pr.`address`,1,6) AS 'agent_name',
    CHAR_LENGTH(pr.`address`) * 5430 AS 'price'
FROM `properties` AS pr
        LEFT JOIN
    `property_offers` AS po ON pr.`id` = po.`property_id`
WHERE
    po.`agent_id` IS NULL
ORDER BY `agent_name` DESC , `price` DESC; 




#08. Best Banks 
SELECT 
    `bank_name`, COUNT(*) AS 'count'
FROM
    `property_transactions`
GROUP BY `bank_name`
HAVING `count` >= 9
ORDER BY count DESC , `bank_name` ASC;






#09. Size of the area

SELECT 
    `address`,
    `area`,
    (CASE
        WHEN area <= 100 THEN 'small'
        WHEN area <= 200 THEN 'medium'
        WHEN area <= 500 THEN 'large'
        WHEN area > 500 THEN 'extra large'
    END) AS 'size'
FROM
    `properties`
ORDER BY `area` ASC , `address` DESC; 





#10. Offers count in a city

DELIMITER $$
CREATE FUNCTION `udf_offers_from_city_name` (cityName VARCHAR (50))
 RETURNS INT
 DETERMINISTIC
 BEGIN
       DECLARE offers_count	INT;
       SET offers_count := (
	
           SELECT COUNT(*) FROM `property_offers` as po
           JOIN  `properties` AS p ON po.`property_id` = p.`id`
           JOIN `cities` AS c On p.`city_id` =  c.`id`
           WHERE c.`name` = cityName
       );
       RETURN offers_count;
 END$$





#11. Special Offer

DELIMITER $$

CREATE PROCEDURE `udp_special_offer` (first_name VARCHAR(50))
BEGIN

          UPDATE `property_offers` AS po
          JOIN `agents` as a ON po.`agent_id` = a.`id`
          SET po.`price` = po.`price` * 0.9
          WHERE a.`first_name` = first_name;
	
END$$














