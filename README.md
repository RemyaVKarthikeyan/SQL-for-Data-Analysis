# SQL-for-Data-Analysis
Database Creation, Schema Design, and Query Implementation for Food Service Company in Microsoft SQL Server Management Studio using T-SQL

The dataset includes four related tables, which are provided in four csv files:

The Restaurants.csv file has 130 records and provides Restaurant_id, Name, City, State, Country, Zip_code, Latitude, Longitude, Alcohol_Service, Smoking_Allowed, Price, Franchise, Area and Parking. The Restaurant_id column provides a unique identifier for each hotel.

The Consumers.csv file provides details of 137 different consumers that are enjoying their meal in the restaurants. This includes the Consumer_id, City, State, Country, Latitude, Longitude, Smoker, Drink_Level, Transportation_Method, Marital_Status, Children, Age, Occupation, Budget.

The Ratings.csv file provides a total of 1161 ratings given by consumers. Each row corresponds to Consumer_id, Restaurant_id, Overall_Rating, Food_Rating and Service_Rating. Each rating is linked to restaurant and consumers via their respective id.

The Restaurant_Cuisines consists of 112 records with attributes as Restaurant_id and Cuisine.

For this task, imagine you work as a database consultant for a food service company. The first stage of your task is to create a database and import the four tables from the csv file. You should also add the necessary primary and foreign key constraints to the tables and provide a database diagram in your report which shows the three tables and their relationships. You should create the database with the name FoodserviceDB and the tables with the following names:

a.Restaurant
b.Consumers
c.Ratings
d.Restaurant_Cuisines

You should also leave the column names as they appear in the csv file. This is so we can re-run your code.

1.Write a query that lists all restaurants with a Medium range price with open area, serving Mexican food.

2.Write a query that returns the total number of restaurants who have the overall rating as 1 and are serving Mexican food. Compare the results with the total number of restaurants who have the overall rating as 1 serving Italian food (please give explanations on their comparison)

3. Calculate the average age of consumers who have given a 0 rating to the 'Service_rating' column. (NB: round off the value if it is a decimal)
   
4.Write a query that returns the restaurants ranked by the youngest consumer. You should include the restaurant name and food rating that is given by that customer to the restaurant in your result. Sort the results based on food rating from high to low.

5.Write a stored procedure for the query given as:
Update the Service_rating of all restaurants to '2' if they have parking available, either as 'yes' or 'public'

6.You should also write four queries of your own and provide a brief explanation of the results which each query returns.

You should make use of all of the following at least once:
Nested queries-EXISTS
Nested queries-IN
System functions
Use of GROUP BY, HAVING and ORDER BY clauses
