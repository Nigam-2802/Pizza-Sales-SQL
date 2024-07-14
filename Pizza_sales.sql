create Database Pizzahut;

Select * from pizzas;

Select * from pizza_types;

create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key (order_id)
);

Select * from orders;

create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key (order_details_id)
);

Select sum(quantity) as total_orders from order_details;

Select count(order_id) as total_number_of_orders from orders;

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),2) AS Total_revenue
    FROM order_details JOIN pizzas
    ON pizzas.pizza_id = order_details.pizza_id;

Select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

Select pizzas.size, count(order_details.quantity) as total_quantity_order
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by size
order by total_quantity_order desc;

Select pizza_types.name, sum(order_details.quantity) as total_orders
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by name
order by total_orders desc
limit 5;

select pizza_types.category, sum(order_details.quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by total_quantity desc;

Select hour(order_time) as hour,count(order_id) as order_count
from orders
group by hour(order_time);

Select category,count(name) 
from pizza_types
group by category;

Select round(avg(quantity),0) from
(Select orders.order_date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date
) as order_quantity;

Select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id =	pizzas.pizza_id
group by pizza_types.name
order by revenue desc
limit 3;

Select pizza_types.category,
 round(sum(order_details.quantity * pizzas.price)/(SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),2) AS Total_revenue
    FROM order_details JOIN pizzas
    ON pizzas.pizza_id = order_details.pizza_id)*100,2) as percentage_contribution
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id =	pizzas.pizza_id
group by pizza_types.category
order by percentage_contribution desc;

Select order_date,round(sum(revenue) over(order by order_date),2)as cum_revenue
from
(select orders.order_date, sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date)as sales;

select name, revenue from 
(Select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <3;