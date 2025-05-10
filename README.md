# Revenue Performance Dashboard Project

**Project Overview:**  
This project entails the development of a global revenue report for a Chief Revenue Officer (CRO). The primary objective is to provide an insightful dashboard that facilitates data-driven decision-making.

---

## 🧑‍💼 Business Request & User Stories

The business requirement was to create a quarterly revenue report for a CRO. Based on this, the following user story was defined to ensure that the deliverable met the acceptance criteria:

| Role              | Request                                             | User Value                                             | Acceptance Criteria                                                                 |
|-------------------|-----------------------------------------------------|--------------------------------------------------------|-------------------------------------------------------------------------------------|
| Chief Revenue Office     | Dashboard overview of quarterly global revenue for 2023                | Identify top-performing services and regions         | Power BI dashboard                                           |

---

## 🧹 Data Cleansing & Transformation (SQL)

We are given 2 tables (services data and branch date) from which to construct the necesary queried tables and relevant KPIs for dashboard construction later on. The following tables were extracted and transformed using SQL.

---

### 🌎 Table: Revenue by region

```sql
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
```

---

### 💼 Table: Revenue by department

```sql
SELECT 
  department, 
  SUM(total_revenue) AS TotalRevenue 
FROM 
  [ServiceBranch].[dbo].[services_data]
GROUP BY 
  department 
ORDER BY 
  TotalRevenue DESC;
```
---

### 👨‍💼 Table: Revenue by customer

 ```sql
SELECT
  client_name, SUM(total_revenue) AS TotalRevenue
FROM 
  [ServiceBranch].[dbo].[services_data]
GROUP BY
  client_name
ORDER BY
  TotalRevenue DESC;
 ```
---

### 💲 KPI: Total revenue

 ```sql
SELECT
  SUM(total_revenue) AS TotalRevenue
FROM
  [ServiceBranch].[dbo].[services_data];
 ```
---

### 🕒 KPI: Total hours

 ```sql
SELECT
  SUM(hours) AS TotalHours
FROM
  [ServiceBranch].[dbo].[services_data];
 ```
---

### 🕒 KPI: Revenue by department over overall revenue

 ```sql
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
 ```
---

### 📈 KPI: Month on month percentage increase

 ```sql
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
 ```
---

## 📈 Dashboard Features

- **Interactive Visualizations:**  
  Dynamic charts and graphs that allow users to explore sales data interactively.

- **Filtering Capabilities:**  
  Ability to filter data by customer, product, and time period to gain specific insights.

- **KPI Tracking:**  
  Key Performance Indicators displayed to monitor sales performance against targets.

- **Hour Visualization:**  
  Compare man-hours utilized accross different dimension against revenue.

---

## 🛠️ Tools & Technologies

- **Data Extraction & Transformation:** SQL  
- **Data Visualization:** Power BI  
- **Data Sources:** AdventureWorksDW2019 Database, Excel (for sales budgets)

