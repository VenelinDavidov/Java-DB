CREATE DATABASE restaurant_db;
USE restaurant_db;


# 02. Insert
CREATE TABLE `products` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE,
    `type` VARCHAR(30) NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL
);

CREATE TABLE `clients` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `birthdate` DATE NOT NULL,
    `card` VARCHAR(50),
    `review` TEXT
);

CREATE TABLE `tables` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `floor` INT NOT NULL,
    `reserved` TINYINT (1),
    `capacity` INT NOT NULL
);


CREATE TABLE `waiters` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `phone` VARCHAR(50),
    `salary` DECIMAL(10 , 2)
);

CREATE TABLE `orders` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `table_id` INT NOT NULL,
    `waiter_id` INT NOT NULL,
    `order_time` TIME NOT NULL,
    `payed_status` TINYINT (1),
    FOREIGN KEY (`table_id`)
        REFERENCES   `tables` (`id`),
    FOREIGN KEY (`waiter_id`)
        REFERENCES `waiters` (`id`)
);

CREATE TABLE `orders_clients` (
    `order_id` INT,
    `client_id` INT,
    CONSTRAINT fk_orders_clients_order FOREIGN KEY (`order_id`)
        REFERENCES orders (`id`),
    CONSTRAINT fk_orders_clients_clients FOREIGN KEY (`client_id`)
        REFERENCES clients (`id`)
);

CREATE TABLE `orders_products` (
    `order_id` INT,
    `product_id` INT,
    CONSTRAINT fk_orders_products_order FOREIGN KEY (`order_id`)
        REFERENCES orders (`id`),
    CONSTRAINT fk_orders_products_products FOREIGN KEY (`product_id`)
        REFERENCES products (`id`)
);



#02. Insert
INSERT INTO `products` (`name`,`type`,`price`)(
SELECT 
        CONCAT(`last_name`, ' specialty'),
	   'Cocktail',
	    CEILING(0.01 * salary)
      FROM `waiters`
WHERE id > 6);	


#03. Update
UPDATE `orders` 
SET `table_id` = `table_id` - 1
WHERE id BETWEEN 12 AND 23;


#04. Delete

DELETE FROM `waiters` 
WHERE `id` NOT IN (SELECT 
        `waiter_id`
    FROM `orders`);


# SELECT WAITER -> ORDERS
SELECT w.id,
     (SELECT COUNT(*) FROM `orders` WHERE w.`id` = `waiter_id`)  as o_count
         FROM `waiters` AS w
HAVING o_count = 0;	

# A)
DELETE  FROM `waiters` AS w
WHERE 
     (SELECT COUNT(*) FROM `orders` WHERE w.`id` = `waiter_id`) = 0;
 
 
 
 #05. Clients
 
 SELECT 
    `id`,
    `first_name`,
    `last_name`,
    `birthdate`,
    `card`,
    `review`
FROM
    `clients`
ORDER BY `birthdate` DESC , `id` DESC;


#06. Birthdate
SELECT 
    `first_name`, `last_name`, `birthdate`, `review`
FROM
    `clients`
WHERE
    `card` IS NULL
        AND `birthdate` BETWEEN '1978-01-01' AND '1993-12-31'
ORDER BY `last_name` DESC , `id` DESC
LIMIT 5; 
 
 
 #07. Accounts
 
 SELECT 
    CONCAT(`last_name`,
            `first_name`,
            CHAR_LENGTH(`first_name`),
            'Restaurant') AS 'user_name',
    REVERSE(SUBSTRING(`email`, 2, 12)) AS 'password'
FROM
    `waiters`
WHERE
    `salary` IS NOT NULL
ORDER BY `password` DESC;
 
 
 
 
 
 #08. Top from menu
 
SELECT 
    `id`, 
    `name`,
    COUNT(op.`order_id`) AS 'count'
FROM
    `products` AS p
        JOIN
    `orders_products` AS op ON p.`id` = op.`product_id`
GROUP BY p.`id`
HAVING `count` >= 5
ORDER BY `count` DESC , p.`name`;

 
 
 #09. Availability
	
    SELECT 
    t.`id` AS 'table_id',
    t.`capacity`,
    COUNT(oc.`client_id`) AS 'count_clients',
    CASE
        WHEN t.`capacity` > COUNT(oc.`client_id`) THEN 'Free seats'
        WHEN t.`capacity` = COUNT(oc.`client_id`) THEN 'Full'
        ELSE 'Extra seats'
    END AS 'availability'
FROM
    `tables` AS t
        JOIN
    `orders` AS o ON t.`id` = o.`table_id`
        JOIN
    `orders_clients` AS oc ON o.`id` = oc.`order_id`
WHERE
    `floor` = 1
GROUP BY t.`id` 
ORDER BY t.`id` DESC;
    
 
 
 
 #10. Extract bill
 
DELIMITER $$
CREATE FUNCTION `udf_client_bill` (full_name VARCHAR(50))
RETURNS  DECIMAL (19,2)
DETERMINISTIC
BEGIN 
     DECLARE space_index INT;
     SET space_index := LOCATE(' ', full_name);
     
     RETURN (
       SELECT  SUM(p.`price`) 
         FROM `clients` AS c
            JOIN `orders_clients`AS oc ON c.`id`= oc.`client_id`
            JOIN `orders` AS o ON oc.`order_id` = o.`id`
		    JOIN `orders_products` AS op ON o.`id` = op.`order_id`
            JOIN `products` AS p ON op.`product_id` = p.`id`
     WHERE c.`first_name` = SUBSTRING(full_name, 1,space_index -1) AND
           c.`last_name` = SUBSTRING(full_name,space_index + 1)
     );
END$$

SELECT c.first_name,c.last_name, udf_client_bill('Silvio Blyth') as 'bill' FROM clients c 
WHERE c.first_name = 'Silvio' AND c.last_name= 'Blyth';




# Друго решение

DELIMITER$$
CREATE FUNCTION `udf_client_bill` (full_name VARCHAR(50))
RETURNS DECIMAL (19,2)
DETERMINISTIC
BEGIN
    DECLARE total_price DECIMAL(19, 2);
	SELECT SUM(p.`price`)
	INTO total_price
    FROM `clients` AS c
            JOIN `orders_clients`AS oc ON c.`id`= oc.`client_id`
            JOIN `orders` AS o ON oc.`order_id` = o.`id`
		    JOIN `orders_products` AS op ON o.`id` = op.`order_id`
            JOIN `products` AS p ON op.`product_id` = p.`id`
    WHERE c.`first_name` = SUBSTRING_INDEX(full_name, ' ', 1)
      AND c.`last_name` = SUBSTRING_INDEX(full_name, ' ', -1);
   RETURN total_price;
END$$

    
    


#11. Happy hour

DELIMITER $$
 CREATE PROCEDURE `udp_happy_hour` (`type` VARCHAR(50))
 BEGIN
      UPDATE `products` AS p
      SET p.`price` = p.`price` * 0.8
      WHERE price >= 10 AND p.`type` = `type`;
 END$$
  
  
  
CALL udp_happy_hour ('Cognac');
    
    
    