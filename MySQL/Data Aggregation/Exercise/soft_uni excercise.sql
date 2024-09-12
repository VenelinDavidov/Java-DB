
#12. Employees Minimum Salaries
select  `department_id`, min(`salary`) as 'minimum_salary' from `employees`
where `hire_date` > 2000-01-01
group by `department_id`
having `department_id` in (2,5,7)
order by `department_id`; 

#13. Employees Average Salaries
create table `high_paid_empolyees` AS
select * from `employees`
where `salary` > 30000;

delete from `high_paid_empolyees`
where `manager_id` = 42;

update `high_paid_empolyees`
set `salary` = `salary` + 5000
where `department_id` = 1;

SELECT `department_id`, AVG(`salary`) AS 'avg_salary'
FROM `high_paid_empolyees`
GROUP BY `department_id`
ORDER BY `department_id`;

#14. Employees Maximum Salaries
select `department_id`, max(`salary`) as 'max_salary' from `employees`
group by `department_id`
having `max_salary` not between 30000 and 70000
order by `department_id`;

#15. Employees Count Salaries
select count(*) from `employees`
where `manager_id` is null;

#16. 3rd Highest Salary
select `department_id`,
       (select distinct `salary` from `employees` e2
        where e1.`department_id` = e2 .`department_id`
        order by `salary` desc	
        limit 1 offset 2) as 'third_highest_salary'
from `employees` e1
group by  `department_id`
having `third_highest_salary` is not null
order by  `department_id`;

#17. Salary Challenge
select `first_name`, `last_name`, `department_id` from `employees` as current_employee
where `salary` > (
                  select avg(`salary`) from `employees` other_employee
                  where current_employee.`department_id` = other_employee.`department_id`
				 )
order by `department_id`, `employee_id`
limit 10;

#18. Departments Total Salaries
select `department_id`, SUM(`salary`) AS 'total_salary'
from `employees`
group by  `department_id`
order by  `department_id`;










