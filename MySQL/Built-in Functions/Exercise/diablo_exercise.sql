use diablo;

#12. Games From 2011 and 2012 Year

select `name`, date_format(start, '%Y-%m-%d') AS `start`
from games
where year(start) IN (2011, 2012)
order by `start`, `name`
LIMIT 50;

#13. User Email Providers

select `user_name`, SUBSTRING(email, LOCATE('@', email) + 1) as `emal_provider`
from `users`
order by `emal_provider`, `user_name`;

#14. Get Users with IP Address Like Pattern

select `user_name`,`ip_address` from `users`
where `ip_address` like "___.1%.%.___"
order by `user_name`;


#15. Show All Games with Duration

SELECT `name` AS `game`,
    case
        WHEN HOUR(`start`) < 12 THEN 'Morning'
        WHEN HOUR(`start`) < 18 THEN 'Afternoon'
        WHEN HOUR(`start`) < 24 THEN 'Evening'
end as `Part of the day`,
    case
        WHEN `duration` < 4 THEN 'Extra Short'
        WHEN `duration` < 7 THEN 'Short'
        WHEN `duration` < 11 THEN 'Long'
        ELSE 'Extra Long'
end as `Duration`
FROM `games`;





