use superstore;

SELECT COUNT(*) AS TotalTables 
FROM sys.tables;

---Total number of columns
SELECT COUNT(*) AS TotalColumns 
FROM sys.columns 
WHERE object_id = OBJECT_ID('Global_Superstore');

----Year-over-Year (YoY) Regional Growth



SELECT 
    Region,
    SalesYear,
    ROUND(Current_Sales, 2) AS Current_Year_Sales,
    ROUND(Previous_Sales, 2) AS Previous_Year_Sales,
    ROUND(Current_Sales - Previous_Sales, 2) AS Absolute_Growth,
    ROUND(((Current_Sales - Previous_Sales) / NULLIF(Previous_Sales, 0)) * 100, 2) AS Growth_Rate_Percentage
FROM (
    SELECT 
        Region,
        SalesYear,
        Current_Sales,
        LAG(Current_Sales, 1) OVER (PARTITION BY Region ORDER BY SalesYear) AS Previous_Sales
    FROM (
        SELECT 
            Region,
            YEAR(Order_Date) AS SalesYear,
            SUM(Sales) AS Current_Sales
        FROM Global_Superstore
        GROUP BY Region, YEAR(Order_Date)
    ) AS YearlySummary
) AS GrowthCalc
ORDER BY Region, SalesYear;

