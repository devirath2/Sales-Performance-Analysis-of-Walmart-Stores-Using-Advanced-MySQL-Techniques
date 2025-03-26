create database project ;
use project ;

select * from walmart ;

alter table walmart change column `Date` sales_date varchar(100);

update walmart SET sales_date = str_to_date(sales_date, '%d-%m-%Y');
alter table walmart modify sales_date date ;
select year(sales_date), month(sales_date),day(sales_date),dayname(sales_date) from walmart ;

/* Task 1: Identifying the Top Branch by Sales Growth Rate (6 Marks)
Walmart wants to identify which branch has exhibited the highest sales growth over time. Analyze the total sales
for each branch and compare the growth rate across months to find the top performer. */
 
create view growth1 as 
with branch_group as (
select round(sum(Total),2) as total_sales, Branch,
month(sales_date) as month_name from walmart 
group by Branch,month_name order by total_sales desc )
select total_sales,lead(total_sales,1,"Last Record")
over ( partition by Branch order by total_sales desc) as next_month_sales,
lag(total_sales,1,"First_record") over ( partition by Branch order by total_sales desc) as previous_month_sales, branch,month_name

from branch_group ;

SELECT total_sales, month_name, 
abs(round(((previous_month_sales - total_sales) / nullif(previous_month_sales,0)) * 100,2)) 
as sales_difference_percentage, branch  FROM growth1 order by sales_difference_percentage desc Limit 1  ;

/* Task 2: Finding the Most Profitable Product Line for Each Branch (6 Marks)
 Walmart needs to determine which product line contributes the highest profit to each branch.The profit margin
 should be calculated based on the difference between the gross income and cost of goods sold. */
 
with cte as( select `Product line`,`gross income` ,branch, row_number() over
 ( partition by branch order by `gross income` desc,Total desc) as rnk from walmart )
 select * from cte where rnk=1 ;
 
/*  Task 3: Analyzing Customer Segmentation Based on Spending (6 Marks)
 Walmart wants to segment customers based on their average spending behavior. Classify customers into three
 tiers: High, Medium, and Low spenders based on their total purchase amounts */
 
with cte as (select `Customer ID` , sum(total) as Spending from walmart
group by `Customer ID`), cte2 as(
select `Customer ID`,Spending,NTILE(3) over (
 order by Spending desc) as classify from cte )
 select `Customer ID`, round(Spending,2) as Spendings, case when 
 classify=1 then 'High_spender'
 when classify=2 then 'middle_spender'
 else 'low_spender' end as classified from cte2 order by `Customer ID`;
 
 /* Task 4: Detecting Anomalies in Sales Transactions (6 Marks)
Walmart suspects that some transactions have unusually high or low sales compared to the average for the
product line. Identify these anomalies.*/

with records as 
( select round(avg(total),2) as avg_total, round(stddev(total),2) as standard_deviations,
`Product line`from walmart group by `Product line`)
, sales_scores as 
(select w.`Invoice ID`,w.`Product line`,w.total,round(((w.total-r.avg_total)/r.standard_deviations),2) as scores
 from walmart w join records r on w.`Product line`=r.`Product line`)
 select * from sales_scores where abs(scores)>3
 order by scores desc;
 
 
 /* Task 5: Most Popular Payment Method by City (6 Marks)
Walmart needs to determine the most popular payment method in each city to tailor marketing strategies. */

with cte1 as(
select Payment,count(*) as payment_count, City from walmart
group by City, Payment order by payment_count desc), cte2 as(
select Payment, payment_count, City, row_number() over(partition by City
order by payment_count desc) as ranking from cte1 )
select * from cte2 where ranking=1;

/* Task 6: Monthly Sales Distribution by Gender (6 Marks)
Walmart wants to understand the sales distribution between male and female customers on a monthly basis. */

select Gender, monthname(sales_date) as month_name,month(sales_date) as mnth ,round(sum(Total),2) as Total_sales
from walmart group by Gender,month_name,mnth order by mnth asc;

/* Task 7: Best Product Line by Customer Type (6 Marks)
Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal). */

-- ranked on basis of count of sales.
with cte1 as (
select `Customer type`,`Product line`,count(*) as sales_count, round(sum(Total),2) as total_sales,
round(avg(Total),2) as Avg_total, round(max(Total),2) as max_sales, round(min(Total),2) as min_sales 
from walmart group by `Customer type`, `Product line` order by sales_count desc ),cte2 as(
select `Customer type`, `Product line`,sales_count,total_sales,
avg_total,max_sales,min_sales ,row_number() over (
partition by `Customer type` order by sales_count desc) as ranking from cte1 )
select * from cte2 where ranking=1 ;

/* Task 8: Identifying Repeat Customers (6 Marks)
Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30days). */

select `Customer ID`,Year(sales_date) as sales_year, monthname(sales_date) as sales_month,month(sales_date) as monthnum,
count(*) as Purchase_count from walmart where sales_date between '2019-01-01' and '2019-01-31'
 group by `Customer ID` ,sales_month,sales_year,monthnum having Purchase_count >1 
order by `Customer ID`;

/* Task 9: Finding Top 5 Customers by Sales Volume (6 Marks)
Walmart wants to reward its top 5 customers who have generated the most sales Revenue */

select `Customer ID`,round(sum(`gross income`),2) as revenue , count(*) as total_sales_count from walmart
group by `Customer ID` order by revenue desc limit 5;

/* Task 10: Analyzing Sales Trends by Day of the Week (6 Marks)
Walmart wants to analyze the sales patterns to determine which day of the week
brings the highest sales. */

select dayname(sales_date) as day_name, count(*) as sales_count,
round(sum(Total),2) as total_sales from walmart group by day_name order by total_sales desc ;
