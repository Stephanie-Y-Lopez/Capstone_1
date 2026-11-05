-- I am analyzing the South Carolina (SC) territory.
USE sample_sales;

-- 1. 
SELECT  SUM(Store_Sales.Sale_Amount) AS Total_Revenue, MIN(Store_Sales.Transaction_Date) AS Start_Date, MAX(Store_Sales.Transaction_Date) AS End_Date
FROM store_sales
JOIN store_locations
ON  store_sales.store_ID = store_locations.storeId
WHERE store_locations.State = 'South Carolina';

-- 2.
SELECT YEAR(Store_Sales.Transaction_Date) AS revenue_perYear, MONTH(Store_Sales.Transaction_Date) AS revenue_perMonth, SUM(Store_Sales.Sale_Amount) AS Total_Revenue
FROM store_sales
JOIN store_locations
ON  store_sales.store_ID = store_locations.storeId
WHERE store_locations.State = 'South Carolina'
GROUP BY revenue_perYear, revenue_perMonth;

-- 3. 
SELECT store_locations.State, management.Region, SUM(Store_Sales.Sale_Amount) AS Total_revenue
FROM store_sales
JOIN store_locations
ON  store_sales.store_ID = store_locations.storeId
JOIN management
ON store_locations.State = management.State
WHERE management.Region = 'South'
GROUP BY store_locations.State, management.Region;

-- 4. 
SELECT MONTH(Store_Sales.Transaction_Date) AS sales_month, inventory_categories.Category, COUNT(*) AS transaction_Count, AVG(Store_Sales.Sale_Amount) AS average_transactioncount
FROM store_sales
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreId
JOIN products
ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories
ON products.Categoryid = inventory_categories.Categoryid
WHERE store_locations.State = 'South Carolina'
GROUP BY sales_month, inventory_categories.Category
ORDER BY sales_month, inventory_categories.Category;

-- 5.
SELECT SUM(online_sales.SalesTotal) AS Total_Revenue, online_sales.ShipToState, management.Region, management.State
FROM online_sales
JOIN store_locations
ON  online_sales.ShipToState = store_locations.State
JOIN  management
ON management.State = store_locations.State
WHERE management.Region = 'South'
GROUP BY online_sales.ShipToState, management.Region
ORDER BY Total_Revenue DESC; 