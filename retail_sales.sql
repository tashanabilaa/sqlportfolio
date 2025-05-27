-- Find Null Values
SELECT * FROM retail_sales
WHERE 
	transactions_id ISNULL 
	OR 
	sale_date ISNULL	
	OR 
	sale_time ISNULL
	OR 
	customer_id ISNULL
	OR 
	gender ISNULL
	OR 
	category ISNULL
	OR 
	quantity ISNULL
	OR
	price_per_unit ISNULL
	OR 
	cogs ISNULL
	OR 
	total_sale ISNULL;
	
-- Handling Null Values
DELETE FROM retail_sales
WHERE 
	transactions_id ISNULL 
	OR 
	sale_date ISNULL	
	OR 
	sale_time ISNULL
	OR 
	customer_id ISNULL
	OR 
	gender ISNULL
	OR 
	category ISNULL
	OR 
	quantity ISNULL
	OR
	price_per_unit ISNULL
	OR 
	cogs ISNULL
	OR 
	total_sale ISNULL;

-- Data Exploration
-- 1. How many sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- 2. How many unique customers we have? 
SELECT COUNT(DISTINCT(customer_id)) as total_customers FROM retail_sales;

-- 3. What product categories do we sell?
SELECT DISTINCT(category) FROM retail_sales;

-- Data Analysis and Business Key Problems 
-- 1. Retrieve all columns for sales made on 2022-11-02
SELECT * FROM retail_sales
	WHERE sale_date = '2022-11-02';

-- 2. Retrieve all transactions where the category is 'Electronics' and the quantity sold is more than 4 in the month of March 2022
SELECT *
FROM retail_sales 
	WHERE 
	category = 'Electronics' 
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-03'
	AND 
	quantity >= 4;
	
-- 3. Calculate the total sales for each category 
SELECT category, SUM(total_sale) as total_sales
FROM retail_sales 
GROUP BY category; 

-- 4. Find the average age of the customers who purchased items from the 'Clothing' category
SELECT category, ROUND(AVG(age),2) as average_age
FROM retail_sales
WHERE category = 'Clothing'
GROUP BY category;

-- 5. Find all transactions where the total sales is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. find the total number of transaction made by each gender in each category
SELECT category, gender, COUNT(transactions_id) as num_trans
FROM retail_sales
GROUP BY 1,2
ORDER BY category, gender;

-- 7. calculate the average sale for each month. Find out best selling month each year
SELECT year, month, average FROM
(SELECT 
	EXTRACT (YEAR FROM sale_date) as year, 
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as average,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) = 1 as rank
FROM retail_sales
GROUP BY 1,2) as t1 
WHERE rank = '1';

-- 8. find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- 9. find the number of unique customers who purchased item form each category 
SELECT COUNT(DISTINCT(customer_id)), category
FROM retail_sales
GROUP BY category;

-- 10. create each shift and number of orders (Morning <= 12, Afternoon Between 12 and 17, Evening >= 17)
WITH hourly_sale
as (
SELECT total_sale, sale_time,
	CASE 
		WHEN EXTRACT(HOUR From sale_time) <= 12 THEN 'Morning'
		WHEN EXTRACT(HOUR From sale_time) BETWEEN 12 AND 17 THEN 'Afternoon' 
		ELSE 'Evening'
	END as shift
FROM retail_sales
	)
SELECT shift, COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift