CREATE DATABASE dannys_diner_db;

CREATE TABLE sales (
  `customer_id` VARCHAR(1),
  `order_date` DATE,
  `product_id` INT
);

INSERT INTO sales
  (`customer_id`, `order_date`, `product_id`)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 
SELECT * FROM sales;

CREATE TABLE menu (
  `product_id` INTEGER,
  `product_name` VARCHAR(5),
  `price` INTEGER
);

INSERT INTO menu
  (`product_id`, `product_name`, `price`)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
SELECT * FROM menu;

CREATE TABLE members (
  `customer_id` VARCHAR(1),
  `join_date` DATE
);

INSERT INTO members
  (`customer_id`, `join_date`)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
SELECT * FROM members;

--------------------------------------------------------------------------------------------------------------------------------------------
/* Case Study Questions */
--------------------------------------------------------------------------------------------------------------------------------------------
-- 1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, SUM(m.price) AS total_amount 
FROM  sales s
JOIN  menu m
	ON s.product_id=m.product_id
GROUP BY s.customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------

-- 2. How many days has each customer visited the restaurant?

SELECT  customer_id, COUNT(DISTINCT order_date) AS days 
FROM sales
GROUP BY customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------

-- 3. What was the first item from the menu purchased by each customer?

WITH CTE AS (
SELECT s.customer_id,s.product_id,m.product_name,
ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS num
FROM sales s 
JOIN  menu m 
ON s.product_id=m.product_id)
SELECT customer_id,product_name
FROM CTE
WHERE num=1;

--------------------------------------------------------------------------------------------------------------------------------------------

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name,COUNT(*) AS purchase_count
FROM sales s 
JOIN menu m
ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;


--------------------------------------------------------------------------------------------------------------------------------------------

-- 5. Which item was the most popular for each customer?

WITH CTE AS (
SELECT s.customer_id,m.product_name,COUNT(product_name) AS product_count,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY COUNT(product_name) DESC) AS num
FROM sales s 
JOIN menu m
ON s.product_id=m.product_id
GROUP BY s.customer_id,m.product_name)
SELECT customer_id,product_name
FROM CTE
WHERE num=1;

--------------------------------------------------------------------------------------------------------------------------------------------

-- 6. Which item was purchased first by the customer after they became a member?

WITH CTE AS (
SELECT s.customer_id,s.order_date,s.product_id,m2.product_name,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS num
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id
JOIN menu m2
ON s.product_id=m2.product_id
WHERE s.order_date > m.join_date)
SELECT customer_id,product_name
FROM CTE
WHERE num=1;



--------------------------------------------------------------------------------------------------------------------------------------------

-- 7. Which item was purchased just before the customer became a member?

WITH CTE AS (
SELECT s.customer_id, s.order_date, s.product_id,m2.product_name,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ) AS num
FROM sales s
LEFT JOIN members m
ON s.customer_id = m.customer_id
JOIN menu m2
ON s.product_id=m2.product_id
WHERE s.order_date < m.join_date)
SELECT customer_id,product_name
FROM CTE
WHERE num=1;

--------------------------------------------------------------------------------------------------------------------------------------------

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id,COUNT(s.product_id) AS Total_items, SUM(m.price) AS Spent_amount
FROM sales s
JOIN menu m
ON s.product_id=m.product_id
JOIN members m2
ON s.customer_id=m2.customer_id
WHERE s.order_date < m2.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH CTE AS (
SELECT s.customer_id,m.product_name,SUM(m.price) AS Spent_amount,
CASE
WHEN product_name="sushi" THEN SUM(m.price)*20
ELSE SUM(m.price)*10
END AS Points
FROM sales s
JOIN menu m
ON s.product_id=m.product_id
GROUP BY s.customer_id,m.product_name)
SELECT customer_id,SUM(Points) AS Points
FROM CTE
GROUP BY customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January?

WITH CTE AS (
SELECT s.customer_id,s.order_date,m2.join_date,m.product_name,m.price,
CASE
WHEN s.order_date BETWEEN m2.join_date AND DATE_ADD(m2.join_date, INTERVAL 6 DAY) THEN m.price*20
WHEN m.product_name = "sushi" THEN 2*10*m.price
ELSE m.price*10
END AS Initial_points
FROM sales s
JOIN menu m 
ON s.product_id=m.product_id
JOIN members m2
ON s.customer_id=m2.customer_id
WHERE MONTH(s.order_date)=1
ORDER BY s.customer_id,s.order_date,m2.join_date)
SELECT customer_id,SUM(Initial_points) AS Points
FROM CTE
GROUP BY customer_id
ORDER BY Customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------
-- Bonus Questions

--  creating basic data tables

SELECT s.customer_id,s.order_date,m.product_name,m.price,
IF(s.order_date>=m2.join_date ,"Y","N") AS member
FROM sales s
LEFT JOIN menu m 
ON s.product_id=m.product_id
LEFT JOIN members m2
ON s.customer_id=m2.customer_id
ORDER BY s.customer_id,s.order_date,m.product_name;

--------------------------------------------------------------------------------------------------------------------------------------------

-- Ranking of customers excluding non-member purchases

WITH CTE AS (
SELECT s.customer_id,s.order_date,m.product_name,m.price,
IF(s.order_date>=m2.join_date ,"Y","N") AS member
FROM sales s
LEFT JOIN menu m 
ON s.product_id=m.product_id
LEFT JOIN members m2
ON s.customer_id=m2.customer_id
ORDER BY s.customer_id,s.order_date,m.product_name)
SELECT *,
CASE
WHEN  member="Y" THEN RANK() OVER(PARTITION BY customer_id,member ORDER BY order_date) 
ELSE "NULL"
END AS Ranking
FROM CTE;

-- --------------------------------------------------------------------------------------------------------------------------------------------
