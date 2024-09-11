use gringotts;

#1 Records’ Count
select count(*) as "count" from `wizzard_deposits`;

#02. Longest Magic Wand
select max(`magic_wand_size`) as "longest_magic_wand" from `wizzard_deposits`;

#03. Longest Magic Wand per Deposit Groups
select `deposit_group`, max(`magic_wand_size`) as "longest_magic_wand" from `wizzard_deposits`
group  by `deposit_group`
order by `longest_magic_wand`, `deposit_group`;

#04. Smallest Deposit Group per Magic Wand Size
select `deposit_group` from `wizzard_deposits`
group by `deposit_group`
order by avg(`magic_wand_size`) asc
limit 1;


#05. Deposits Sum
select `deposit_group`, sum(`deposit_amount`) as "total_sum" from `wizzard_deposits`
group by `deposit_group`
order by `total_sum`;

#06. Deposits Sum for Ollivander Family
select `deposit_group`, sum(`deposit_amount`) as "total_sum" from `wizzard_deposits`
where `magic_wand_creator` = "Ollivander family"
group by `deposit_group`
order by `deposit_group`;

#07. Deposits Filter
select `deposit_group`, sum(`deposit_amount`) as "total_sum" from `wizzard_deposits`
where `magic_wand_creator` = "Ollivander family"
group by `deposit_group`
having `total_sum` < 150000
order by `total_sum` desc;

#08. Deposit Charge
select `deposit_group`, `magic_wand_creator`, min(`deposit_charge`) as "min_deposit_charge" from `wizzard_deposits`
group by `deposit_group`, `magic_wand_creator`
order by `magic_wand_creator`, `deposit_group`;

#09. Age Groups
select (
case
when `age` BETWEEN 0 AND 10 THEN '[0-10]'
               WHEN `age` BETWEEN 11 AND 20 THEN '[11-20]'
               WHEN `age` BETWEEN 21 AND 30 THEN '[21-30]'
               WHEN `age` BETWEEN 31 AND 40 THEN '[31-40]'
               WHEN `age` BETWEEN 41 AND 50 THEN '[41-50]'
               WHEN `age` BETWEEN 51 AND 60 THEN '[51-60]'
               ELSE '[61+]'
               END
) as "age_group", count(`age`) as "wizards_count" from `wizzard_deposits`
group by `age_group`
order by `age_group`;

#10. First Letter
select left(`first_name`, 1) as 'first_letter'
from `wizzard_deposits`
where `deposit_group` = 'Troll Chest'
group by `first_letter`
order by `first_letter`;

#11. Average Interest
select `deposit_group` as 'deposit_group', `is_deposit_expired`, AVG(`deposit_interest`) AS 'average_interest'
from `wizzard_deposits`
where `deposit_start_date` > '1985-01-01'
group by  `deposit_group`, `is_deposit_expired`
order by  `deposit_group` desc, `is_deposit_expired`;









































