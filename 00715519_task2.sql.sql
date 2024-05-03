--Task 2 Part 1
-- Create the database
CREATE DATABASE FoodserviceDB;

--Switch to the created database
USE FoodserviceDB; 
GO

--creat table Consumers
CREATE TABLE Consumers (
Consumer_ID nvarchar(10) NOT NULL PRIMARY KEY, 
City nvarchar(20) NOT NULL, 
State nvarchar(20) NOT NULL, 
Country nvarchar(20) NOT NULL,
Latitude decimal(18,10)  NOT NULL,
Longitude decimal(18,10)  NOT NULL,
Smoker varchar(3),
Drink_Level nvarchar(20) NOT NULL,
Transportation_Method nvarchar(20),
Marital_Status nvarchar(50),
Children nvarchar(20),
Age tinyint NOT NULL CHECK (Age BETWEEN 1 AND 100),
Occupation nvarchar(20),
Budget nvarchar(20),
);

--Populate table Consumers
INSERT INTO Consumers (Consumer_ID, City, State, Country, Latitude, Longitude, Smoker, Drink_Level, Transportation_Method, Marital_Status, Children, Age, Occupation, Budget)
SELECT Consumer_ID, City, State, Country, Latitude, Longitude, Smoker, Drink_Level, Transportation_Method, Marital_Status, Children, Age, Occupation, Budget
FROM consumers1;

--DROP TABLE consumers1;

SELECT *
FROM Consumers

--Create table Restaurant
CREATE TABLE Restaurants (
Restaurant_ID int NOT NULL PRIMARY KEY, 
Name nvarchar(100) NOT NULL,
City nvarchar(20) NOT NULL, 
State nvarchar(20) NOT NULL, 
Country nvarchar(20) NOT NULL,
Zip_Code nvarchar(10),
Latitude decimal(18,10)  NOT NULL,
Longitude decimal(18,10)  NOT NULL,
Alcohol_Service nvarchar(20) NOT NULL,
Smoking_Allowed nvarchar(20) NOT NULL,
Price nvarchar(10) NOT NULL,
Franchise nvarchar(4) NOT NULL,
Area nvarchar(10) NOT NULL,
Parking nvarchar(10) NOT NULL, 
);

--Populate table Restaurants
INSERT INTO Restaurants (Restaurant_ID, Name, City, State, Country, Zip_Code, Latitude, Longitude, Alcohol_Service, Smoking_Allowed, Price, Franchise, Area, Parking)
SELECT Restaurant_ID, Name, City, State, Country, Zip_Code, Latitude, Longitude, Alcohol_Service, Smoking_Allowed, Price, Franchise, Area, Parking
FROM restaurants1;

--DROP TABLE restaurants1;

SELECT *
FROM Restaurants;

--Create table Ratings
CREATE TABLE Ratings (
Rating_ID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
Consumer_ID  nvarchar(10) NOT NULL FOREIGN KEY (Consumer_ID) REFERENCES Consumers (Consumer_ID),
Restaurant_ID int NOT NULL FOREIGN KEY (Restaurant_ID) REFERENCES Restaurants (Restaurant_ID),
Overall_Rating tinyint NOT NULL CHECK (Overall_Rating BETWEEN 0 AND 2),
Food_Rating tinyint NOT NULL CHECK (Food_Rating BETWEEN 0 AND 2),
Service_Rating tinyint NOT NULL CHECK (Service_Rating BETWEEN 0 AND 2),
);

--Populate table Ratings
INSERT INTO Ratings (Consumer_ID, Restaurant_ID, Overall_Rating, Food_Rating, Service_Rating)
SELECT Consumer_ID, Restaurant_ID, Overall_Rating, Food_Rating, Service_Rating
FROM ratings1;

--DROP TABLE ratings1;

SELECT *
FROM Ratings;

--Create table Restaurant_cuisines
CREATE TABLE Restaurant_cuisines (
Restaurant_cuisine_ID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
Restaurant_ID int NOT NULL FOREIGN KEY (Restaurant_ID) REFERENCES Restaurants (Restaurant_ID),
Cuisine nvarchar(20) NOT NULL
);

--Populate table Restaurant_cuisines
INSERT INTO Restaurant_cuisines (Restaurant_ID, Cuisine)
SELECT Restaurant_ID, Cuisine
FROM restaurant_cuisines1;

--DROP TABLE restaurant_cuisines1;

SELECT *
FROM Restaurant_cuisines;


--Task 2 Part 1 Q 1
--A query that lists all restaurants with a Medium range price with open area, serving Mexican food.
SELECT R.*
FROM Restaurants R
WHERE R.Price = 'Medium'
AND R.Area = 'Open'
AND EXISTS (
    SELECT 1
    FROM Restaurant_Cuisines RC
    WHERE R.Restaurant_ID = RC.Restaurant_ID
    AND Cuisine = 'Mexican'
);

--A query that lists all restaurants with a Medium range price with open area, serving Mexican food. (Using JOIN Command)
SELECT R.*, RC.Cuisine
FROM Restaurants R
JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
WHERE R.Price = 'Medium'
AND R.Area = 'Open'
AND RC.Cuisine = 'Mexican';



--Task 2 Part 1 Q 2
--Write a query that returns the total number of restaurants who have 
--the overall rating as 1 and are serving Mexican food. 
--Compare the results with the total number of restaurants 
--who have the overall rating as 1 serving Italian food 

-- Count of restaurants with overall rating as 1 serving Mexican food
SELECT COUNT( DISTINCT RC.Restaurant_ID) AS 'Count of restaurants with overall rating as 1 serving Mexican food'
FROM Restaurant_Cuisines RC
WHERE EXISTS (
    SELECT 1
    FROM Ratings Ra
    WHERE Ra.Restaurant_ID = RC.Restaurant_ID
    AND Ra.Overall_Rating = 1
)
AND RC.Cuisine = 'Mexican';


-- Count of restaurants with overall rating as 1 serving Mexican food (Using JOIN commands)
SELECT COUNT(DISTINCT RC.Restaurant_ID) AS 'Count of restaurants with overall rating as 1 serving Mexican food'
FROM Ratings Ra
JOIN Restaurant_Cuisines RC ON Ra.Restaurant_ID = RC.Restaurant_ID
JOIN Ratings R ON R.Restaurant_ID = RC.Restaurant_ID
WHERE Ra.Overall_Rating = 1
AND RC.Cuisine = 'Mexican';

--Names of restaurants with overall rating as 1 serving Mexican food 
SELECT DISTINCT RC.Restaurant_ID, R.Name
FROM Restaurant_Cuisines RC
JOIN Ratings Ra ON Ra.Restaurant_ID = RC.Restaurant_ID
JOIN Restaurants R ON R.Restaurant_ID = RC.Restaurant_ID
WHERE Ra.Overall_Rating = 1
AND RC.Cuisine = 'Mexican';
;

-- Count of restaurants with overall rating as 1 serving Italian food
SELECT COUNT(DISTINCT RC.Restaurant_ID) AS 'Count of restaurants with overall rating as 1 serving Italian food'
FROM Restaurant_Cuisines RC
WHERE EXISTS (
    SELECT 1
    FROM Ratings Ra
    WHERE Ra.Restaurant_ID = RC.Restaurant_ID
    AND Ra.Overall_Rating = 1
)
AND RC.Cuisine = 'Italian';

-- Count of restaurants with overall rating as 1 serving Italian food (Using JOIN commands)
SELECT COUNT(DISTINCT RC.Restaurant_ID) AS 'Count of restaurants with overall rating as 1 serving Italian food'
FROM Ratings Ra
JOIN Restaurant_Cuisines RC ON Ra.Restaurant_ID = RC.Restaurant_ID
JOIN Ratings R ON R.Restaurant_ID = RC.Restaurant_ID
WHERE Ra.Overall_Rating = 1
AND RC.Cuisine = 'Italian';

--Names of restaurants with overall rating as 1 serving Italian food 
SELECT DISTINCT RC.Restaurant_ID, R.Name
FROM Restaurant_Cuisines RC
JOIN Ratings Ra ON Ra.Restaurant_ID = RC.Restaurant_ID
JOIN Restaurants R ON R.Restaurant_ID = RC.Restaurant_ID
WHERE Ra.Overall_Rating = 1
AND RC.Cuisine = 'Italian';


--Task 2 Part 1 Q 3
--Calculate the average age of consumers who have given a 0 rating to the 'Service_rating' column.
--(NB: round off the value if it is a decimal)

--Calulating average age of customers (repetition considered) 
SELECT  ROUND(AVG(C.Age), 0) AS 'Average age of consumers (repetition considered) who have given a 0 rating to the Service_rating column'
FROM Consumers C
INNER JOIN Ratings Ra ON C.Consumer_ID = Ra.Consumer_ID
WHERE Ra.Service_Rating = 0;

--Calculating the count of customers (repetition considered) who have given a 0 rating to the 'Service_rating' column.
SELECT  COUNT(*) AS 'Count of consumers (repetition considered) who have given a 0 rating to the Service_rating column'
FROM Consumers C
INNER JOIN Ratings Ra ON C.Consumer_ID = Ra.Consumer_ID
WHERE Ra.Service_Rating = 0;

--Listing customers (repetition considered) who have given a 0 rating to the 'Service_rating' column.
SELECT  C.Consumer_ID, C.Age, Ra.Service_Rating  
FROM Consumers C
INNER JOIN Ratings Ra ON C.Consumer_ID = Ra.Consumer_ID
WHERE Ra.Service_Rating = 0;

 --Calulating average age of customers (repetition ignored)
SELECT ROUND(AVG(C.Age), 0) AS 'Average age of consumers (repetition ignored) who have given a 0 rating to the Service_rating column'
FROM Consumers C 
WHERE  C.Consumer_ID IN (SELECT DISTINCT Ra.Consumer_ID FROM Ratings Ra
WHERE Ra.Service_Rating = 0
GROUP BY Consumer_ID);

--Calculating the count of customers  (repetition ignored) who have given a 0 rating to the 'Service_rating' column.
SELECT COUNT(C. Consumer_ID) as 'Count of customers  (repetition ignored) who has given a 0 rating to the Service_rating'
FROM Consumers C 
WHERE  C.Consumer_ID IN (SELECT DISTINCT Ra.Consumer_ID FROM Ratings Ra
WHERE Ra.Service_Rating = 0
GROUP BY Consumer_ID);

--Listing customers  (repetition ignored) who have given a 0 rating to the 'Service_rating' column.
SELECT C. Consumer_ID as 'Customer  (repetition ignored) who has given a 0 rating to the Service_rating', C.Age   
FROM Consumers C
WHERE  C.Consumer_ID IN (SELECT DISTINCT Ra.Consumer_ID FROM Ratings Ra
WHERE Ra.Service_Rating = 0
GROUP BY Consumer_ID);

--Calulating average age (Using EXISTS Command)(repetition ignored)
SELECT ROUND(AVG(C.Age), 0) AS 'Average age of consumers who have given a 0 rating to the Service_rating column'
FROM Consumers C
WHERE EXISTS (
    SELECT 1
    FROM Ratings Ra
    WHERE Ra.Consumer_ID = C.Consumer_ID
    AND Ra.Service_Rating = 0
);

--Calulating average age (Using Sub queries) (repetition ignored)
SELECT ROUND(AVG(C.Age), 0) AS 'Average age of consumers who have given a 0 rating to the Service_rating column'
FROM Consumers C
WHERE  C.Consumer_ID IN (SELECT Ra.Consumer_ID FROM Ratings Ra
WHERE Ra.Service_Rating = 0
GROUP BY Consumer_ID);

--Calulating average age (Using format CTE) (repetition ignored)
WITH ConsumerServiceRatingZero AS (
    SELECT Ra.Consumer_ID
    FROM Ratings Ra
    WHERE Ra.Service_Rating = 0
    GROUP BY Ra.Consumer_ID
)
SELECT ROUND(AVG(C.Age), 0) AS [Average age of consumers who have given a 0 rating to the Service_rating column]
FROM Consumers C
WHERE C.Consumer_ID IN (SELECT Consumer_ID FROM ConsumerServiceRatingZero);


Select *
From Consumers

Select *
From Ratings


--Task 2 Part 1 Q 4
--Write a query that returns the restaurants ranked by the youngest consumer. 
--You should include the restaurant name and food rating that is given by that customer to the restaurant in your result. 
--Sort the results based on food rating from high to low.

--First approach - Listing the restaurants and the food rating given by the youngest consumer in the Ratings table. 
--Finding out the youngest consumer
SELECT  TOP 1 Consumer_ID, Age
FROM Consumers
ORDER BY Age ASC;

--First approach - Listing the restaurants and the food rating given by the youngest consumer in the Ratings table. 
SELECT YoungestConsumer.Consumer_ID AS Youngest_Consumer, YoungestConsumer.Age, R.Restaurant_ID,R.Name AS Restaurant_Name, Ra.Food_Rating
FROM Restaurants R
JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
JOIN (
    SELECT TOP 1 Consumer_ID, Age
    FROM Consumers
    ORDER BY Age ASC
) YoungestConsumer ON Ra.Consumer_ID = YoungestConsumer.Consumer_ID
ORDER BY Ra.Food_Rating DESC;

--Second approach - List of all restaurants with food rating given by the youngest consumers from that restaurant
SELECT DISTINCT R.Restaurant_ID, R.Name AS Restaurant_Name, 
                C.Consumer_ID, C.Age, 
                Ra.Food_Rating
FROM Restaurants R
JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
JOIN Consumers C ON Ra.Consumer_ID = C.Consumer_ID
JOIN (
    SELECT R.Restaurant_ID, MIN(C.Age) AS Youngest_Age
    FROM Restaurants R
    JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
    JOIN Consumers C ON Ra.Consumer_ID = C.Consumer_ID
    GROUP BY R.Restaurant_ID
) AS MinAge ON R.Restaurant_ID = MinAge.Restaurant_ID AND C.Age = MinAge.Youngest_Age
ORDER BY Ra.Food_Rating DESC;

--First approach --Same query using INNER JOIN
SELECT YoungestConsumer.Consumer_ID AS Youngest_Consumer, YoungestConsumer.Age, R.Restaurant_ID, R.Name AS Restaurant_Name, Ra.Food_Rating
FROM Restaurants R
INNER JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
JOIN (
    SELECT TOP 1 Consumer_ID, Age
    FROM Consumers
    ORDER BY Age ASC
) YoungestConsumer ON Ra.Consumer_ID = YoungestConsumer.Consumer_ID
ORDER BY Ra.Food_Rating DESC;

--First approach --Same query using RIGHT JOIN
SELECT YoungestConsumer.Consumer_ID AS Youngest_Consumer, YoungestConsumer.Age,R.Restaurant_ID, R.Name AS Restaurant_Name, Ra.Food_Rating
FROM Restaurants R
RIGHT JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
RIGHT JOIN (
    SELECT TOP 1 Consumer_ID, Age
    FROM Consumers
    ORDER BY Age ASC
) YoungestConsumer ON Ra.Consumer_ID = YoungestConsumer.Consumer_ID
ORDER BY Ra.Food_Rating DESC;


Select *
From Consumers

Select *
From Restaurants

Select *
From Ratings

Select *
From Restaurant_cuisines

--Task 2 Part 1 Q 5
--Write a stored procedure for the query given as:
--Update the Service_rating of all restaurants to '2' if they have parking available, either as 'yes' or 'public'

--Count of restaurants having parking either as 'yes' or 'public'
SELECT COUNT(*) AS Restaurant_Count
FROM Restaurants
WHERE Parking IN ('Yes', 'Public');

SELECT COUNT(*) AS Restaurant_Count
FROM Restaurants
WHERE Parking IN ('Public');

SELECT COUNT(*) AS Restaurant_Count
FROM Restaurants
WHERE Parking IN ('Yes');


-- Listing out restaurants having parking  either as 'yes' or 'public'
SELECT Restaurant_ID, Name, Parking
FROM Restaurants
WHERE Parking IN ('Yes', 'Public');

-- Ordering the lists by column Parking
SELECT Restaurant_ID, Name, Parking
FROM Restaurants
WHERE Parking IN ('Yes', 'Public')
ORDER BY Parking;

-- Listing the count of restaurants with parking either as  ' Yes' or  'Public' and have a Service rating 
SELECT COUNT(*)
FROM Restaurants R
LEFT JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
WHERE R.Parking IN ('Yes', 'Public');


-- View the service rating of the restaurants having parking  either as 'yes' or 'public'
DROP VIEW IF EXISTS ParkingServiceRatingView;

CREATE VIEW ParkingServiceRatingView AS
SELECT R.Restaurant_ID, R.Name AS Restaurant_Name, R.Parking, Ra.Service_Rating
FROM Restaurants R
LEFT JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
WHERE R.Parking IN ('Yes', 'Public');

SELECT * FROM ParkingServiceRatingView
ORDER BY PARKING;

-- Creating stored procedure to
--Update the Service_rating of all restaurants to '2' if they have parking available, either as 'yes' or 'public'
DROP PROCEDURE IF EXISTS UpdateServiceRatingWithParking;
CREATE PROCEDURE UpdateServiceRatingWithParking
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Update the Service_Rating of restaurants with parking available to '2'
        UPDATE Ratings
        SET Service_Rating = 2
        WHERE Restaurant_ID IN (
            SELECT R.Restaurant_ID
            FROM Restaurants R
            WHERE R.Parking IN ('Yes', 'Public')
        );

        -- Commit the transaction if successful
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Raise the error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
EXEC UpdateServiceRatingWithParking;

--Task 2 Part 1 Q 6 Query 1
-- Creating function that returns the restaurants in the vicinity of the consumer, serving 
--specific Cuisine food, based on latitude and longitude matching up to the first two decimal places:

DROP FUNCTION IF EXISTS GetNearbySpecificCuisineRestaurants;

CREATE FUNCTION GetNearbySpecificCuisineRestaurants (@ConsumerLatitude decimal(18,10), @ConsumerLongitude decimal(18,10), @Cuisine nvarchar(20))
RETURNS TABLE
AS
RETURN
(
    SELECT R.Restaurant_ID, R.Name AS Restaurant_Name, R.City, R.State, R.Country, R.Zip_Code, R.Latitude, R.Longitude
    FROM Restaurants R
    WHERE R.Restaurant_ID IN (
        SELECT RC.Restaurant_ID
        FROM Restaurant_Cuisines RC
        WHERE RC.Cuisine = @Cuisine
    )
    AND ROUND(R.Latitude, 2) = ROUND(@ConsumerLatitude, 2)
    AND ROUND(R.Longitude, 2) = ROUND(@ConsumerLongitude, 2)
);

-- Execute the UDF to get nearby Mexican restaurants for a specific consumer location
SELECT *
FROM dbo.GetNearbySpecificCuisineRestaurants(23.752, -99.166, 'Mexican');

-- Execute the UDF to get nearby International restaurants for a specific consumer location
SELECT *
FROM dbo.GetNearbySpecificCuisineRestaurants(22.14, -100.94, 'International');

-- Creating function that returns the restaurants in the vicinity of the consumer, serving 
--specific Cuisine food, based on latitude and longitude matching up to the zero decimal places:
--broadening the search results
DROP FUNCTION IF EXISTS GetNearby_SpecificCuisine_Restaurants;

CREATE FUNCTION GetNearby_SpecificCuisine_Restaurants (@ConsumerLatitude decimal(18,10), @ConsumerLongitude decimal(18,10), @Cuisine nvarchar(20))
RETURNS TABLE
AS
RETURN
(
    SELECT R.Restaurant_ID, R.Name AS Restaurant_Name, R.City, R.State, R.Country, R.Zip_Code, R.Latitude, R.Longitude
    FROM Restaurants R
    WHERE R.Restaurant_ID IN (
        SELECT RC.Restaurant_ID
        FROM Restaurant_Cuisines RC
        WHERE RC.Cuisine = @Cuisine
    )
    AND ROUND(R.Latitude, 0) = ROUND(@ConsumerLatitude, 0)
    AND ROUND(R.Longitude, 0) = ROUND(@ConsumerLongitude, 0)
);

-- Execute the UDF to get nearby Mexican restaurants for a specific consumer location
SELECT *
FROM dbo.GetNearby_SpecificCuisine_Restaurants(23.752, -99.166, 'Mexican');

-- Execute the UDF to get nearby International restaurants for a specific consumer location
SELECT *
FROM dbo.GetNearby_SpecificCuisine_Restaurants(22.14, -100.94, 'International');


--Task 2 Part 1 Q 6 Query 1
---- Creating query that returns the restaurants in the vicinity of the consumer, serving 
--specific Cuisine food, based on latitude and longitude matching up to the zero decimal places:
SELECT R.Restaurant_ID, R.Name AS Restaurant_Name, R.City, R.State, R.Country, R.Zip_Code, R.Latitude, R.Longitude
FROM Restaurants R
WHERE EXISTS (
    SELECT 1
    FROM Restaurant_Cuisines RC
    WHERE RC.Restaurant_ID = R.Restaurant_ID
    AND RC.Cuisine = 'Mexican'
)
AND ROUND(R.Latitude, 0) = ROUND(23.752, 0)
AND ROUND(R.Longitude, 0) = ROUND(-99.166, 0)
GROUP BY R.Restaurant_ID, R.Name, R.City, R.State, R.Country, R.Zip_Code, R.Latitude, R.Longitude
ORDER BY R.Restaurant_ID;


Select *
From Consumers

Select *
From Restaurants

Select *
From Ratings

Select *
From Restaurant_cuisines


--Task 2 Part 1 Q 6 Query 2
--Creating query that returns the restaurant details 
-- Restaurant_Id, Name, Cuisine, Average Overall_Rating
--that serves Cuisine - 'American', or  'Japanese' and have the overall rating greater than 0
SELECT R.Restaurant_ID, R.Name AS Restaurant_Name, RC.Cuisine,AVG(Ra.Overall_Rating) AS Avg_Overall_Rating
FROM Restaurants R
JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
WHERE RC.Cuisine IN ('American', 'Japanese')
GROUP BY R.Restaurant_ID, R.Name, RC.Cuisine
HAVING EXISTS (
    SELECT 1
    FROM Ratings Ra2
    WHERE Ra2.Restaurant_ID = R.Restaurant_ID
    AND Ra2.Overall_Rating >0
) ORDER BY R.Restaurant_ID;


 SELECT Ra.Restaurant_ID,Ra.Overall_Rating
    FROM Ratings Ra
	JOIN Restaurants R ON R.Restaurant_ID = Ra.Restaurant_ID
    WHERE Ra.Restaurant_ID = R.Restaurant_ID
    AND Ra.Overall_Rating >0;
			   	 
SELECT R.Restaurant_ID, R.Name AS Restaurant_Name, RC.Cuisine
FROM Restaurants R
JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
WHERE RC.Cuisine IN ('American', 'Japanese')
ORDER BY R.Restaurant_ID DESC;



-- Subquery to select Restaurant_IDs from the first query
SELECT Restaurant_ID FROM (
    SELECT R.Restaurant_ID
    FROM Restaurants R
    JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
    JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
    WHERE RC.Cuisine IN ('Regional', 'American', 'Japanese')
    GROUP BY R.Restaurant_ID, R.Name, RC.Cuisine, R.City, R.State, R.Country
    HAVING EXISTS (
        SELECT 1
        FROM Ratings Ra2
        WHERE Ra2.Restaurant_ID = R.Restaurant_ID
        AND Ra2.Overall_Rating > 0
    )
) AS FirstQuery

INTERSECT

-- Subquery to select Restaurant_IDs from the second query
SELECT Restaurant_ID  FROM (
    SELECT R.Restaurant_ID
    FROM Restaurants R
    JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
    WHERE RC.Cuisine IN ('Regional', 'American', 'Japanese')
    GROUP BY R.Restaurant_ID, R.Name, RC.Cuisine, R.City, R.State, R.Country
) AS SecondQuery;


-- Subquery to select Restaurant_IDs from the first query
SELECT Restaurant_ID FROM (
    SELECT R.Restaurant_ID
    FROM Restaurants R
    JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
    JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
    WHERE RC.Cuisine IN ('Regional', 'American', 'Japanese')
    GROUP BY R.Restaurant_ID, R.Name, RC.Cuisine, R.City, R.State, R.Country
    HAVING EXISTS (
        SELECT 1
        FROM Ratings Ra2
        WHERE Ra2.Restaurant_ID = R.Restaurant_ID
        AND Ra2.Overall_Rating > 0
    )
) AS FirstQuery

EXCEPT

-- Subquery to select Restaurant_IDs from the second query
SELECT Restaurant_ID FROM (
    SELECT R.Restaurant_ID
    FROM Restaurants R
    JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
    WHERE RC.Cuisine IN ('Regional', 'American', 'Japanese')
    GROUP BY R.Restaurant_ID, R.Name, RC.Cuisine, R.City, R.State, R.Country
) AS SecondQuery;



--Task 2 Part 1 Q 6 Query 3
--creating query that returns the restaurants with cuisines as bar, fast food or chinese and having food rating greater than 0 and price range either low or medium
SELECT R.Restaurant_ID, R.Name AS Restaurant_Name, RC.Cuisine, R2.Price,
       AVG(Ra.Food_Rating) AS Avg_Food_Rating,
       COUNT(DISTINCT C.Consumer_ID) AS Total_Consumers,
       MAX(C.Age) AS Max_Consumer_Age,
       MIN(C.Age) AS Min_Consumer_Age
FROM Restaurants R
JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
JOIN Ratings Ra ON R.Restaurant_ID = Ra.Restaurant_ID
JOIN Consumers C ON Ra.Consumer_ID = C.Consumer_ID
JOIN Restaurants R2 ON R.Restaurant_ID = R2.Restaurant_ID
WHERE RC.Cuisine IN ('Fast Food', 'Bar', 'Chinese') -- Selecting cuisines
GROUP BY R.Restaurant_ID, R.Name, RC.Cuisine, R2.Price
HAVING EXISTS (
    SELECT 1
    FROM Ratings Ra2
    WHERE Ra2.Restaurant_ID = R.Restaurant_ID
    AND Ra2.Food_Rating > 0
)
AND R2.Price IN ('Low', 'Medium')
ORDER BY R.Restaurant_ID DESC;


--Task 2 Part 1 Q 6 Query 4
--Listing the consumer ID (Trimmed), restaurant id, Restaurant name(Uppercase), 
SELECT SUBSTRING(LTRIM(RTRIM(C.Consumer_ID)), LEN(LTRIM(RTRIM(C.Consumer_ID))) - 3, 4) AS Trimmed_Consumer_ID, 
       R.Restaurant_ID, UPPER(R.Name) AS Restaurant_Name_Uppercase, R.State, 
       Ra.Overall_Rating, RC.Cuisine
FROM Consumers C
JOIN Ratings Ra ON C.Consumer_ID = Ra.Consumer_ID
JOIN Restaurants R ON Ra.Restaurant_ID = R.Restaurant_ID
JOIN Restaurant_cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
WHERE (R.State LIKE '%an%' )
  AND R.Name LIKE 'Cafe%'
  AND Ra.Overall_Rating IN (1, 2)
  AND RC.Cuisine IN (
      SELECT RC2.Cuisine
      FROM Restaurant_cuisines RC2
      WHERE PATINDEX('%ria', RC2.Cuisine) > 0
  )
GROUP BY SUBSTRING(LTRIM(RTRIM(C.Consumer_ID)), LEN(LTRIM(RTRIM(C.Consumer_ID))) - 3, 4), 
         R.Restaurant_ID, R.Name, R.State, Ra.Overall_Rating, RC.Cuisine
HAVING EXISTS (
    SELECT 1
    FROM Ratings Ra2
    WHERE Ra2.Restaurant_ID = R.Restaurant_ID
    AND Ra2.Food_Rating > 0
)
ORDER BY Ra.Overall_Rating DESC;



SELECT SUBSTRING(LTRIM(RTRIM(C.Consumer_ID)), LEN(LTRIM(RTRIM(C.Consumer_ID))) - 3, 4) AS Trimmed_Consumer_ID, 
       R.Restaurant_ID, UPPER(R.Name) AS Restaurant_Name_Uppercase, R.State, 
       Ra.Overall_Rating, RC.Cuisine
FROM Consumers C
JOIN Ratings Ra ON C.Consumer_ID = Ra.Consumer_ID
JOIN Restaurants R ON Ra.Restaurant_ID = R.Restaurant_ID
JOIN Restaurant_cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
WHERE (R.State LIKE 'San Luis%' OR R.State LIKE '%pas')
  AND R.Name LIKE 'Cafe%'
  AND Ra.Overall_Rating IN (1, 2)
GROUP BY SUBSTRING(LTRIM(RTRIM(C.Consumer_ID)), LEN(LTRIM(RTRIM(C.Consumer_ID))) - 3, 4), 
         R.Restaurant_ID, R.Name, R.State, Ra.Overall_Rating, RC.Cuisine
HAVING EXISTS (
    SELECT 1
    FROM Ratings Ra2
    WHERE Ra2.Restaurant_ID = R.Restaurant_ID
    AND Ra2.Overall_Rating > 0
)
ORDER BY Ra.Overall_Rating DESC;



SELECT SUBSTRING(LTRIM(RTRIM(C.Consumer_ID)), LEN(LTRIM(RTRIM(C.Consumer_ID))) - 3, 4) AS Trimmed_Consumer_ID, 
       R.Restaurant_ID, UPPER(R.Name) AS Restaurant_Name_Uppercase, R.State, 
       Ra.Overall_Rating, RC.Cuisine
FROM Consumers C
JOIN Ratings Ra ON C.Consumer_ID = Ra.Consumer_ID
JOIN Restaurants R ON Ra.Restaurant_ID = R.Restaurant_ID
JOIN Restaurant_cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
WHERE (R.State LIKE '%an%' )
  AND R.Name LIKE 'Cafe%'
  AND Ra.Overall_Rating IN (1, 2)
  AND PATINDEX('%ary', RC.Cuisine) > 0
GROUP BY SUBSTRING(LTRIM(RTRIM(C.Consumer_ID)), LEN(LTRIM(RTRIM(C.Consumer_ID))) - 3, 4), 
         R.Restaurant_ID, R.Name, R.State, Ra.Overall_Rating, RC.Cuisine
HAVING EXISTS (
    SELECT 1
    FROM Ratings Ra2
    WHERE Ra2.Restaurant_ID = R.Restaurant_ID
    AND Ra2.Overall_Rating > 0
)
ORDER BY Ra.Overall_Rating DESC;



SELECT SUBSTRING(LTRIM(RTRIM(C.Consumer_ID)), LEN(LTRIM(RTRIM(C.Consumer_ID))) - 3, 4) AS Trimmed_Consumer_ID, 
       R.Restaurant_ID, UPPER(R.Name) AS Restaurant_Name_Uppercase, R.State, 
       Ra.Overall_Rating, RC.Cuisine
FROM Consumers C
JOIN Ratings Ra ON C.Consumer_ID = Ra.Consumer_ID
JOIN Restaurants R ON Ra.Restaurant_ID = R.Restaurant_ID
JOIN Restaurant_cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
WHERE (R.State LIKE '%an%' )
  AND R.Name LIKE 'Cafe%'
  AND Ra.Overall_Rating IN (1, 2)
  AND PATINDEX('%ria', RC.Cuisine) > 0
GROUP BY SUBSTRING(LTRIM(RTRIM(C.Consumer_ID)), LEN(LTRIM(RTRIM(C.Consumer_ID))) - 3, 4), 
         R.Restaurant_ID, R.Name, R.State, Ra.Overall_Rating, RC.Cuisine
HAVING EXISTS (
    SELECT 1
    FROM Ratings Ra2
    WHERE Ra2.Restaurant_ID = R.Restaurant_ID
    AND Ra2.Overall_Rating > 0
)
ORDER BY Ra.Overall_Rating DESC;





Select *
FRom Ratings

