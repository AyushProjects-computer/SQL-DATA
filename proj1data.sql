use sqlproject;
create table customers (
customer_id int primary key,
customer_name varchar(50),
city varchar(30));
insert into customers values
(1,'Aman','Delhi'),
(2,'Raman','Mumbai'),
(3,'Karan','Bangalore'),
(4,'Neha','Pune'),
(5,'Arjun','Hyderabad'),
(6,'Sanjay','Chandigarh'),
(7,'Rohit','Jaipur'),
(8,'Vikas','Chennai'),
(9,'Ranjit','Patna'),
(10,'Pooja','Indore');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_amount INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(101, 1, 2000, '2025-01-05'),
(102, 1, 1500, '2025-01-06'),
(103, 2, 3000, '2025-01-06'),
(104, 3, 2500, '2025-01-07'),
(105, 4, 1800, '2025-01-07'),
(106, 5, 2200, '2025-01-08'),
(107, 6, 1700, '2025-01-08'),
(108, 7, 2600, '2025-01-09'),
(109, 8, 2100, '2025-01-09'),
(110, 9, 1900, '2025-01-10'),
(111,10, 2400, '2025-01-10'),
(112, 3, 1600, '2025-01-11'),
(113, 4, 2800, '2025-01-11'),
(114, 5, 2300, '2025-01-12'),
(115, 6, 1400, '2025-01-12');

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(20),
    status VARCHAR(20),
    payment_time DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO payments VALUES
(1, 101, 'card',   'failed',   '2025-01-05 10:01:00'),
(2, 101, 'card',   'success',  '2025-01-05 10:03:00'),
(3, 102, 'upi',    'success',  '2025-01-06 11:00:00'),
(4, 103, 'wallet', 'failed',   '2025-01-06 11:30:00'),
(5, 103, 'wallet', 'failed',   '2025-01-06 11:35:00'),
(6, 104, 'card',   'success',  '2025-01-07 09:15:00'),
(7, 105, 'upi',    'failed',   '2025-01-07 10:20:00'),
(8, 106, 'card',   'success',  '2025-01-08 12:10:00'),
(9, 106, 'card',   'success',  '2025-01-08 12:12:00'),
(10,107, 'wallet', 'failed',   '2025-01-08 13:00:00'),
(11,107, 'upi',    'success',  '2025-01-08 13:05:00'),
(12,108, 'card',   'failed',   '2025-01-09 14:00:00'),
(13,109, 'upi',    'success',  '2025-01-09 14:30:00'),
(14,110, 'wallet', 'failed',   '2025-01-10 15:10:00'),
(15,110, 'wallet', 'failed',   '2025-01-10 15:15:00'),
(16,111, 'card',   'success',  '2025-01-10 16:00:00'),
(17,112, 'upi',    'success',  '2025-01-11 09:45:00'),
(18,113, 'card',   'failed',   '2025-01-11 10:00:00'),
(19,113, 'card',   'success',  '2025-01-11 10:05:00'),
(20,114, 'wallet', 'failed',   '2025-01-12 11:00:00'),
(21,115, 'upi',    'failed',   '2025-01-12 12:00:00');
