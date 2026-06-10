
-- Q1 What is the Financial statement of the website for the last month?
SELECT
	ROUND(SUM(price * quantity),2) AS Total_revenue,
    ROUND(SUM(price * quantity * discount_percentage/100),2) AS Total_discount_amount,
    ROUND(SUM(price * quantity),2) - ROUND(SUM(price * quantity * discount_percentage/100),2) AS Revenue_after_discount,
    ROUND(SUM(price * quantity * tax_percentage),2) AS Total_tax_amount,
    ROUND(SUM(price * quantity),2) - ROUND(SUM(price * quantity * discount_percentage/100),2) - ROUND(SUM(price * quantity * tax_percentage),2) AS Revenue_after_taxes,
    ROUND(SUM(delivery_charges),2) AS Total_delivery_charges,
    ROUND(SUM(price * quantity),2) - ROUND(SUM(price * quantity * discount_percentage/100),2)- ROUND(SUM(price * quantity * tax_percentage),2) - ROUND(SUM(delivery_charges),2) AS Net_profit
FROM
	performance; 
-- Q2 what is the number of total sales?
SELECT SUM(quantity) AS Total_number_of_sales FROM performance;

-- Q3 What are the highest 5 product categories of revenue?
SELECT product_category, ROUND(SUM(price * quantity),2) AS Revenue_by_category FROM  performance GROUP BY product_category ORDER BY Revenue_by_category DESC LIMIT 5;


-- Q4 What is the most 5 expensive products sold in the last months?
SELECT 
    subquery.product_name,
    subquery.price
FROM
	(
SELECT
	*,
    ROW_NUMBER() OVER(PARTITION BY product_name ORDER BY price DESC) AS Ranking
FROM
	performance
) subquery
WHERE Ranking IN(1)
ORDER BY price DESC
LIMIT 5;

-- Q5 What is the total number of customers bought from the website last months?

SELECT COUNT(DISTINCT(customer_id)) AS Number_of_customers FROM performance;

-- Q6 What are the number of Male vs Female customers bought from the website last months?

SELECT gender, COUNT(DISTINCT(customer_id)) AS Number_of_customers FROM performance GROUP BY gender;

-- Q7 Depend on the last months purchases, How many customers their relationship with us is 12 months or more?
SELECT 
    COUNT(DISTINCT(customer_id)) AS Number_of_loyal_customers
FROM
	performance
WHERE tenure_months >= 12;

-- Q8 Based on last month purchases, How many customers purchased based on their location?
 SELECT
	location,
    COUNT(DISTINCT(customer_id)) AS Number_of_customers
FROM
	performance
GROUP BY 
	location;
-- Q9 what is the total revenue we got by each state?
SELECT
	location,
    ROUND(SUM(price * quantity),2) AS Total_revenue_in_USD
FROM
	performance
GROUP BY location;

-- Q10 Segment customers into New, Existing and Loyal based on their tenure of months.
WITH customer_type AS
(
SELECT
	DISTINCT(customer_id),
    tenure_months,
    CASE
    WHEN tenure_months < 2 THEN 'New'
    WHEN tenure_months BETWEEN 2 AND 11 THEN 'Existing'
    ELSE 'Loyal'
    END AS customer_segment
FROM
	performance
)
SELECT
	customer_segment,
    COUNT(*) AS Number_of_customers
FROM
	customer_type
GROUP BY customer_segment;

-- Q11 What are the top 5 most purchased products within each product category?
WITH item_counts AS
(
SELECT
	product_category,
    product_name,
    COUNT(customer_id) AS total_orders,
	ROW_NUMBER() OVER(PARTITION BY product_category ORDER BY COUNT(customer_id) DESC) AS item_rank
FROM
	performance
GROUP BY product_category, product_name
)
SELECT
	item_rank,
	product_name,
	product_category,
	total_orders
FROM 
	item_counts
WHERE item_rank <= 5;

-- Q12 What are the most 5 coupon codes used by our customers?
SELECT
	coupon_code,
    COUNT(customer_id) AS total_orders
FROM
	performance
GROUP BY coupon_code
ORDER BY COUNT(customer_id) DESC
LIMIT 5;

-- Q13 What are the total sales by each product category?
SELECT 
	product_category,
    SUM(quantity) AS Number_of_product_sold
FROM
	performance
GROUP BY 
	product_category
ORDER BY Number_of_product_sold DESC;












