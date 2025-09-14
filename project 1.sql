-- SQL Retail Sales Analysis - p1

CREATE DATABASE projects;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE projects.retail_sales
	(
		transaction_id INT PRIMARY KEY,
        sale_date DATE,
        saretail_salesle_time TIME,
        customer_id INT,
        gender VARCHAR(15),
        age INT,
        category VARCHAR(15),
        quantiy INT,
        price_per_unit FLOAT,
        cogs FLOAT,
        total_sale FLOAT
    );
    
   SELECT * FROM projects.retail_sales;
    
    
    SELECT * FROM projects.retail_sales
    ORDER BY transaction_id ASC LIMIT 2000;
  
  SELECT 
	count(*)
  FROM projects.retail_sales;



-- Data cleaning 
 
SELECT * FROM projects.retail_sales
WHERE transaction_id IS NULL
	  OR
      sale_date IS NULL
      OR 
      sale_time IS NULL
      OR
      gender IS NULL
      OR 
      category IS NULL
      OR
      quantiy IS NULL 
      OR 
      cogs IS NULL 
      OR total_sale IS NULL;


DELETE FROM projects.retail_sales
WHERE 
	  transaction_id IS NULL
	  OR
      sale_date IS NULL
      OR 
      sale_time IS NULL
      OR
      gender IS NULL
      OR 
      category IS NULL
      OR
      quantiy IS NULL 
      OR 
      cogs IS NULL 
      OR 
      total_sale IS NULL;

-- Data exploration 
-- How many sales we have?
SELECT COUNT(*) AS total_sales FROM projects.retail_sales;

-- How many UNIQUE custmers we have?
SELECT COUNT(DISTINCT(customer_id)) FROM projects.retail_sales;
 
--  How many UNIQUE category we have?
SELECT DISTINCT(category) FROM projects.retail_sales;
    


-- Data Analysis & Business Key Problem & Answers
 
 
-- My analsis and finding
-- Q1. Write a SQL query to retrieve all columns for sales made on 2022-11-05
SELECT * FROM projects.retail_sales
WHERE sale_date = "2022-11-05";

-- Q2. Write a SQL query to retrieve all transaction where the catogory is 'clothing' and
--  the  quantity sold is more than 10 on the month of NOV-22
SELECT *
 FROM projects.retail_sales
 WHERE category = 'clothing'
	AND quantity >= 4
	AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';






-- Q3. Write a SQL  query to calculate the total sales (total_sales) for each category.
SELECT 
	category, 
    SUM(total_sale) AS net_sales, 
    COUNT(*) AS  total_orders 
FROM 
	projects.retail_sales 
GROUP BY
	1;
    
    

-- Q4. Write a SQL query to find the average age of customers who purchased item from the 'beauty' category.
SELECT 
	ROUND(AVG(age),2) AS avg_age
FROM projects.retail_sales
WHERE category = 'Beauty';



-- Q5.  Write a SQL query to find all transaction where the total_sales is greater than 1000.
SELECT * FROM projects.retail_sales
WHERE total_sale >1000;



-- Q6. Write a SQL query to find the total nunber of transactions (transation_id) made by each gender in each category.
SELECT 
	COUNT(*) AS total_transaction,
	gender, 
    category
FROM projects.retail_sales
GROUP BY gender, category;




-- Q7. Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.
SELECT 
	year,
    month,avg_sale_each_month
 FROM
(
SELECT 
    -- date_format(sale_date, '%y-%m') AS months,
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale),2) AS avg_sale_each_month,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_avg_sale
FROM projects.retail_sales
GROUP BY year, month
-- ORDER BY avg_sale_each_month DESC,month;
) AS t1
WHERE rank_avg_sale = 1;






-- Q8. Write  a SQL query to find the top 5 customers on the hoghest total sales.
SELECT
	customer_id,
    SUM(total_sale)
FROM projects.retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;




-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT( DISTINCT(customer_id)) AS count_unique_customer
FROM projects.retail_sales
GROUP BY category;





-- Q10. Write a SQL query to find the customers who purchased all categories. 
SELECT customer_id
FROM projects.retail_sales
WHERE category IN ('Beauty', 'Clothing', 'Electronics')
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = 3;


-- Q11. Write a SQL query to create each shift and number of orders (Example Morning <= 12, afternoon between 12 to 17,evening >17
WITH hourly_sale
AS
(
SELECT 
	 CASE
		WHEN HOUR(sale_time) <12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN  'Afternoon'
        ELSE 'Evening'
	END AS shift
FROM projects.retail_sales
)
SELECT 
	shift,
    COUNT(*) AS total_sales
 FROM hourly_sale
 GROUP BY shift





