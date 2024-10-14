# **Pizza Runner Business Analysis**

# **Project Overview**
Danny launched Pizza Runner after noticing an increasing demand for pizzas. 
Danny wants to expand his new Pizza Empire. 
So he started recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters to customers.

Danny had a few years of experience as a Data Scientist, he prepared an entity relationship diagram of his database design but requires further assistance to clean his data and apply some calculations so he could optimize Pizza Runner’s operations.

The Case Study is going to provide insights on Pizzas, Runner and customer experiences, ingredients, and pricing strategies to Danny.


## **Entity Relationship Diagram**
![image](https://github.com/user-attachments/assets/e3f14b62-cdad-4f7a-a7e0-b5601155d85c)

## **Table 1: runners**
The runners table shows the registration_date for each new runner.



## **Table 2: customer_orders**
Customer pizza orders are captured in the customer_orders table with 1 row for each  pizza that is part of the order.

The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.

Note that customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!

The exclusions and extras columns will need to be cleaned up before using them in your queries.

## **Table 3: runner_orders**
After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

## **Table 4: pizza_names**
At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!

## **Table 5: pizza_recipes**
Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

## **Table 6: pizza_toppings**
This table contains all of the topping_name values with their corresponding topping_id value


# **Case Study Questions**
This case study has LOTS of questions - they are broken up by area of focus including:

- Pizza Metrics
- Runner and Customer Experience
- Ingredient Optimisation
- Pricing and Ratings

# **Pizza Metrics**

![{675C3617-B0A1-4FEC-A55E-6DB86A7DC30D}](https://github.com/user-attachments/assets/68826853-119e-4da5-9707-969edf8ecba6)

# **INSIGHTS-Pizza Metrics**
➡️ 14 pizzas were ordered in 10 orders.          
➡️ Runner-1 has made the most successful deliveries followed by Runner-2.            
➡️ 9 Meatlovers and 3 Vegetarian-type pizzas are successfully delivered.             
➡️ Order-4 has ordered the most Meatlovers pizzas and order-5 ordered only Vegetarian type.          
➡️ Maximum number of pizzas delivered is 3 for order-4.            
➡️ 6 Pizza orders made changes and 6 with no change.                
➡️ Only 1 pizza order had both exclusions and extras.                 
➡️ Higher orders are placed during hours 13,18,21 and 23.                                  
➡️ During weekdays most orders are placed on day 4 and day 7.        

     
# **Runner and Customer Experience**

![{3F664A18-70D2-49FF-8371-D0165AA8E143}](https://github.com/user-attachments/assets/440b7731-e860-4bc4-aa76-a1498f02e6b5)

# **INSIGHTS-Runner and Customer Experience**

➡️ 3 Runners signed up for the first week.                     
➡️ An average runner- 3 takes 10 minutes to pick up the pizza, runner-1 takes 15 minutes to pick up the pizza, and runner-2 takes 15 minutes to pick up the pizza 
        
➡️ Per order on average pizza runners have to travel 18.8 KM for order delivery.         


# **Ingredient Optimisation**

![{DD3C2194-D26A-41EE-BCD3-C326FE7AC015}](https://github.com/user-attachments/assets/36150d09-e0a5-4363-8180-8e50eb633a4a)

# **INSIGHTS-Ingredient Optimisation**

➡️ Cheese and Mushrooms are the standard ingredients for both pizzas.           
➡️ The commonly added extra’s to the pizzas is Bacon.              
➡️ The most common exclusion is Cheese.               
➡️ Cheese and Mushrooms are the highly used ingredients in terms of quantity.               

# **Pricing and Ratings**

![{308BC8D7-F54F-447A-83E5-378249258E0F}](https://github.com/user-attachments/assets/e67e972d-2a34-4a89-aa6b-a988c9db63cc)

# **INSIGHTS-Pricing and Ratings**

➡️ If a Meat Lovers pizza costs $12 and a Vegetarian costs $10 and there were no charges for changes  runner-1 makes $70,runner-2 makes $56, and runner-3 makes $12.                   
➡️ If there was an additional $1 charge for any pizza extras runner-1 makes $72,runner-2 makes $59, and runner-3 makes $13.              
➡️ On average each runner had spent 41.36$ for the delivery charge. The Gross Profit made by each runners is  runner-1 earned $ 44.20,runner-2 made $20.90, and runner-3 made $9.00.          


# Recommendations

- Increase production and resources on weekend days, and produce more meat-lovers pizza.
  
- Introduce time-based promotions or discounts during off-peak hours to balance demand and maximize sales.
  
- Implement route optimization tools and GPS tracking to guide runners along the fastest delivery routes, reducing delivery fees.
  
- Streamline kitchen workflows for larger orders to maintain preparation efficiency.
  
- Update the menu to offer pre-built customizable options.
  
- Avoid Cheese in Meat-lovers Pizza since it is mostly excluded.
  
- Analyze the reasons behind cancellation orders to identify pain points.                


















