-- Create database
CREATE DATABASE Walmart_Sales;

-- Create table
CREATE TABLE Sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- ----------------------------------------------------------------------------------------
-- -------------------------------------- Feature Engeenring ------------------------------

-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Generic ------------------------------------------

-- Q1- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales ;
-- Ans-> this query will return unique cities name


-- Q2- In which city is each branch?
SELECT DISTINCT city , branch
FROM sales ;
-- Ans-> this query will return cities name with their branch 


-- ---------------------------------------------------------------------------------------
-- ------------------------------ Product ------------------------------------------------

-- Q1- How many unique product lines does the data have?
SELECT DISTINCT product_line 
FROM sales ;
-- Ans-> this query will return unique product line e.g.- Food and beverages ,Health and beauty etc

-- Q2- What is the most common payment method?
SELECT payment_method , COUNT(payment_method) AS total_payment
FROM sales
GROUP BY payment_method
ORDER BY total_payment DESC ;
-- this query will return Most common payment method is - cash

-- Q3- What is the most selling product line?
SELECT product_line , COUNT(product_line) AS total_product_sell
FROM sales
GROUP BY product_line
ORDER BY total_product_sell DESC ;
-- this query will return which product line is selling the most e.g- Fashion accessories

-- Q4- What is the total revenue by month?
SELECT month_name ,SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC ;
-- this query will return total revenue of every month 

-- Q5- What month had the largest COGS (cost of goods sold) ?
SELECT month_name , SUM(cogs) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC ;
-- this query will return largest cogs made by which month e.g- January

-- Q6- What product line had the largest revenue?
SELECT product_line , SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;
-- this query will return largest revenue made by which product line  e.g -Food and beverages

-- Q7- What is the city with the largest revenue?
SELECT branch , city , SUM(total) AS total_revenue
FROM sales
GROUP BY branch, city
ORDER BY total_revenue DESC;
-- this query will return largest revenue made by which city along which its branch name 

-- Q8- What product line had the largest VAT (value added tax)?
SELECT product_line, AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;
-- this query will return largest VAT made by which product_line e.g- Home and lifestyle

-- Q9- Which branch sold more products than average product sold?
SELECT branch , SUM(quantity) AS qty
FROM sales
GROUP BY branch 
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales) ;
-- this query will return more product sold by branch e.g- A

-- Q10- What is the most common product line by gender?
SELECT gender, product_line , COUNT(gender) AS total_cnt
FROM sales 
GROUP BY  gender, product_line
ORDER BY total_cnt DESC ;
-- it will return most common gender according to product line
 
-- Q11- What is the average rating of each product line?
SELECT ROUND(AVG(rating), 2) AS avg_rating ,product_line
FROM sales
GROUP BY product_line 
ORDER BY avg_rating DESC;
-- it will return average rating of each product line
-- -----------------------------------------------------------------------------------------
-- -------------------------------------- Sales --------------------------------------------

-- Q1- Number of sales made in each time of the day per weekday
SELECT time_of_day , COUNT(*) AS total_sales
FROM sales
WHERE day_name ="Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC ;
-- this query will return sales made each time of the day as per weekday 

-- Q2- Which of the customer types brings the most revenue?
SELECT customer_type , SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC ;
-- this query will return customer type with most revenue e.g- Members

-- Q3- Which city has the largest tax percent/ VAT (Value Added Tax) ?
SELECT city , ROUND(AVG(VAT),3) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;
-- this query will return city name which has high VAT e.g- Naypyitaw

-- Q4- Which customer type pays the most in VAT?
SELECT customer_type , ROUND(AVG(VAT),3) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;
-- it will return customer type that pays most VAT e.g- Member

-- --------------------------------------------------------------------------------
-- ----------------------------- Customer ------------------------------------------

-- Q1- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales ;
-- this query returns different customer types e.g- normal , member

-- Q2- How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM sales ;
-- this query returns different payment methods e.g Credit card , ewallet ,cash

-- Q3- What is the most common customer type?
SELECT customer_type , COUNT(customer_type) AS total_customer
FROM sales
GROUP BY customer_type 
ORDER BY total_customer DESC; 
-- this query returns no. of the most common customer type

-- Q4- What is the gender of most of the customers?
SELECT gender, COUNT(gender) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC ;
-- this query return the no. of gender of both customer type

-- Q5- What is the gender distribution per branch?
SELECT gender, COUNT(gender) AS gender_count
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_count DESC ;
-- this query return the no. of gender of both customer type in each branch

-- Q6- Which time of the day do customers give most ratings?
SELECT time_of_day , SUM(rating) AS total_rating
FROM sales
GROUP BY time_of_day
ORDER BY total_rating DESC ;
-- this query return time of day when customer give most rating e.g- Evening

-- Q7- Which time of the day do customers give most ratings per branch?
SELECT time_of_day , SUM(rating) AS total_rating
FROM sales
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY total_rating DESC ;
-- -- this query return time of day when customer give most rating per branch

-- Q8- Which day fo the week has the best avg ratings?
SELECT day_name , ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC ;
-- this query return days name with average rating on that day

-- Q9- Which day of the week has the best average ratings per branch?
SELECT day_name , ROUND(AVG(rating), 2) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY avg_rating DESC ;
-- this query return days name with best average rating per each branch




















