SELECT * FROM swiggy LIMIT 10;
--1) Count of Resaurant in each area
SELECT "City","Area",COUNT("Restaurant") AS "Restaurant_Count"
FROM swiggy
GROUP BY "City","Area"
ORDER BY "Restaurant_Count" DESC 

--2) Count of restaurant in each area with bad popularity score (BAD Restaurant)
SELECT "City",COUNT ("Restaurant") AS "Restaurant_Count"
FROM swiggy
WHERE "Popularity_Score" < 13
GROUP BY "City"
ORDER BY "Restaurant_Count" DESC 

--3) count of restaurant with bad delivery for each area (BAD Delivery Time)
SELECT "City","Area",COUNT ("Restaurant") AS "Restaurant_Count"
FROM swiggy
WHERE "Delivery_Time" > 60
GROUP BY "City","Area"
ORDER BY "City","Restaurant_Count" DESC

--4) count of restaurant with high rating and popularity score (BEST Restaurant)
SELECT "City","Area",COUNT ("Restaurant") AS "Restaurant_Count"
FROM swiggy
WHERE "Avg_Ratings" > 4.0 AND "Popularity_Score" > 27
GROUP BY "City","Area"
ORDER BY "City","Restaurant_Count" DESC 

--5) count of restaurant with high avg rating and less no of rating (RISK)
SELECT "City",COUNT("Restaurant") AS "Restaurant_Count"
FROM swiggy
WHERE "Avg_Ratings" >4.0 AND "Total_Ratings" <100
GROUP BY "City"
ORDER BY "Restaurant_Count" DESC

--6) best selling food in each city and area
WITH "Best_Food" AS (
SELECT "City",
"Area",
"Primary_Cuisine",
COUNT("Primary_Cuisine") AS "Cuisine_Count"
FROM swiggy
GROUP BY "City","Area","Primary_Cuisine"
),
"Ranked_Food" AS (
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY "City","Area" 
ORDER BY "Cuisine_Count" DESC) AS "RN"
FROM "Best_Food" 
)
SELECT "City","Area","Primary_Cuisine","Cuisine_Count"
FROM "Ranked_Food"
WHERE "RN"=1 LIMIT 10

--7) count of restaurant with all 3 ratings in each city
SELECT "City",
"Rating_Status",
COUNT("Restaurant") AS "Restaurant_Count"
FROM swiggy
GROUP BY "City","Rating_Status"
ORDER BY "City","Restaurant_Count" DESC

--8) top 10 most popular restaurants
SELECT "City","Area","Restaurant","Popularity_Score"
FROM swiggy
ORDER BY "Popularity_Score" DESC LIMIT 10

--9) which area is having best average rating
SELECT "City","Area","Avg_Ratings",COUNT(*) AS "Restaurant_Count"
FROM swiggy
WHERE "Avg_Ratings" > 4.5
GROUP BY "City","Area","Avg_Ratings"
ORDER BY "Restaurant_Count" DESC

--10) Restaurants with high price and low popularity score (RISK)
SELECT "City","Restaurant","Price_Category","Popularity_Score"
FROM swiggy
WHERE "Price_Category" ='Costly' AND "Popularity_Score" < 50
ORDER BY "Popularity_Score"

-- 11) Cuisines that tend to be premium
SELECT "Primary_Cuisine",
       AVG("Price") AS "Avg_Price",
       COUNT(*) AS "Restaurant_Count"
FROM swiggy
GROUP BY "Primary_Cuisine"
ORDER BY "Avg_Price" DESC LIMIT 10
