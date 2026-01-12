create table order_details(
order_details_id integer Primary key,
order_id integer,
pizza_id varchar(100),
quantity integer,

foreign key (order_id) references orders(order_id),
foreign key (pizza_id) references pizzas(pizza_id)
);

BULK INSERT order_details
FROM 'C:\temp pizza\pizza_sales\order_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

------------------------------------------
create table orders(
order_id integer Primary key,
Date_ varchar(50),
time_ time);

BULK INSERT Orders
from 'C:\temp pizza\pizza_sales\orders.csv'
WITH (
    Firstrow=2,
    fieldterminator= ',',
    rowterminator= '0x0a' 
);
--------------------------------------------------------

create table pizza_types(
pizza_type_id varchar(100) Primary key,
name varchar (100),
category varchar(100),
ingredients varchar (500)
FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id))

BULK INSERT pizza_types
from 'C:\temp pizza\pizza_sales\pizza_types.csv'
WITH (
    Firstrow=2,
    fieldterminator= ',',
    rowterminator= '0x0a' 
);
drop table pizza_types
----------------------------------------------------------
create table pizzas(
pizza_id varchar (100) Primary key,
pizza_type_id varchar (100),
size varchar (50),
price decimal

FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id))

BULK INSERT pizzas
from 'C:\temp pizza\pizza_sales\pizzas.csv'
WITH (
    Firstrow=2,
    fieldterminator= ',',
    rowterminator= '0x0a' 
);
----------------------------------------------------------------
--Basic:
--1).Retrieve the total number of orders placed.
select * from orders
--2).Total number of orders
SELECT COUNT(*) AS total_orders_sold
FROM orders;
--3).Calculate the total revenue generated from pizza sales.
SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM order_details
JOIN pizzas
    ON order_details.pizza_id = pizzas.pizza_id;

--4.)Identify the highest-priced pizza.
SELECT TOP 1 pizza_id,
price FROM pizzas
ORDER BY price DESC;

--5.)list of pizzas from most expensive to cheapest. 
select pizza_id ,
price from pizzas
order by price asc;

--6.)Identify the most common pizza size ordered.
select top 1 p.size,
sum(od.quantity)as total_ordered
from order_details od 
join pizzas p on od.pizza_id=p.pizza_id
group by p.size 
order by total_ordered desc;

--7.)Identify the most popular pizza
select top 1 pt.name as pizza_name,
SUM(od.quantity)as total_sold
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by pt.name
order by total_sold desc;

--8.)idetify most unpopular pizza
select top 1 pt.name as pizza_name,
SUM(od.quantity) as total_sold
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by total_sold asc;

--9.)Revenue Analysis (Daily / Monthly / Yearly)
--Daily
select o.date_,
SUM(od.quantity*p.price) as daily_revenue_in_rupees
from orders o
join order_details od 
on o.order_id = od.order_id
join pizzas p 
on od.pizza_id=p.pizza_id
group by o.Date_
order by o.Date_

--Monthly
select 
YEAR(o.Date_) as year,
MONTH(o.date_) as month,
SUM(od.quantity*p.price)as monthly_revenue
from orders o
join order_details od  
on o.order_id=od.order_id
join pizzas p 
on od.pizza_id = p.pizza_id
group by year(o.Date_), month(o.date_)
order by year,month;

--YEARLY
SELECT 
YEAR(o.Date_) AS year,
SUM(od.quantity * p.price) AS yearly_revenue
FROM orders o
JOIN order_details od 
ON o.order_id = od.order_id
JOIN pizzas p 
ON od.pizza_id = p.pizza_id
GROUP BY YEAR(o.Date_)
ORDER BY year;

--10.)Peak Sales Hour
select 
DATEPART(hour,o.time_) as order_hour,
count (o.order_id) as total_orders
from orders o
group by datepart(hour,o.time_)
order by total_orders desc

--11.)Average sales in a DAILY/MONTHLY/YEARLY
--DAILY
SELECT 
o.Date_,
SUM(od.quantity * p.price) / COUNT(DISTINCT o.order_id) AS daily_average_revenue
FROM orders o
JOIN order_details od 
ON o.order_id = od.order_id
JOIN pizzas p 
ON od.pizza_id = p.pizza_id
GROUP BY o.Date_
ORDER BY Date_ asc;

--MONTHLY
select
YEAR(o.date_) AS year,
MONTH(o.date_)as month,
SUM(od.quantity*p.price) / COUNT(distinct o.order_id) as montly_avg_revenue
from orders o
join order_details od on o.order_id = od.order_id
join pizzas p on od.pizza_id = p.pizza_id
group by YEAR (o.date_),
MONTH(o.Date_)
order by year,month

--YEARLY
SELECT 
YEAR(o.Date_) AS year,
SUM(od.quantity * p.price) / COUNT(DISTINCT o.order_id) AS yearly_avg_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY YEAR(o.Date_)
ORDER BY year;
