CREATE DATABASE online_store;
USE online_store;


#01. Table Design

CREATE TABLE `brands` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `categories` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `reviews` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `content` TEXT,
    `rating` DECIMAL(10 , 2 ) NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
    `published_at` DATETIME NOT NULL
);

CREATE TABLE `products` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL,
    `price` DECIMAL(19 , 2 ) NOT NULL,
    `quantity_in_stock` INT,
    `description` TEXT,
    `brand_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    `review_id` INT,
    CONSTRAINT fk_products_brands FOREIGN KEY (`brand_id`)
        REFERENCES brands (`id`),
    CONSTRAINT fk_products_categories FOREIGN KEY (`category_id`)
        REFERENCES categories (`id`),
    CONSTRAINT fk_products_reviews FOREIGN KEY (`review_id`)
        REFERENCES reviews (`id`)
);

CREATE TABLE `customers` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `phone` VARCHAR(30) NOT NULL UNIQUE,
    `address` VARCHAR(60) NOT NULL,
    `discount_card` BIT NOT NULL DEFAULT 0
);

CREATE TABLE `orders` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `order_datetime` DATETIME NOT NULL,
    `customer_id` INT NOT NULL,
    CONSTRAINT fk_orders_customers FOREIGN KEY (`customer_id`)
        REFERENCES customers (`id`)
);

CREATE TABLE `orders_products` (
    `order_id` INT,
    `product_id` INT,
    CONSTRAINT fk_orders_products_orders FOREIGN KEY (`order_id`)
        REFERENCES orders (`id`),
    CONSTRAINT fk_orders_products_products FOREIGN KEY (`product_id`)
        REFERENCES products (`id`)
) ;




#02. Insert
INSERT INTO `reviews` (`content`,`rating`,`picture_url`,`published_at`)
SELECT 
      LEFT(p.`description`,15),
	  p.`price`/8,
	  REVERSE(p.`name`),
      DATE('2010-10-10')
  FROM `products` as p
WHERE p.id >= 5;




#03. Update
  UPDATE `products` as p
  SET p.`quantity_in_stock` = p.`quantity_in_stock` -5 
  WHERE  p.`quantity_in_stock` BETWEEN 60 AND 70;




#04. DELETE
DELETE FROM `customers` 
WHERE
    `id` NOT IN (SELECT 
        `customer_id`
    FROM
        `orders`);

SELECT c.`id`,
      (SELECT COUNT(*) FROM `orders` AS o 
                       WHERE c.`id` = o.`customer_id`) as o_count
      FROM `customers` as c
      HAVING o_count = 0;

#Друго решение
DELETE c FROM `customers` AS c
       LEFT JOIN `orders` AS o ON c.`id` = o.`customer_id`
WHERE o.`customer_id` IS NULL;




#05. Categories

SELECT `id`, `name` FROM `categories`
ORDER BY `name` DESC;



#06. Quantity

SELECT `id` AS 'product_id',
        `brand_id`,
        `name`,
        `quantity_in_stock` AS 'quantity'
FROM `products`  
WHERE `price` > 1000 AND  `quantity_in_stock` < 30
ORDER BY `quantity` ASC, `id`;



#07. Review
SELECT `id`,
        `content`,
        `rating`,
        `picture_url`,
        `published_at`   FROM `reviews`
WHERE CHAR_LENGTH(`content`) > 61 AND `content` like 'My%'
ORDER BY `rating` DESC;



#08. First customers

SELECT 
      CONCAT_WS(' ', `first_name`,`last_name`) AS 'full_name',
      `address`,
      `order_datetime` As 'order_date'
FROM `orders` As o
      JOIN `customers` As c ON  o.`customer_id` = c.`id`
WHERE YEAR(o.`order_datetime`) <= 2018
      ORDER BY `full_name` DESC;




#09. Best categories
SELECT 
      COUNT(c.`id`) AS 'items_coun',
      c.`name`,
      SUM(p.`quantity_in_stock`) AS 'total_quantit'
     FROM `products` As p
JOIN `categories` As c ON p.`category_id` = c.`id` 
GROUP BY c.`id`
ORDER BY `items_coun` DESC,`total_quantit` ASC
LIMIT 5;



#10. Extract client cards count

CREATE FUNCTION `udf_customer_products_count`(`name` VARCHAR(30))
RETURNS INT 
DETERMINISTIC
RETURN(
     SELECT  COUNT(c.`id`) AS 'total_products'
FROM `customers` AS c
     JOIN `orders` AS o ON c.`id` = o.`customer_id`
     JOIN `orders_products` AS op ON o.`id` = op.`order_id`
WHERE c.`first_name` = `name`
GROUP BY c.`id`);



# Вариант 2
DELIMITER $$

CREATE FUNCTION `udf_customer_products_count`(`name` VARCHAR(30))
RETURNS INT 
DETERMINISTIC
BEGIN
    DECLARE  count_of_product INT; # декларирам променлива 
        SET count_of_product :=(
                            SELECT COUNT(*) FROM `customers` AS c
                            JOIN `orders` AS o ON c.`id` = o.`customer_id`
                            JOIN `orders_products` AS op ON o.`id` = op.`order_id`
WHERE c.`first_name` = `name`
GROUP BY c.`id`
);
RETURN count_of_product;
END$$

 SELECT c.first_name,c.last_name, udf_customer_products_count('Shirley') AS `total_products`
 FROM customers c WHERE c.first_name = 'Shirley';





#11. Reduce price

DELIMITER $$
CREATE PROCEDURE `udp_reduce_price` (category_name VARCHAR(50))
BEGIN 
    UPDATE `products` AS p
    JOIN `reviews` AS r On p.`review_id` = r.`id`
	JOIN `categories` As c ON p.`category_id` = c.`id` 
    SET p.`price` = p.`price` * 0.70
    WHERE c.`name` = category_name AND  r.`rating` < 4;
END$$


CALL udp_reduce_price ('Phones and tablets');









