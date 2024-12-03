--Create Database
REATE DATABASE Retail_store
--Create table
CREATE TABLE retail_sales (
transactions_id int,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15), 
age int, 
category varchar(15)
quantiy int, 
price_per_unit float,
cogs float,
total_sale float
);
--Find Null Value
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL ;

--Delete Null Value
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05' ;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022
SELECT * 
FROM retail_sales
WHERE category = 'Clothing' 
AND quantiy >= 4
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11' ;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category , SUM(total_sale) AS Total_sales
 FROM retail_sales
 GROUP BY category ;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2)
FROM retail_sales
WHERE category = 'Beauty' ;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000 ;

-- Q.6 Write a SQL query to find the total number of transactions 
--(transaction_id) made by each gender in each category.
SELECT category , gender , COUNT(transactions_id) AS Total_order
FROM retail_sales 
GROUP BY category , gender
ORDER BY category ;

-- Q.7 Write a SQL query to calculate the average sale for each month.
-- Find out best selling month in each year
SELECT order_year, order_month,avg_sales
	FROM
( SELECT 
EXTRACT (YEAR FROM sale_date) AS order_year ,
EXTRACT (MONTH FROM sale_date) AS order_month ,
AVG(total_sale) AS avg_sales,
RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC )AS Rank
FROM retail_sales
GROUP BY 
         EXTRACT (YEAR FROM sale_date) ,
         EXTRACT (MONTH FROM sale_date) ) AS t
WHERE Rank = 1 ;
		 
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id , SUM(total_sale) AS total_ravenue
FROM retail_sales
GROUP BY customer_id
ORDER BY total_ravenue DESC
LIMIT 5 ;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category , COUNT(DISTINCT customer_id) AS Unique_cust
FROM retail_sales
GROUP BY category ;

-- Q.10 Write a SQL query to create each shift and number of orders
-- (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales
  AS 
 ( SELECT * ,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN'Afternoon'
		ELSE 'Evening'
	END AS Shift
FROM retail_sales ) 

SELECT Shift,
		COUNT(*) AS total_orders
		FROM hourly_sales
GROUP BY Shift

	