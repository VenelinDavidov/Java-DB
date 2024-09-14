use camp;

#1 Mountains and Peaks

create table `mountains` (
             `id` int primary key auto_increment,
             `name` varchar (50) not null
);

create table `peaks` (
             `id` int primary key auto_increment,
             `name` varchar (50) not null,
			 `mountain_id` int,
    constraint fk_peaks_mountains
    foreign key (`mountain_id`)
    references `mountains`(id)
);

# 2. Trip Organization

select `driver_id`, `vehicle_type`, CONCAT(`first_name`,' ',`last_name`) as 'driver_name'
from `vehicles`
         join `campers` `c` on `vehicles`.`driver_id` = `c`.`id`;
         
 #3. SoftUni Hiking
 
 select `starting_point` as `oute_starting_point`,
         `end_point` as `oute_ending_point`,
         `leader_id`, concat(`first_name`,' ',`last_name`) as `leader_name` 
          from `routes`
             join `campers` on `routes`.`leader_id` = `campers`.`id`;  
             
 drop table `peaks`;
 drop table `mountains`;

#4. Delete Mountains

create table `mountains` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45)
);

create table `peaks` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45),
    `mountain_id` INT,
    constraint `fk_p_m` foreign key  (`mountain_id`)
        references `mountains` (`id`)
        on delete cascade
);