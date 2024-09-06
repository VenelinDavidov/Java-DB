USE `book_library`;

# 1

SELECT `title`
FROM `books`
WHERE LEFT(`title`, 3) = 'The'
ORDER BY `id`;

# 2

SELECT REPLACE(`title`, 'The', '***') AS `title`
FROM `books`
WHERE LEFT(`title`, 3) = 'The'
ORDER BY `id`;

# 3

SELECT ROUND(SUM(`cost`), 2)
FROM `books`;

# 4

SELECT CONCAT_WS(' ', `first_name`, `last_name`) AS 'Full Name',
       `ABS`(TIMESTAMPDIFF(DAY, `born`, `died`)) AS 'Days Lived'
FROM `authors`;

# 5

SELECT `title`
FROM `books`
WHERE REGEXP_LIKE(`title`, 'Harry Potter') = 1;

# OR

# 5

SELECT `title`
FROM `books`
WHERE `title` LIKE 'Harry Potter%';