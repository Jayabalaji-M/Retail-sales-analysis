-- SQL retail sales analysis - project 

CREATE DATABASE dbo.Retail_Sales_Analysis;
use retail_sales_project;

-- Create schema

CREATE SCHEMA schema_name;

CREATE SCHEMA sales;

-- create table

DROP TABLE IF EXISTS dbo.Retail_Sales_Analysis;
CREATE TABLE dbo.Retail_Sales_Analysis
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

SELECT cogs
FROM Retail_Sales_Analysis

SELECT 
    cogs, 
    SUM(cogs) OVER() AS total_cogs
FROM Retail_Sales_Analysis


SELECT TOP 10 * 
FROM Retail_Sales_Analysis;

SELECT * FROM Retail_Sales_Analysis;
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES;

SELECT COUNT(*) AS total_rows
FROM Retail_Sales_Analysis;


-- DATE CLEANING --
-- checking for nulls
SELECT * FROM Retail_Sales_Analysis
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM Retail_Sales_Analysis
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLORATION --
-- How many  sales we have ?
SELECT COUNT(*) as total_sales FROM Retail_Sales_Analysis;

-- How many unique customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_sales FROM Retail_Sales_Analysis;

SELECT DISTINCT category FROM Retail_Sales_Analysis

--DATA ANALYSIS & Business key problems & answers--

-- Write a sql query to retreive all columns for sales made on '2022-11-05'
SELECT * FROM Retail_Sales_Analysis
WHERE sale_date = '2022-11-05';

--Write a sql query to retrieve all transactions where the category is 'Clothing' and the quantity 
-- sold is more the 3 in the month of nov-2022
SELECT * 
FROM Retail_Sales_Analysis
WHERE
    category = 'Clothing'
    AND quantity >= 3
    AND YEAR(sale_date) = 2022
    AND MONTH(sale_date) = 11;

-- Write a sql query to calculate the total sales (total_sale) for each category.

SELECT
category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM Retail_Sales_Analysis
GROUP BY category

-- Write a SQl query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(age), 2) as avg_age
	FROM Retail_Sales_Analysis
	WHERE category = 'Beauty'

-- Write a sql query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM Retail_Sales_Analysis
WHERE total_sale > 1000
	
--Write a sql query to find the total number of transactions (traansaction_id) made by each gender in each category.

SELECT
	category,
	gender,
COUNT(*) as total_transaction
FROM Retail_Sales_Analysis
GROUP BY
      category,
	  gender
ORDER BY 1 

-- write a sql query to calculate the average sale for each month. Find out best selling month in each year
SELECT
    year,
    month,
    avg_sale
FROM
(
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(
            PARTITION BY YEAR(sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM Retail_Sales_Analysis
    GROUP BY 
        YEAR(sale_date), 
        MONTH(sale_date)
) AS t1
WHERE rnk = 1;
--ORDER BY year, month DESC

-- Write a sql query to find the top 5 customers based on the highest total sales

SELECT TOP 5
customer_id,
SUM(total_sale) as total_sales
FROM Retail_Sales_Analysis
GROUP BY customer_id
ORDER BY 2 DESC
-- LIMIT 5 -- not worked in sql server, but in postgree sql


-- Write a sql query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) as customer
FROM Retail_Sales_Analysis
GROUP BY category

-- Write a sql query to create each shift and number of orders (Example morning <=12, Afternoon Brtween 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM Retail_Sales_Analysis
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;
		
SELECT EXTRACT(HOUR FROM CURRENT_TIME)


-- END OF PROJECT --

