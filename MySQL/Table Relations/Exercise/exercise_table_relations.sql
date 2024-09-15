use `tablerelations`;

#01. One-To-One Relationship

create table `passports`(
    `passport_id` int primary key auto_increment,
    `passport_number` varchar (50) unique not null
);

insert into `passports` (`passport_id`,`passport_number`)
values 
	   (101, 'N34FG21B'),
       (102, 'K65LO4R7'),
       (103, 'ZE657QP2');
       
create table `people` (
	`person_id` int primary key auto_increment,
    `first_name` varchar (50) not null, 
    `salary` decimal (9,2),
    `passport_id` int unique not null,
    constraint fk_people_passport
    foreign key (`passport_id`)
    references `passports`(`passport_id`)
);

insert into `people` (`first_name`,`salary`,`passport_id`)
values 
       ('Roberto', 43300.00, 102),
       ('Tom', 56100.00, 103),
       ('Yana', 60200.00, 101);
       


#02. One-To-Many Relationship

create table `manufacturers` (
     `manufacturer_id` int primary key auto_increment,
     `name` varchar (50) not null unique,
     `established_on` date
);

insert into `manufacturers` (`name`,`established_on`)
values 
        ('BMW', '1916/03/01'),
       ('Tesla', '2003/01/01'),
       ('Lada', '1966/05/01');
       
 create table `models` (
        `model_id` int primary key auto_increment,
        `name` varchar (50) not null,
        `manufacturer_id` int,
        constraint fk_models_cars
		foreign key (`manufacturer_id`)
        references `manufacturers`(`manufacturer_id`)
 );
 
 insert into `models` (`model_id`,`name`,`manufacturer_id`)
 values 
	   (101, 'X1', 1),
       (102, 'i6', 1),
       (103, 'Model S', 2),
       (104, 'Model X', 2),
       (105, 'Model 3', 2),
       (106, 'Nova', 3);
   
   
   
   #03. Many-To-Many Relationship
   
   use `school`;
   
   create table `students` (
        `student_id` int primary key auto_increment,
        `name` varchar (70) not null
   );
   
   insert into `students` (`name`)
   values 
         ('Mila'),
         ('Toni'),
         ('Ron');
         
create table `exams` (
    `exam_id` int primary key auto_increment,
    `name` varchar (100) not null
);

alter table `exams` auto_increment = 101;

insert into `exams` (`name`)
values 
      ('Spring MVC'),
       ('Neo4j'),
       ('Oracle 11g');
       
create table `students_exams` (
        `student_id` int not null,
         `exam_id` int not null,
         
         constraint pk_exam_student
         primary key (`student_id`, `exam_id`),
         
         constraint fk_studens_student_id
         foreign key (`student_id`)
         references `students` (`student_id`),
         
         constraint fk_exams_exam_id
         foreign key (`exam_id`)
         references `exams` (`exam_id`)

);

insert into  `students_exams` (`student_id`,`exam_id`)
values 
       (1, 101),
       (1, 102),
       (2, 101),
       (3, 103),
       (2, 102),
       (2, 103);
       
       
       
 #04. Self-Referencing
 
 use `selfref`;
 
 create table `teachers` (
          `teacher_id` int primary key auto_increment,
          `name` varchar (50) not null,
          `manager_id` int 
 );
 alter table `teachers` auto_increment = 101;
 insert into `teachers` (`name`, `manager_id`)
 values 
        ('John', NULL),
       ('Maya', 106),
       ('Silvia', 106),
       ('Ted', 105),
       ('Mark', 101),
       ('Greta', 101);
       
  alter table  `teachers`
  add constraint fk
  foreign key (`manager_id`)
  references `teachers` (`teacher_id`);
       
       
       
       
 #05. Online Store Database
 
 use `store`; 
 
 create table `cities` (
    `city_id` int (11) primary key auto_increment,
    `name`    varchar(50)
 );
 
 create table `item_types` (
   `item_type_id` int (11) primary key auto_increment,
    `name`        varchar(50)
 );
 
 create table `customers` (
    `customer_id` int (11) primary key auto_increment,
    `name`        varchar(50),
    `birthday`    date,
    `city_id`    int(11),
    constraint fk_customers
    foreign key (`city_id`)
    references `cities`(`city_id`)
 );
 
 create table `orders` (
	`order_id`    int (11) primary key auto_increment,
    `customer_id` int(11),
    constraint fk_orders
    foreign key (`customer_id`)
    references `customers`(`customer_id`)
 );
 
 create table `items` (
	`item_id`      int (11) primary key auto_increment,
    `name`         varchar(50),
    `item_type_id` INT (11),
    constraint fk_items
    foreign key (`item_type_id`)
    references `item_types` (`item_type_id`)
 );
 
 
 create table `order_items` (
	`order_id` INT (11),
    `item_id`  INT (11),
    
    constraint pk
    primary key  (`order_id`, `item_id`),
    
    foreign key (`order_id`)
    references `orders` (`order_id`),
    
    foreign key (`item_id`)
    references `items` (`item_id`)
 );
 
 
 

 #06. University Database
 
 use `university`;
 
 create table  `subjects` (
     `subject_id` int (11) primary key auto_increment,
     `subject_name` varchar (50) 
 );
 
 create table `majors` (
      `major_id` int (11) primary key auto_increment,
      `name` varchar (50) 
 );
 
create table `payments` (
     `payment_id` int(11) primary key auto_increment,
     `payment_date` date,
     `payment_amount` decimal (8,2),
     `student_id` int (11)
);

create table `students` (
   `student_id` int (11) primary key auto_increment,
   `student_name` varchar (50), 
   `student_number` varchar (12) unique,
    `major_id` int
);

create table `agenda`(
    `student_id` int (11),
    `subject_id` int (11),
    constraint pk
    primary key (`student_id`,`subject_id`)
);

# connect with payments -> students fk_payments
alter table `payments` 
add constraint  fk_students
foreign key (`student_id`)
references `students` (`student_id`);


# connect with students -> majors fk_students
alter table `students`
add constraint fk_majors
foreign key (`major_id`)
references `majors`(`major_id`);

# connect with agenda -> subject fk_agenda
alter table `agenda`
add constraint fk_subjects
foreign key (`subject_id`)
references `subjects`(`subject_id`);


#connect with agenda -> students fk_agenda
alter table `agenda`
add constraint fk_students_agenda
foreign key (`student_id`)
references `students`(`student_id`);





#09. Peaks in Rila

select (
    select `mountain_range` from mountains
    where mountain_range = 'Rila') as 'mountain_range', 
    `peak_name`, `elevation` as 'peak_elevation' from peaks
where `mountain_id` = 17
order by  `peak_elevation` desc;





 
 
       
       
       
       
       
       
       
       
       
       
       
       
       
   
   
       
       
       
       
       
       
       
       
       
       
       
       
       





 
       
       
       
       
       
       
       
       
       
       
       
       