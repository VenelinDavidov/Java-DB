use `geography`; 

#10. Countries Holding 'A'

select `country_name`, `iso_code` from  `countries`
where `country_name` like '%a%a%a%'
order by `iso_code`;

#11. Mix of Peak and River Names

select `peak_name` , `river_name`, 
concat(lower(`peak_name`), substring(lower(`river_name`), 2)) 
as `mix` from `peaks`, `rivers`
where right(`peak_name`, 1) = left(`river_name`, 1)
order by `mix`;
