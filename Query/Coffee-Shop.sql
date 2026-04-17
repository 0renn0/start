/* ==========================================================================
Project: House Sales & Branch Performance Analysis
Description: This script analyzes daily revenue, branch efficiency, 
             marketing ROI, and customer trends across various regions.
Dataset: House_Sales.csv (Regional sales data in KES)
Author: Renny 
==========================================================================
*/
-- Initial Data Inspection
-- Retrieves all records to verify data integrity and schema
SELECT * FROM house_sales;

-- Regional Revenue Performance
-- Aggregates daily revenue and average order value by region
-- Focuses on identifying high-value geographic zones
SELECT Region, 
    ROUND(SUM(Daily_Revenue_KES), 2) AS Daily_Revenue,
    ROUND(AVG(Average_Order_Value_KES), 0) AS Avg_Order
FROM house_sales GROUP BY Region ORDER BY Daily_Revenue DESC;

-- Marketing Efficiency (ROI)
-- Calculates the Return on Investment for marketing spend per branch
-- Identifies the top 10 most cost-effective branches
SELECT Branch, 
    ROUND(SUM(Daily_Revenue_KES) / SUM(Marketing_Spend_KES), 2) AS Marketing_ROI
FROM house_sales GROUP BY Branch ORDER BY Marketing_ROI DESC LIMIT 10;

-- Operational Efficiency
-- Measures revenue generated per employee to assess staff productivity
SELECT Branch, 
    ROUND(AVG(Daily_Revenue_KES / Number_of_Employees), 2) AS Revenue_Per_Staff
FROM house_sales  GROUP BY Branch ORDER BY Revenue_Per_Staff DESC LIMIT 5;

-- Time-Series Analysis: Monthly Trends
-- Groups data by month to observe seasonal revenue and customer growth
-- ANALYTICAL VIEW: TOP 5 REVENUE GENERATING MONTHS
-- It isolates the periods where the highest financial conversion occurred, 

SELECT DATE_FORMAT(Date, '%Y-%m') AS Month, 
    ROUND(SUM(Daily_Revenue_KES), 2) AS Total_Monthly_Revenue,
    SUM(Number_of_Customers_Per_Day) AS Total_Customers
FROM house_sales GROUP BY Month ORDER BY Total_Monthly_Revenue DESC LIMIT 5;

-- TOP 10 HIGH-TRAFFIC MONTHS (MARKETING IMPACT)
-- This query measures customer volume and foot traffic. 
-- It highlights the busiest periods for the business, which is essential for 
-- resource planning, staffing, and evaluating the reach of marketing campaigns.
SELECT DATE_FORMAT(Date, '%Y-%m') AS Month, 
    SUM(Number_of_Customers_Per_Day) AS Total_Customers,
    ROUND(SUM(Daily_Revenue_KES), 2) AS Total_Monthly_Revenue
FROM house_sales GROUP BY Month ORDER BY Total_Customers DESC limit 10;

-- AVERAGE DAILY CUSTOMER FOOT TRAFFIC BY BRANCH
-- This query shifts the focus from "When" to "Where." 
-- By using an average instead of a total, it identifies which locations 
-- maintain the most consistent daily popularity, providing a fair comparison 
-- between newer branches and long-standing ones.
SELECT Branch, 
    ROUND(AVG(Number_of_Customers_Per_Day), 0) AS Avg_Daily_Customers
FROM house_sales GROUP BY Branch ORDER BY Avg_Daily_Customers DESC  ;

--  Customer Traffic Leaders
-- Ranks branches by their average daily customer foot traffic
SELECT Branch, 
    ROUND(AVG(Location_Foot_Traffic),2) AS Avg_Foot_Traffic,
    ROUND(AVG(Daily_Revenue_KES),2) AS Avg_Daily_Revenue
FROM house_sales WHERE Location_Foot_Traffic > 500
GROUP BY Branch HAVING Avg_Daily_Revenue > 200000 ORDER BY Avg_Daily_Revenue DESC;
