create database ecommerce;
use ecommerce;
create table customers(
customer_id int primary key,
customer_name varchar(50),
city varchar(50));
create table products(
product_id int primary key,
product_name varchar(50),
category varchar(50));
create table orders(
order_id int primary key,
customer_id int,
product_id int,
quantity int,
price decimal(10,2),order_date date,foreign key(customer_id) references customers (customer_id),
foreign key (product_id) references products(product_id));
INSERT INTO customers VALUES
(101, 'Ayush', 'Ranchi'),
(102, 'Rohan', 'Delhi'),
(103, 'Neha', 'Mumbai'),
(104, 'Priya', 'Delhi'),
(105, 'Aman', 'Pune'),
(106, 'Sara', 'Mumbai'),
(107, 'Karan', 'Ranchi'),
(108, 'Meena', 'Kolkata'),
(109, 'Vikram', 'Chennai'),
(110, 'Anjali', 'Delhi');
INSERT INTO products VALUES
(1, 'Keyboard', 'Electronics'),
(2, 'Mouse', 'Electronics'),
(3, 'Notebook', 'Stationery'),
(4, 'Headphones', 'Electronics'),
(5, 'Pen Pack', 'Stationery'),
(6, 'USB Cable', 'Electronics'),
(7, 'Backpack', 'Accessories'),
(8, 'Desk Lamp', 'Electronics'),
(9, 'Diary', 'Stationery'),
(10, 'Water Bottle', 'Accessories');
INSERT INTO orders VALUES
(1, 101, 1, 1, 1500, '2025-01-02'),
(2, 102, 2, 2, 500, '2025-01-03'),
(3, 101, 3, 4, 60, '2025-01-05'),
(4, 103, 4, 1, 2500, '2025-01-06'),
(5, 104, 5, 10, 20, '2025-01-08'),
(6, 102, 6, 3, 200, '2025-01-09'),
(7, 103, 1, 2, 1500, '2025-02-01'),
(8, 105, 7, 1, 1200, '2025-02-02'),
(9, 106, 4, 1, 2500, '2025-02-03'),
(10, 107, 3, 5, 60, '2025-02-04'),
(11, 101, 2, 1, 500, '2025-02-10'),
(12, 104, 1, 1, 1500, '2025-02-12'),
(13, 106, 5, 20, 20, '2025-02-15'),
(14, 102, 4, 1, 2500, '2025-03-01'),
(15, 105, 6, 2, 200, '2025-03-03'),
(16, 108, 8, 1, 1800, '2025-03-05'),
(17, 109, 9, 3, 150, '2025-03-07'),
(18, 110, 10, 2, 300, '2025-03-08'),
(19, 101, 7, 1, 1200, '2025-03-10'),
(20, 103, 8, 1, 1800, '2025-03-12'),
(21, 104, 3, 6, 60, '2025-03-15'),
(22, 105, 2, 1, 500, '2025-03-18'),
(23, 106, 6, 2, 200, '2025-03-20'),
(24, 107, 10, 1, 300, '2025-03-22'),
(25, 110, 4, 1, 2500, '2025-03-25');
