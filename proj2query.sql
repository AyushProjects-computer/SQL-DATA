-- 1) Show all orders where quantity>=3
Select order_id,quantity from orders where quantity>=3;
-- 2) Find total number of orders
Select count(order_id) from orders;
-- 3) Find total revenue
Select sum(quantity*price) as totalrevenue from orders;
-- 4) Find average order value
Select avg(quantity*price) as avg_order_value from orders;
-- 5) Show total revenue per customer
Select sum(quantity*price) as totrev,customer_id from orders group by customer_id;
-- 6) Show total revenue per customer but only for orders placed after 1st march
Select sum(quantity*price) as totrev,customer_id from orders where order_date>'2025-03-01' group by customer_id;
-- 7) Show customers who placed more than 2 orders after 1st march
Select customer_id,count(order_id) as totalorders from orders where order_date>'2025-03-01' group by customer_id 
having count(order_id)>2;
-- 8) Show each order with order_id,customer_name,city
Select o.order_id,c.customer_name,c.city from customers c join orders o on c.customer_id=o.customer_id;
-- 9) Total revenue by city
Select sum(o.quantity*o.price) as totalrevenue,c.city from customers c join orders o 
on c.customer_id=c.customer_id group by c.city;
-- 10) Show order details
Select o.order_id,c.customer_name,p.product_name,p.category,o.quantity*o.price as revenue from customers c
join orders o on c.customer_id=o.customer_id join products p on p.product_id=o.product_id;
-- 11) list customers who never placed an order
Select c.customer_name,o.order_id from customers c left join orders o on c.customer_id=o.customer_id where o.order_id is null;
-- 12) FInd customers who placed more than three orders
Select c.customer_name,count(o.order_id) as numorder from customers c join orders o on c.customer_id=o.customer_id group by c.customer_name
having count(o.order_id)>3;
-- 13) Find total revenue per city but only for orders placed in march 2025
Select sum(o.quantity*o.price) as totalrevenue,c.city from customers c join orders o on c.customer_id=o.customer_id
 where o.order_date>='2025-03-01' and o.order_date <'2025-04-01' group by c.city;
 -- 14) Find top 2 cities by revenue in march 2025
Select TOP 2
c.city,sum(o.quantity*o.price) as totalrevnue from orders o join customers c on c.customer_id=o.customer_id
where o.order_date>='2025-03-01' and o.order_date<'2025-04-01' group by c.city order by totalrevnue desc;
-- 15) Latest order per customer
Select o.order_id,o.order_date,o.customer_id,row_number() over(partition by o.customer_id order by o.order_date desc) as rn from orders o;
-- 16) Rank customers by total revenue
with ranko as(Select c.customer_name,sum(o.quantity*o.price) as totrev from orders o join customers c on o.customer_id=c.customer_id
group by c.customer_name)Select customer_name,totrev,dense_rank() over(order by totrev desc) as rn from ranko;
-- 17) Running total revenue
with runtot as (Select o.order_date,sum(o.quantity*o.price) as dailyrev from orders o group by o.order_date)
Select dailyrev,order_date,sum(dailyrev) over(order by order_date) as rrev from runtot order by order_date;
-- 18) Rank of city based on revenue
with ranking as(Select c.city,sum(o.quantity*o.price) as totrev from orders o join customers c on c.customer_id=o.customer_id group by c.city)
Select totrev,city,dense_rank() over(order by totrev desc) as city_rank from ranking;
-- 19) For each month find top city by revenue
with monthly_city_rev as (Select c.city,sum(o.quantity*o.price) as revenue,format(order_date,'yyyy-MM') as ordermonth from orders o join customers c
on c.customer_id=o.customer_id group by format(o.order_date,'yyyy-MM'),c.city),ranked as (Select ordermonth,city,revenue,dense_rank() over(partition by ordermonth
order by revenue desc) as city_rank from monthly_city_rev)Select ordermonth,city,revenue,city_rank from ranked where city_rank =1 order by ordermonth;
-- 20) Classify orders as bulk,normal
Select order_id,quantity, case when quantity>=5 then 'Bulk' else 'Nomral' end as order_type from orders;
-- 21) Classify customers based on number of orders
Select c.customer_name,count(o.order_id) as totalorders,case when count(o.order_id)>3 then 'frequent' when count(o.order_id) between 2 and 3 then 'Occasional' else 'One-Time'
end as customer_type from orders o join customers c on o.customer_id=c.customer_id group by c.customer_name;
-- 22) Classify each month performance
Select sum(o.quantity*o.price) as totrev,format(order_date,'yyyy-MM') as ordermonth,case when sum(o.quantity*o.price)>=7000 then 'Strong' when sum(o.quantity*o.price) between 
3000 and 6999 then 'Average' else 'Weak' end as performance_label from orders o group by format(order_date,'yyyy-MM') order by ordermonth; 
-- 23) Find customers where city is missing
Select customer_id,city from customers where city is null;
-- 24) Show customer_name and city but replace null city with unknown
 Select customer_name,coalesce(city,'UNKNOWN') as city from customers;
-- 25) Find orders where pice is negative
Select * from orders where price<0;
-- 26) Find customers who appear more than once
Select customer_name,city from customers group by customer_name,city 
having count(*)>1;
-- 27) Find orders that have customer_id not present in customers table
Select o.order_id,c.customer_id from orders o left join customers c
on c.customer_id=o.customer_id where c.customer_id is null;
-- 28) Show revenue percent contribution by product category
Select p.category,sum(o.quantity*o.price) as revenue,round(100.0*sum(o.quantity*o.price)/sum(sum(o.quantity*o.price)) over(),2)
as pct_of_total from orders o join products p on p.product_id=o.product_id group by p.category;
-- 29) Show total_orders,orders with revenue>=1500, orders with revenue < 1500
Select count(*) as totalorders,sum(case when quantity*price>=1500 then 1 else 0 end) as high_value_orders,
sum(case when quantity*price<1500 then 1 else 0 end) as low_value_orders from orders;
-- 30) Pivot style revenue columns for cities
Select sum(case when c.city='Delhi' then o.quantity*o.price else 0 end) as delhi_revenue,sum(case when c.city='Mumbai' then o.quantity*o.price else 0 end) 
as delhi_mumbai, sum(case when c.city='Ranchi' then o.quantity*o.price else 0 end) as ranchi_revenue from orders o join customers c 
on c.customer_id=o.customer_id;
-- 31) Show city,totalrevenue,percentoftotal,performancelabel
with cityrev as (Select c.city,sum(o.quantity*o.price) as rev from orders o join customers c on c.customer_id=o.customer_id group by c.city)
Select city,rev as totrev,round(100.0*rev/sum(rev) over(),2) as pctotal,case when rev>=7000 then 'Strong Market' when rev between 3000 and 6999 then 
'Growing Market' else 'Small Market' end as performance_label from cityrev order by rev desc;