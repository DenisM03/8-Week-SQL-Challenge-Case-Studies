CREATE SCHEMA pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners 
(
`runner_id` INTEGER,
`registration_date` DATE
);

DROP TABLE runners;

INSERT INTO runners
(`runner_id`, `registration_date`)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

SELECT * FROM runners;

DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders 
(
`order_id` INTEGER,
`customer_id` INTEGER,
`pizza_id` INTEGER,
`exclusions` VARCHAR(4),
`extras` VARCHAR(4),
`order_time` TIMESTAMP
);

INSERT INTO customer_orders
(`order_id`, `customer_id`, `pizza_id`, `exclusions`, `extras`, `order_time`)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  `order_id` INTEGER,
  `runner_id` INTEGER,
  `pickup_time` VARCHAR(19),
  `distance` VARCHAR(7),
  `duration` VARCHAR(10),
  `cancellation` VARCHAR(23)
);

INSERT INTO runner_orders
  (`order_id`, `runner_id`, `pickup_time`, `distance`, `duration`, `cancellation`)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  `pizza_id` INTEGER,
  `pizza_name` TEXT
);

INSERT INTO pizza_names
  (`pizza_id`, `pizza_name`)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  `pizza_id` INTEGER,
  `toppings` TEXT
);

INSERT INTO pizza_recipes
  (`pizza_id`, `toppings`)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  `topping_id` INTEGER,
  `topping_name` TEXT
);

INSERT INTO pizza_toppings
(`topping_id`, `topping_name`)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

-----------------------------------------------------------------------------------------------------------------
-- Data Cleaning and Data Preparation
------------------------------------------------------------------------------------------------------------------
-- Cleaning exclusions and extras columns from customer_orders table.

SELECT *
FROM customer_orders
WHERE exclusions='null' OR exclusions='' OR extras='null' OR extras='';
  
UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions = 'null' OR exclusions='';

UPDATE customer_orders
SET extras = NULL
WHERE extras = 'null' OR extras='';

-- Cleaning runner_orders table.

-- Checking Datatypes
DESC runner_orders;

SELECT *
FROM runner_orders;

UPDATE runner_orders
SET distance = REPLACE(distance, 'km', '');

UPDATE runner_orders
SET duration = REPLACE(duration, 'mins', '');

UPDATE runner_orders
SET duration = REPLACE(duration, 'minutes', '');

UPDATE runner_orders
SET duration = REPLACE(duration, 'minute', '');

ALTER TABLE runner_orders
MODIFY pickup_time DATETIME;

ALTER TABLE runner_orders
MODIFY distance INT,
MODIFY duration INT;

UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null';

UPDATE runner_orders
SET distance = NULL
WHERE distance = 'null';

UPDATE runner_orders
SET duration = NULL
WHERE duration = 'null';

UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation = 'null' OR cancellation = '' ;

------------------------------------------------------------------------------------------------------------------
-- A.Pizza Metrics
------------------------------------------------------------------------------------------------------------------

-- 1.How many pizzas were ordered?

SELECT COUNT(pizza_id) AS Total_pizzas
FROM customer_orders;

-- 2.How many unique customer orders were made?

SELECT customer_id, COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders
GROUP BY customer_id;

SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders;

-- 3.How many successful orders were delivered by each runner?

SELECT ro.runner_id,COUNT(DISTINCT ro.order_id) AS Succesful_orders
FROM runner_orders ro
JOIN runners r 
ON ro.runner_id=r.runner_id
WHERE cancellation IS NULL
GROUP BY ro.runner_id;

-- 4.How many of each type of pizza was delivered?

SELECT p.pizza_name, COUNT(*) AS Pizza_delivered
FROM customer_orders co 
JOIN runner_orders ro 
ON co.order_id=ro.order_id
JOIN pizza_names p
ON co.pizza_id=p.pizza_id
WHERE ro.cancellation IS NULL
GROUP BY p.pizza_name;

-- 5.How many Vegetarian and Meatlovers were ordered by each customer?

SELECT co.customer_id,p.pizza_name, COUNT(*) AS Orders
FROM customer_orders co
JOIN pizza_names p
ON co.pizza_id=p.pizza_id
GROUP BY co.customer_id,p.pizza_name
ORDER BY co.customer_id,p.pizza_name;

-- 6.What was the maximum number of pizzas delivered in a single order?

SELECT co.order_id, COUNT(*) AS Orders
FROM customer_orders co 
JOIN runner_orders ro 
ON co.order_id=ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.order_id
ORDER BY Orders DESC
LIMIT 1;

-- 7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT 
    SUM(CASE 
            WHEN (co.exclusions IS NOT NULL OR co.extras IS NOT NULL) THEN 1 
            ELSE 0 
        END) AS Pizzas_with_1_change,
    SUM(CASE 
            WHEN (co.exclusions IS NULL AND co.extras IS NULL) THEN 1 
            ELSE 0 
        END) AS Pizzas_with_no_change
FROM customer_orders co
JOIN runner_orders ro
    ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL;


-- 8.How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(*) AS Orders
FROM runner_orders ro 
JOIN customer_orders co 
ON ro.order_id=co.order_id
WHERE co.exclusions AND co.extras IS NOT NULL AND ro.cancellation IS NULL;

-- 9.What was the total volume of pizzas ordered for each hour of the day?

WITH CTE AS (
SELECT *,HOUR(order_time) AS `Hour`
FROM customer_orders)
SELECT `Hour`,COUNT(*) AS Orders
FROM CTE
GROUP BY `Hour`
ORDER BY `Hour`;

-- 10.What was the volume of orders for each day of the week?

WITH CTE AS (
SELECT *,DAYOFWEEK(order_time) AS Day_of_week
FROM customer_orders)
SELECT Day_of_week,COUNT(*) AS Orders
FROM CTE
GROUP BY Day_of_week;

------------------------------------------------------------------------------------------------------------------------------
-- B. Runner and Customer Experience
------------------------------------------------------------------------------------------------------------------------------

-- 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT COUNT(*) Runners_signed
FROM runners
WHERE registration_date <= DATE_ADD("2021-01-01", INTERVAL 7 DAY);

-- 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT ro.runner_id,
ROUND(AVG(TIMESTAMPDIFF(MINUTE,co.order_time, ro.pickup_time))) AS avg_time_in_minutes
FROM runner_orders ro 
JOIN customer_orders co
ON ro.order_id=co.order_id
WHERE ro.cancellation IS NULL
GROUP BY ro.runner_id;

-- 3.Is there any relationship between the number of pizzas and how long the order takes to prepare?


WITH CTE AS (
SELECT ro.order_id,ro.runner_id,
TIMESTAMPDIFF(MINUTE,co.order_time, ro.pickup_time) AS time_taken
FROM customer_orders co
JOIN runner_orders ro
ON co.order_id=ro.order_id
WHERE ro.cancellation IS NULL)
SELECT time_taken AS Order_preparation_time, COUNT(*) AS Orders
FROM CTE
GROUP BY time_taken
ORDER  BY time_taken;

-- 4.What was the average distance travelled for each customer?

SELECT co.customer_id, ROUND(AVG(ro.distance)) AS Avg_distance_in_KM
FROM customer_orders co
JOIN runner_orders ro 
ON co.order_id=ro.order_id
GROUP BY co.customer_id;

-- 5.What was the difference between the longest and shortest delivery times for all orders?

WITH CTE AS (
SELECT co.order_id,ro.runner_id,ro.duration
FROM runner_orders ro
JOIN customer_orders co
ON ro.order_id=co.order_id
WHERE ro.cancellation IS NULL)
SELECT order_id,
MAX(duration) AS longest_delivery_time_in_minutes,
MIN(duration) AS shortest_delivery_time_in_minutes
FROM CTE
GROUP BY order_id;


-- 6.What was the average speed for each runner for each delivery and do you notice any trend for these values?

WITH CTE AS (
SELECT ro.*,(ro.distance/ro.duration) AS Speed_KM_per_minute
FROM runner_orders ro
JOIN customer_orders co
ON ro.order_id=co.order_id
WHERE ro.cancellation IS NULL)
SELECT order_id, ROUND(AVG(Speed_KM_per_minute),3) AS Avg_Speed_KM_per_minute
FROM CTE
GROUP BY order_id;

-- 7.What is the successful delivery percentage for each runner?

WITH CTE1 AS (
SELECT co.order_id,co.customer_id,r.runner_id,ro.pickup_time,ro.cancellation
FROM  customer_orders co
JOIN  runner_orders ro
ON co.order_id=ro.order_id
RIGHT JOIN runners r
ON ro.runner_id=r.runner_id),
CTE2 AS (
SELECT runner_id , COUNT(order_id) AS Total_orders
FROM CTE1 
GROUP BY runner_id),
CTE3 AS 
(
SELECT runner_id , COUNT(order_id) AS Total_successfull_orders
FROM CTE1 
WHERE cancellation IS NULL
GROUP BY runner_id
)
SELECT t2.runner_id,
ROUND((Total_successfull_orders/Total_orders)*100) AS successful_delivery_percentage
FROM CTE2 t2
JOIN CTE3 t3
ON t2.runner_id=t3.runner_id;

-----------------------------------------------------------------------------------------------------------------------
-- C. Ingredient Optimisation
-----------------------------------------------------------------------------------------------------------------------

-- 1.What are the standard ingredients for each pizza?

SELECT topping_name
FROM pizza_toppings
WHERE topping_id IN (
WITH RECURSIVE SplitToppings AS (
  SELECT
    pizza_id,
    TRIM(SUBSTRING_INDEX(toppings, ',', 1)) AS topping_id,
    CASE
      WHEN LOCATE(',', toppings) > 0 THEN TRIM(SUBSTRING(toppings, LOCATE(',', toppings) + 1))
      ELSE NULL
    END AS rest
  FROM pizza_recipes
  UNION ALL
  SELECT
    pizza_id,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS topping_id,
    CASE
      WHEN LOCATE(',', rest) > 0 THEN TRIM(SUBSTRING(rest, LOCATE(',', rest) + 1))
      ELSE NULL
    END AS rest
  FROM SplitToppings
  WHERE rest IS NOT NULL AND rest != ''
)
SELECT
	topping_id
FROM
  SplitToppings
GROUP BY
  topping_id
HAVING
  COUNT(DISTINCT pizza_id) = 2);  -- This ensures we get only toppings that appear in both pizzas

-- 2.What was the most commonly added extra?

SELECT topping_name
FROM pizza_toppings
WHERE topping_id IN (
WITH RECURSIVE Splitextras AS (
  SELECT
    pizza_id,
    TRIM(SUBSTRING_INDEX(extras, ',', 1)) AS topping_id,
    CASE
      WHEN LOCATE(',', extras) > 0 THEN TRIM(SUBSTRING(extras, LOCATE(',', extras) + 1))
      ELSE NULL
    END AS rest
  FROM customer_orders
  UNION ALL
  SELECT
    pizza_id,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS topping_id,
    CASE
      WHEN LOCATE(',', rest) > 0 THEN TRIM(SUBSTRING(rest, LOCATE(',', rest) + 1))
      ELSE NULL
    END AS rest
  FROM Splitextras
  WHERE rest IS NOT NULL AND rest != ''
)
SELECT topping_id
FROM
  Splitextras
WHERE topping_id IS NOT NULL
GROUP BY topping_id
HAVING COUNT(DISTINCT pizza_id)>1);


-- 3.What was the most common exclusion?
SELECT topping_name
FROM pizza_toppings
WHERE topping_id IN (
WITH RECURSIVE Splitexclusions  AS (
  SELECT
    pizza_id,
    TRIM(SUBSTRING_INDEX(exclusions, ',', 1)) AS topping_id,
    CASE
      WHEN LOCATE(',', exclusions) > 0 THEN TRIM(SUBSTRING(exclusions, LOCATE(',', exclusions) + 1))
      ELSE NULL
    END AS rest
  FROM customer_orders
  UNION ALL
  SELECT
    pizza_id,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS topping_id,
    CASE
      WHEN LOCATE(',', rest) > 0 THEN TRIM(SUBSTRING(rest, LOCATE(',', rest) + 1))
      ELSE NULL
    END AS rest
  FROM Splitexclusions
  WHERE rest IS NOT NULL AND rest != ''
)
SELECT topping_id
FROM Splitexclusions
WHERE topping_id IS NOT NULL
GROUP BY topping_id
HAVING COUNT(pizza_id)>1);


-- 4.Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

SELECT co.order_id,co.customer_id,
CASE
	WHEN co.pizza_id=1 AND co.exclusions IS NULL AND co.extras IS NULL THEN "Meat Lovers"   
    WHEN co.pizza_id=1 AND co.exclusions=3 AND  co.extras IS NOT NULL THEN "Meat Lovers - Exclude Beef"
    WHEN co.pizza_id=1 AND co.exclusions IS NULL AND co.extras=1 THEN "Meat Lovers - Extra Bacon"
    WHEN co.pizza_id=1 AND co.exclusions=4   AND co.extras IS NULL THEN "Meat Lovers - Exclude Cheese"
    WHEN co.pizza_id=1 AND co.exclusions=4   AND co.extras=1 THEN "Meat Lovers - Exclude Cheese,Extra Bacon"    
    WHEN co.pizza_id=1 AND co.exclusions=2   AND co.extras=1 THEN "Meat Lovers - Exclude Bacon Mushrooms,Extra Bacon Cheese"
	WHEN co.pizza_id=2 AND co.exclusions IS NULL AND co.extras IS NULL THEN "Vegetable Lovers" 
    WHEN co.pizza_id=2 AND co.exclusions=4   AND co.extras IS NULL THEN "Vegetable Lovers - Exclude Cheese"
    WHEN co.pizza_id=2 AND co.exclusions IS NULL  AND co.extras=1 THEN "Vegetable Lovers - Extra Cheese"
    ELSE null
END AS Customer_classification
FROM customer_orders co 
JOIN pizza_names p 
ON co.pizza_id=p.pizza_id;

-- 5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

WITH CTE_incrediants as (
WITH SplitToppings AS (
  SELECT
    pr.pizza_id,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(pr.toppings, ',', numbers.n), ',', -1)) AS topping_id
  FROM
    (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12) AS numbers
  JOIN pizza_recipes pr
    ON CHAR_LENGTH(pr.toppings) - CHAR_LENGTH(REPLACE(pr.toppings, ',', '')) >= numbers.n - 1
)
SELECT
  pr.pizza_id,
  GROUP_CONCAT(pt.topping_name ORDER BY pt.topping_name ASC) AS ingredients
FROM
  SplitToppings st
JOIN pizza_toppings pt
  ON st.topping_id = pt.topping_id
JOIN pizza_recipes pr
  ON st.pizza_id = pr.pizza_id
GROUP BY
  pr.pizza_id)
  SELECT co.order_id,co.customer_id,c.ingredients
  FROM customer_orders co
  JOIN CTE_incrediants c 
  ON co.pizza_id = c.pizza_id;


-- 6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

 WITH SplitToppings AS ( 
  SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(pr.toppings, ',', numbers.n), ',', -1)) AS topping_id
  FROM
    (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12) AS numbers
  JOIN pizza_recipes pr
    ON CHAR_LENGTH(pr.toppings) - CHAR_LENGTH(REPLACE(pr.toppings, ',', '')) >= numbers.n - 1
  JOIN customer_orders co 
  ON pr.pizza_id=co.pizza_id)
SELECT
  pt.topping_name,
  COUNT(st.topping_id) AS quantity_used
FROM
  SplitToppings st
JOIN pizza_toppings pt
  ON st.topping_id = pt.topping_id
GROUP BY
  pt.topping_name
ORDER BY
  quantity_used DESC;

-------------------------------------------------------------------------------------------------------------------
-- D. Pricing and Ratings
--------------------------------------------------------------------------------------------------------------------

-- 1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- - how much money has Pizza Runner made so far if there are no delivery fees?

WITH CTE_costs AS (
SELECT co.order_id,co.pizza_id,ro.runner_id,
CASE
	WHEN co.pizza_id=1 THEN 12
	ELSE 10
END AS Cost
FROM customer_orders co
JOIN runner_orders ro 
ON co.order_id=ro.order_id
WHERE ro.cancellation IS NULL
)
SELECT runner_id,SUM(Cost) AS Sales
FROM CTE_costs
GROUP BY runner_id;

-- 2.What if there was an additional $1 charge for any pizza extras?Add cheese is $1 extra

WITH CTE_additional_costs AS (
SELECT co.order_id,co.pizza_id,ro.runner_id,
CASE
	WHEN co.pizza_id=1 AND co.extras IS NULL THEN 12
    WHEN co.pizza_id=2 AND co.extras IS NULL THEN 10
	WHEN co.pizza_id=1 AND co.extras=1 AND LENGTH(co.extras)=1  THEN 12+1
	WHEN co.pizza_id=2 AND co.extras=1 AND LENGTH(co.extras)=1 THEN 12+1
	WHEN co.pizza_id=1 AND LENGTH(co.extras)>1 THEN 12+1+1
	WHEN co.pizza_id=2 AND LENGTH(co.extras)>1 THEN 12+1+1
END AS Cost
FROM customer_orders co
JOIN runner_orders ro 
ON co.order_id=ro.order_id
WHERE ro.cancellation IS NULL
ORDER BY co.pizza_id
)
SELECT runner_id,SUM(Cost) AS Sales
FROM CTE_additional_costs
GROUP BY runner_id;


-- 3.The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset
-- - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

CREATE TABLE Ratings
(
`order_id` INTEGER,
`customer_id` INTEGER,
`pizza_id` INTEGER,
`order_time` TIMESTAMP,
`runner_id` INTEGER,
`pickup_time` VARCHAR(19),
`distance` VARCHAR(7),
`duration` VARCHAR(10),
`cancellation` VARCHAR(23),
`Ratings` FLOAT
);

INSERT INTO ratings
SELECT *
FROM (
SELECT co.order_id,co.customer_id,co.pizza_id,co.order_time,ro.runner_id,ro.pickup_time,ro.distance,ro.duration,ro.cancellation,
CASE
	WHEN ro.duration<=10  THEN 5
	WHEN ro.duration<=ro.distance  THEN 5
	WHEN ro.duration>=10 AND ro.distance<=15  THEN 4
    WHEN ro.duration=20 AND ro.distance<=15   THEN 4
    WHEN ro.duration>20 AND ro.distance<=30  THEN 3.5
	WHEN ro.duration>=30 AND ro.distance<=25   THEN 3
END AS Ratings
FROM customer_orders co 
LEFT JOIN runner_orders ro 
ON co.order_id=ro.order_id
WHERE ro.cancellation IS NULL
) AS subquery;

SELECT * FROM ratings;


-- 4.Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id,order_id,runner_id,rating,order_time,pickup_time,Time between order and pickup,Delivery duration,Average speed,Total number of pizzas

SELECT customer_id,order_id,runner_id,ratings,order_time,pickup_time,duration,distance,
ROUND(TIMESTAMPDIFF(MINUTE,order_time,pickup_time)) AS Time_diferrence,
ROUND(AVG(distance/duration),2) AS Average_speed,
COUNT(pizza_id) AS Total_pizzas
FROM ratings
GROUP BY customer_id,order_id,runner_id,ratings,order_time,pickup_time,duration,distance;


-- 5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- - how much money does Pizza Runner have left over after these deliveries?

WITH CTE_Gross_profit AS (
SELECT co.order_id,co.pizza_id,ro.runner_id,
CASE
	WHEN co.pizza_id=1 THEN 12
	ELSE 10
END AS Cost,
(ro.distance * 0.30) AS Delivery_fees
FROM customer_orders co
JOIN runner_orders ro 
ON co.order_id=ro.order_id
WHERE ro.cancellation IS NULL
)
SELECT runner_id,SUM(Cost) AS Cost,SUM(Delivery_fees) AS Delivery_fees,
(SUM(Cost)-SUM(Delivery_fees)) AS Gross_profit
FROM CTE_Gross_profit
GROUP BY runner_id;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
