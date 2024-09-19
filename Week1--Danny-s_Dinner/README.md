# Danny's Diner Analysis

## Project Overview
**Project Title** : Danny's Diner Analysis   
Database :- `dannys_diner_db`

## **Introduction**
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen. 

Danny’s Diner is in need of  assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.


## **Problem Statement**

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.
Danny has shared with you 3 key datasets for this case study:
sales,members,menu


**Skills** :-  
* Aggregate functions
* Window functions
* Row_number
* Between
* CTE 
* Joins
* Case Statement
* Where clause
* Group by clause
* Order by clause
* Limit

## Objectives

1. **Set up database**: Create and populate a retail sales database with the provided sales data.
2. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named  `dannys_diner_db`.
- **Table Creation**:
* `sales` :- This table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
* `menu` :- Theis table maps the product_id to the actual product_name and price of each menu item.

* `members` :- The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.

```sql
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
```

### 2. Data Analysis & Findings

**1.What is the total amount each customer spent at the restaurant?**
```sql
SELECT s.customer_id, SUM(m.price) AS total_amount 
FROM  sales s
JOIN  menu m
	ON s.product_id=m.product_id
GROUP BY s.customer_id;
```

2.How many days has each customer visited the restaurant?
```sql
SELECT  customer_id, COUNT(DISTINCT order_date) AS days 
FROM sales
GROUP BY customer_id;
```

3.What was the first item from the menu purchased by each customer?
```sql
WITH CTE AS (
SELECT s.customer_id,s.product_id,m.product_name,
ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS num
FROM sales s 
JOIN  menu m 
ON s.product_id=m.product_id)
SELECT customer_id,product_name
FROM CTE
WHERE num=1;
```

4.What is the most purchased item on the menu and how many times was it purchased by all customers?
```sql
SELECT m.product_name,COUNT(*) AS purchase_count
FROM sales s 
JOIN menu m
ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;
```

5.Which item was the most popular for each customer?
```sql
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
```

6.Which item was purchased first by the customer after they became a member?
```sql
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
```

7.Which item was purchased just before the customer became a member?
```sql
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
```

8.What is the total items and amount spent for each member before they became a member?
```sql
SELECT s.customer_id,COUNT(s.product_id) AS Total_items, SUM(m.price) AS Spent_amount
FROM sales s
JOIN menu m
ON s.product_id=m.product_id
JOIN members m2
ON s.customer_id=m2.customer_id
WHERE s.order_date < m2.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
```

9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
```sql
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
```

10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```sql
WITH CTE AS (
SELECT s.customer_id,s.order_date,m2.join_date,m.product_name,SUM(m.price) AS Spent_amount,
CASE
WHEN s.order_date BETWEEN m2.join_date AND DATE_ADD(m2.join_date, INTERVAL 7 DAY) THEN SUM(m.price)*20
ELSE SUM(m.price)*10
END AS Initial_points
FROM sales s
JOIN menu m 
ON s.product_id=m.product_id
JOIN members m2
ON s.customer_id=m2.customer_id
WHERE MONTH(s.order_date)=1
GROUP BY s.customer_id,s.order_date,m2.join_date,m.product_name
ORDER BY s.customer_id,s.order_date)
SELECT customer_id,SUM(Initial_points) AS Points
FROM CTE
GROUP BY customer_id;
```
**Bonus Questions**
```sql
--  creating basic data tables

SELECT s.customer_id,s.order_date,m.product_name,m.price,
IF(s.order_date>=m2.join_date ,"Y","N") AS member
FROM sales s
LEFT JOIN menu m 
ON s.product_id=m.product_id
LEFT JOIN members m2
ON s.customer_id=m2.customer_id
ORDER BY s.customer_id,s.order_date,m.product_name;
```

**Ranking of customers excluding non-member purchases**

```sql
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
```

## Findings


## Reports


