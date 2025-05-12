-- QUERIED TABLES

-- Revenue by region
SELECT 
  b.Region,
  SUM(s.total_revenue) AS TotalRevenue 
FROM 
  [ServiceBranch].[dbo].[services_data] AS s 
  JOIN [ServiceBranch].[dbo].[branch_data] AS b 
  ON s.branch_id = b.Branch_ID 
GROUP BY 
  b.Region
ORDER BY 
  TotalRevenue DESC;

-- Revenue by department
SELECT 
  department, 
  SUM(total_revenue) AS TotalRevenue 
FROM 
  [ServiceBranch].[dbo].[services_data]
GROUP BY 
  department 
ORDER BY 
  TotalRevenue DESC;

-- Revenue by customer
SELECT
  client_name, SUM(total_revenue) AS TotalRevenue
FROM 
  [ServiceBranch].[dbo].[services_data]
GROUP BY
  client_name
ORDER BY
  TotalRevenue DESC;

-- QUERIED KPI'S

-- Total revenue
SELECT
  SUM(total_revenue) AS TotalRevenue
FROM
  [ServiceBranch].[dbo].[services_data];

--Total hours
SELECT
  SUM(hours) AS TotalHours
FROM
  [ServiceBranch].[dbo].[services_data];

 -- Revenue by department over overall revenue
SELECT 
  department, 
  SUM(total_revenue) AS DepartmentRevenue, 
  (
    SUM(total_revenue) / (
      SELECT 
        SUM(total_revenue) 
      FROM 
        [ServiceBranch].[dbo].[services_data]
    )
  ) * 100 AS RevenuePercentage 
FROM 
  [ServiceBranch].[dbo].[services_data] 
GROUP BY 
  department;

 -- Month on month percentage increase
WITH 
  MonthlyRevenue AS (
    SELECT
      FORMAT(service_date, 'yyyy-MM') AS Month,
	  SUM(total_revenue) AS Revenue
    FROM
      [ServiceBranch].[dbo].[services_data]
    GROUP BY
      FORMAT(service_date, 'yyyy-MM')
    ),
  RevenueComparison AS (
    SELECT
	  Month,
	  Revenue,
	  LAG(Revenue) OVER (ORDER BY Month) AS PreviousMonthRevenue
	FROM
	  MonthlyRevenue
    )
SELECT
  Month,
  Revenue,
  PreviousMonthRevenue,
  CASE WHEN PreviousMonthRevenue > 0 THEN ((Revenue - PreviousMonthRevenue) /
  PreviousMonthRevenue) * 100 ELSE NULL END AS RevenuePercentageIncrease
FROM
  RevenueComparison
WHERE
  PreviousMonthRevenue IS NOT NULL;