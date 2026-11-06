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
SELECT MONTH(Store_Sales.Transaction_Date) AS sales_Month, inventory_categories.Category, COUNT(*) AS transaction_Count, AVG(Store_Sales.Sale_Amount) AS average_TransactionCost
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

-- 6.
SELECT Store_Sales.sales_Year, Store_Sales.Sales_Month, Store_Sales.InStore_Revenue, online_sales.Online_Revenue, ROUND(((online_sales.Online_Revenue - Store_Sales.InStore_Revenue) / NULLIF(Store_Sales.InStore_Revenue, 0)) * 100, 2 ) AS Percent_Difference
FROM
(SELECT YEAR(Store_Sales.Transaction_Date) AS sales_Year, MONTH(Store_Sales.Transaction_Date) AS Sales_Month, SUM(Store_Sales.Sale_Amount) AS InStore_Revenue
FROM Store_Sales
JOIN Store_Locations
ON Store_Sales.Store_ID = Store_Locations.StoreId
WHERE Store_Locations.State = 'South Carolina'
GROUP BY sales_Year, Sales_Month) AS Store_Sales
JOIN
(SELECT YEAR(online_sales.Date) AS sales_Year, MONTH(online_sales.Date) AS Sales_Month, SUM(online_sales.SalesTotal) AS Online_Revenue
FROM online_sales
WHERE online_sales.ShipToState = 'South Carolina'
GROUP BY sales_Year, Sales_Month) AS online_sales
ON Store_Sales.sales_Year = online_sales.sales_Year
AND Store_Sales.Sales_Month = online_sales.Sales_Month
ORDER BY Store_Sales.sales_Year, Store_Sales.Sales_Month;