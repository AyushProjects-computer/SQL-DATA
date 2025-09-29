-- Find average delivery time per carrier
Select carrier, 
avg(datediff(delivered_date,shipped_date)) as avg_delivery_days
from shipments where delivered_date is not null
group by carrier;
-- Find most popular product category by revenue
 Select p.category,sum(od.quantity*od.unit_price) as revenue
 from order_details od join products p on p.product_id=od.product_id
 join orders o on o.order_id=od.order_id
 where o.status!='Cancelled'
 group by p.category order by revenue desc;
-- Customer Lifetime Value (CLV) summary — for every customer show 
 WITH cust_summary AS (
    SELECT 
        c.customer_id,
        c.name,
        SUM(p.amount) AS total_spent,
        COUNT(DISTINCT o.order_id) AS order_count,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Payments p ON o.order_id = p.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY c.customer_id, c.name
)
SELECT 
    customer_id,
    name,
    total_spent,
    order_count,
    ROUND(total_spent / NULLIF(order_count,0), 2) AS avg_order_value,
    first_order_date,
    last_order_date,
    RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM cust_summary;
-- Find out which customers are repeat buyers (placed more than 1 non-cancelled order) and which are one-time buyers.
 WITH repe AS (
    SELECT 
        c.customer_id,
        c.name,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM Customers c
    JOIN Orders o 
        ON c.customer_id = o.customer_id
    WHERE o.status != 'Cancelled'
    GROUP BY c.customer_id, c.name
)
SELECT 
    customer_id,
    name,
    order_count,
    CASE 
        WHEN order_count > 1 THEN 'Repeat Customer'
        ELSE 'One-time Customer'
    END AS customer_type
FROM repe;

-- Find all customers who purchased products from more than 1 product category.
 WITH categ AS (
    SELECT 
        c.customer_id,
        c.name,
        COUNT(DISTINCT p.category) AS categcount
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Order_details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
    WHERE o.status != 'Cancelled'
    GROUP BY c.customer_id, c.name
)
SELECT 
    customer_id,
    name,
    categcount
FROM categ
WHERE categcount > 1;
-- Rank Customers Within Each Country by Spend
With rankco AS (
    SELECT 
        c.customer_id,
        c.name,
        c.country,
        SUM(p.amount) AS total_spent,
        RANK() OVER (PARTITION BY c.country ORDER BY SUM(p.amount) DESC) AS spend_rank
        FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Payments p ON o.order_id = p.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY c.customer_id, c.name, c.country
)
SELECT 
    country,
    customer_id,
    name,
    total_spent,
    spend_rank
FROM rankco
ORDER BY country, spend_rank;
-- Find which supplier generated the highest total revenue from product sales.
WITH sup AS (
    SELECT 
        s.supplier_id,
        s.supplier_name,
        SUM(od.quantity * od.unit_price) AS total_revenue
    FROM Suppliers s
    JOIN Products p ON s.supplier_id = p.supplier_id
    JOIN Order_details od ON p.product_id = od.product_id
    JOIN Orders o ON od.order_id = o.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY s.supplier_id, s.supplier_name
)
SELECT *
FROM sup
ORDER BY total_revenue DESC
LIMIT 1;
--  Show the total revenue per category, per month (using order_date), excluding cancelled orders.
 With totrev AS (
    SELECT 
        p.category,
        DATE_FORMAT(o.order_date, '%Y-%m') AS month_year,
        SUM(od.quantity * od.unit_price) AS total_revenue
    FROM Products p
    JOIN Order_details od ON p.product_id = od.product_id
    JOIN Orders o ON od.order_id = o.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY p.category, DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    month_year,
    category,
    total_revenue
FROM totrev
ORDER BY month_year, category;
-- Find the percentage of orders delivered late, where a delivery is considered late
WITH pcta AS (
    SELECT
        COUNT(*) AS total_orders,
        SUM(CASE WHEN DATEDIFF(s.delivered_date, s.shipped_date) > 3 THEN 1 ELSE 0 END) AS late_orders
    FROM Shipments s
    JOIN Orders o ON s.order_id = o.order_id
    WHERE o.status != 'Cancelled'
      AND s.delivered_date IS NOT NULL
)
SELECT 
    total_orders,
    late_orders,
    ROUND(late_orders * 100.0 / total_orders, 2) AS late_percentage
FROM pcta;
-- For each carrier, calculate the percentage of on-time deliveries (delivered within ≤3 days of shipping) show the carrier with the highest on-time percentage. 
WITH otpct AS (
    SELECT
        s.carrier,
        COUNT(*) AS total_orders,
        SUM(CASE WHEN DATEDIFF(s.delivered_date, s.shipped_date) <= 3 THEN 1 ELSE 0 END) AS ontime_orders
    FROM Shipments s
    JOIN Orders o ON s.order_id = o.order_id
    WHERE o.status != 'Cancelled'
      AND s.delivered_date IS NOT NULL
    GROUP BY s.carrier
)
SELECT 
    carrier,
    total_orders,
    ontime_orders,
    ROUND(ontime_orders * 100.0 / total_orders, 2) AS ontime_percentage
FROM otpct
ORDER BY ontime_percentage DESC
LIMIT 1;
-- For each carrier, calculate the average shipping cost per order excluding cancelled orders. 
WITH scotpct AS ( 
    SELECT
        s.carrier,
        COUNT(DISTINCT o.order_id) AS total_orders,
        AVG(s.shipping_cost) AS avg_shipping_cost
    FROM Shipments s
    JOIN Orders o ON s.order_id = o.order_id
    WHERE o.status != 'Cancelled'
      AND s.delivered_date IS NOT NULL
    GROUP BY s.carrier
)
SELECT 
    carrier,
    total_orders,
    ROUND(avg_shipping_cost, 2) AS avg_shipping_cost
FROM scotpct
ORDER BY avg_shipping_cost DESC;
-- Show the total revenue per month (based on order_date), excluding cancelled orders.
 WITH rev AS (  
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month_year,
        SUM(p.amount) AS total_rev 
    FROM Orders o 
    JOIN Payments p ON o.order_id = p.order_id 
    WHERE o.status != 'Cancelled'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    month_year,
    total_rev
FROM rev
ORDER BY month_year;
-- Identify the top 10% of customers by total spending.
with loyalconsume as(select c.name,
c.customer_id,
sum(p.amount) as spend
from customers c join 
orders o on c.customer_id=o.customer_id
join payments p on o.order_id=p.order_id
where o.status!='Cancelled'  
group by c.customer_id,c.name),
ranked as(Select name,customer_id,spend,
percent_rank() over(order by spend desc) as percentile from loyalconsume)
Select *
from ranked
where percentile<=0.1
order by spend desc;
-- Show total revenue per country and each country’s % contribution to overall revenue. 
WITH country_rev AS (
    SELECT
        c.country,
        SUM(p.amount) AS total_revenue
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Payments p ON o.order_id = p.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY c.country
)
SELECT
    country,
    total_revenue,
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 2) AS pct_share
FROM country_rev
ORDER BY pct_share DESC;
