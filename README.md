# SQL Project Portfolio
 
**Title**: Retail Sales Analysis  
**Database**: `sales`

The creation of this project is intended to demonstrate SQL skills and techniques commonly used by data analysts to explore, clean, and analyze retail sales data. In this project, you will build a retail sales database, perform exploratory data analysis (EDA), and answer specific business questions using SQL queries. This project is useful for building a strong foundation in data analysis using SQL.

## Project Steps

1. **Database Making**: Create a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

a. **How many sales we have?**
```sql
SELECT COUNT(*) as total_sales FROM retail_sales;
```
b.**How many unique customers we have?** 
```sql
SELECT COUNT(DISTINCT(customer_id)) as total_customers FROM retail_sales;
```
c.**What product categories do we sell?**
```sql
SELECT DISTINCT(category) FROM retail_sales;
```
d. **Finding Null Values**:
```sql
SELECT * FROM retail_sales
WHERE 
	transactions_id ISNULL OR 
	sale_date ISNULL OR 
	sale_time ISNULL OR
  customer_id ISNULL OR 
	gender ISNULL OR 
	category ISNULL OR 
	quantity ISNULL OR
	price_per_unit ISNULL OR 
	cogs ISNULL OR 
	total_sale ISNULL;
```
e. **Handling Null Values**:
```sql
DELETE FROM retail_sales
WHERE 
	transactions_id ISNULL OR 
	sale_date ISNULL OR 
	sale_time ISNULL OR
  customer_id ISNULL OR 
	gender ISNULL OR 
	category ISNULL OR 
	quantity ISNULL OR
	price_per_unit ISNULL OR 
	cogs ISNULL OR 
	total_sale ISNULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieve all columns for sales made on 2022-11-02**:
```sql
SELECT * FROM retail_sales
	WHERE sale_date = '2022-11-02';
```

2. **Retrieve all transactions where the category is 'Electronics' and the quantity sold is more than 4 in the month of March 2022**:
```sql
SELECT *
FROM retail_sales 
	WHERE 
	category = 'Electronics' 
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-03'
	AND 
	quantity >= 4;
```

3. **Calculate the total sales for each category**:
```sql
SELECT category, SUM(total_sale) as total_sales
FROM retail_sales 
GROUP BY category;
```

4. **Find the average age of the customers who purchased items from the 'Clothing' category**:
```sql
SELECT category, ROUND(AVG(age),2) as average_age
FROM retail_sales
WHERE category = 'Clothing'
GROUP BY category;
```

5. **Find all transactions where the total sales is greater than 1000**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

6. **find the total number of transaction made by each gender in each category**:
```sql
SELECT category, gender, COUNT(transactions_id) as num_trans
FROM retail_sales
GROUP BY 1,2
ORDER BY category, gender;
```

7. **calculate the average sale for each month. Find out best selling month each year**:
```sql
SELECT year, month, average FROM
(SELECT 
	EXTRACT (YEAR FROM sale_date) as year, 
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as average,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) = 1 as rank
FROM retail_sales
GROUP BY 1,2) as t1 
WHERE rank = '1';
```

8. **find the top 5 customers based on the highest total sales**:
```sql
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;
```

9. **find the number of unique customers who purchased item form each category**:
```sql
SELECT COUNT(DISTINCT(customer_id)), category
FROM retail_sales
GROUP BY category;
```

10. **create each shift and number of orders (Morning <= 12, Afternoon Between 12 and 17, Evening >= 17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project is included in my portfolio to highlight the SQL skills that are crucial for data analyst positions. If you have any questions, suggestions, or are interested in collaborating, don’t hesitate to reach out!

## Author

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!


