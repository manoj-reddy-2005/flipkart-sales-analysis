use flipkart_db;

# totalsales , totalprofit, and total quantity 
select 
sum(amount) totalsales,
sum(profit) totalprofit,
sum(quantity) totalquantity
from flipkart_details;

#Profit_Margin_Percentage
select 
sum(profit) / sum(amount) * 100 Profit_Margin_Percentage
from flipkart_details;

# SALES BY STATE
select 
o.state,
sum(d.profit) total_profit,
sum(d.amount) total_sales 
from flipkart_details d join flipkart_orders o on 
d.orderid=o.orderid group by o.state order by total_profit desc ;

# TOP 5 CITYS
select 
o.city,
sum(d.amount) total_amount
from flipkart_details d join flipkart_orders o on 
d.orderid=o.orderid group by o.city  
order by total_amount desc limit 5 ;

#SALES BY CATEGORY
select
category,sum(amount) total_sales,sum(profit) total_profit
from flipkart_details
group by category
order by total_sales desc;

#SALES BY SUBCATEGORY
select
subcategory,sum(amount) total_sales,sum(profit) total_profit
from flipkart_details
group by subCategory
order by total_sales desc;


# Total number of orders and total sales by paymentmode
select 
paymentMode,count(*)  total_orders,sum(amount) AS total_Sales
from flipkart_details
group by paymentMode;


# Monthly sales analysis (Year-wise and Month-wise total sales)
select
year(o.orderdate) year, month(o.orderdate)  Month,
sum(d.amount) monthly_sales
from flipkart_orders o
join flipkart_details d
on o.orderID = d.orderid
group by year, month
order by year, month;


# Top 5 product categories generating highest profit
select 
category,sum(profit) total_profit
from flipkart_details
group by category
order by total_profit desc
limit 5;


# Identify subcategories that are generating loss (negative profit)
select 
subcategory,sum(Profit) total_profit
from flipkart_details
group  by subCategory
having total_profit < 0;


# Top 5 customers based on total spending
select 
o.customername,sum(d.amount)  total_spending
from flipkart_orders o
join flipkart_details d
on o.orderID = d.orderid
group by o.customername
order by total_spending desc
limit 5;


# Calculate Average Order Value
select 
sum(d.amount) / count(distinct o.OrderID) avg_order_value
from flipkart_orders o
join flipkart_details d
on o.orderid = d.orderid;


# Daily sales with running cumulative total
select 
o.orderdate,sum(d.amount) as daily_sales,
sum(sum(d.amount)) over (order by o.orderdate) as running_total
from flipkart_orders o
join flipkart_details d
on o.orderid = d.orderid
group by o.orderdate;


# Rank categories based on total sales
select 
category,sum(amount) as total_sales,
rank() over (order by sum(amount) desc) as rank_position
from flipkart_details
group by category;


# Top 3 performing subcategories within each category based on sales
select *
from (
select 
category, subcategory, sum(amount) as total_sales,
rank() over (partition by category order by sum(amount) desc) as rank_pos
from flipkart_details
group by category, subcategory
) ranked
where rank_pos <= 3;
