SELECT * FROM KMS_Sql
SELECT * FROM Order_Status

---Which product category had the highest sales?
SELECT Product_Category, SUM(Sales) AS TotalSales
FROM KMS_Sql
GROUP BY Product_Category
ORDER BY TotalSales DESC

---What are the Top 3 and Bottom 3 regions in terms of sales?
--Top 3
SELECT Top 3 Region, SUM(Sales) AS TotalSales
FROM KMS_Sql
GROUP BY Region
ORDER BY TotalSales DESC

--Bottom 3
SELECT Top 3 Region, SUM(Sales) AS TotalSales
FROM KMS_Sql
GROUP BY Region
ORDER BY TotalSales ASC

---What were the total sales of appliances in Ontario?
SELECT SUM(Sales) AS TotalAppliancesSales 
FROM KMS_Sql
WHERE Product_Sub_Category = 'appliances ' AND Province = 'Ontario'

--- Advise KMS on how to increase revenue from the bottom 10 customers
SELECT TOP 10 Customer_Name, SUM(Sales) AS TotalSales
FROM KMS_Sql
GROUP BY Customer_Name
ORDER BY TotalSales ASC

-- KMS incurred the most shipping cost using which shipping method?
SELECT Ship_Mode, SUM(Shipping_cost) AS TotalShippingCost
FROM KMS_Sql
GROUP BY Ship_Mode
ORDER BY TotalShippingCost DESC

---Who are the most valuable customers, and what products or services do they typically purchase
WITH TopCustomers AS (
SELECT TOP 10 Customer_Name    
FROM KMS_Sql
GROUP BY Customer_Name
ORDER BY SUM(Sales) DESC)
SELECT K.Customer_name, K.Product_Category, SUM(K.Sales) AS TotalSales
FROM KMS_Sql K
JOIN TopCustomers T
ON K.Customer_Name = T.Customer_Name
GROUP BY K.Customer_Name,K.Product_Category
ORDER BY K.Customer_Name, TotalSales DESC

---Which small business customer had the highest sales
SELECT Top 5 Customer_Name, SUM(Sales) AS TotalSales 
FROM KMS_Sql
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name
ORDER BY TotalSales DESC

---Which corporate customer placed the most number of orders (2009-2012)
SELECT TOP 5 Customer_Name, COUNT(Order_ID) AS Order_Count
FROM KMS_Sql 
WHERE Customer_Segment = 'Corporate' AND Order_Date BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY Customer_Name
ORDER BY Order_Count

---Which consumer customer was the most profitable one 
SELECT TOP 5 Customer_Name, SUM(Profit) AS TotalProfit
FROM KMS_Sql
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name
ORDER BY TotalProfit DESC

---Which customer returned items, and what segment do they belong to
SELECT DISTINCT K.Customer_Name, K.Customer_Segment
FROM KMS_Sql K
JOIN Order_Status O
ON K.Order_ID = O.Order_ID
WHERE O.Status = 'Returned'

---Was shipping cost appropriately used based on order priority?
SELECT Order_Priority, Ship_Mode, COUNT(*) AS OrderCount, SUM(Shipping_Cost) AS TotalCost
FROM KMS_Sql
GROUP BY Order_Priority, Ship_Mode
ORDER BY Order_Priority, TotalCost DESC