create database employee;
use employee;
create table emprecord(
id int primary key auto_increment not null,
name varchar(50),
department varchar(50),
salary int,
city varchar(50),
joindate date);
insert into emprecord(id,name,department,salary,city,joindate)values
(1,'Amit','Engineering',90000,'New York','2020-01-15'),
(2,'Bijay','Marketing',60000,'Chicago','2019-03-22'),
(3,'Chirag','Engineering',95000,'New York','2021-06-21'),
(4,'Dhiren','Hr',50000,'Dallas','2018-11-05'),
(5,'Emily','Marketing',65000,'Chicago','2025-08-19'),
(6,'Fazal','Engineering',NULL,'NewYork','2023-01-30'),
(7,'Gurprit','Hr',55000,NULL,'2017-07-14');
create table projects(project_id int primary key auto_increment,
project_name varchar(50),
budget int,
employee_id int,
status varchar(20),
foreign key (employee_id) references emprecord(id) );
insert into projects(project_name,budget,employee_id,status) values
('Alpha',100000,1,'Completed'),('Beta',50000,2,'Pending'),('Gamma',75000,1,'Active'),
('Delta',30000,4,'On Hold'),('fy',90000,3,'Active'),('Zeta',45000,NULL,'Completed'),
('Eta',60000,5,'On Hold');