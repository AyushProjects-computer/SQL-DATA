use sqlproject
Select * from customers;
select* from orders;
Select * from payments;
-- 1) Total real revenue
Select sum(o.order_amount) as totamt from orders o
where o.order_id in 
(Select distinct p.order_id from payments p 
where p.payment_status='success');
--2) total revenue per customer
Select SUM(o.order_amount) as totamt,o.customer_id from orders o
where o.order_id in
(Select distinct p.order_id from payments p
where p.payment_status='success') group by o.customer_id;
--3)Customers who placed order with payment failed
Select o.customer_id from orders o 
where o.order_id in
(Select p.order_id from payments p  
group by p.order_id 
having sum(case when payment_status='success' then 1 else 0 end)=0); 
--4)Customers who placed order with multiple payment attempts
Select o.customer_id from orders o
where o.order_id in 
(Select p.order_id from payments p
group by p.order_id
having COUNT(*)>1 and 
SUM(case when payment_status='success' then 1 else 0 end)=0);
--5)Customers where payments failed atleast once before success
Select o.customer_id from orders o
where o.order_id in(
Select p.order_id from payments p
join payments p1 on p.order_id=p1.order_id
and p.payment_status='failed' and p1.payment_status='success'
and p.payment_time<p1.payment_time);
--6)Customers whose every order succeeded even if failures
Select o.customer_id from orders o where o.order_id in
(Select p.order_id from payments p group by p.order_id
having COUNT(*)>1
and SUM(case when p.payment_status='success' then 1 else 0 end)=1
and SUM(case when p.payment_status='failed' then 1 else 0 end)>=1);
--7)Customers whose every payment succeeded
Select distinct o.customer_id from orders o
where not exists (Select 1 from
payments p where p.order_id=o.order_id
and p.payment_status='failed');
--8)Customers with atleast one failed payment and eventually succeeded
Select distinct o.customer_id from orders o
where o.order_id in (Select p.order_id from payments p
group by p.order_id having
SUM(case when p.payment_status='failed' then 1 else 0 end)>=1
and
SUM(case when p.payment_status='success' then 1 else 0 end)>=1);
--9)Total orders and paid orders per customerincluding never paid
Select o.customer_id,count(o.order_id) as total_orders,
count(p.order_id) as paid_orders from orders o
left join payments p
on o.order_id=p.order_id
where p.payment_status='success' group by o.customer_id;
--10)Count payment attempts per order include order with no payments
Select o.order_id,Count(*)-
COUNT(p.order_id) as missingattempt,
COUNT(p.order_id) as paymentattempt
from orders o
left join payments p
on o.order_id=p.order_id
group by o.order_id;