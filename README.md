# logistics-sla-breach-analysis
Logistics SLA Breach Analysis — Driver & Regional Performance Investigation
Business Problem
Operations had no visibility into which drivers and regions were causing SLA breaches. The goal was to determine whether delivery delays were due to driver inefficiency or external operational factors such as region and product category.

Dataset
Three related tables generated to simulate real-world messy logistics data:
TableRowsDescriptionlogistics_orders310Order details — category, city, region, salesperson, revenuelogistics_shipments308Delivery details — expected vs actual dates, status, SLA dayslogistics_drivers10Driver details — name, region, rating
Intentional data quality issues included:

5 different date formats
Inconsistent naming conventions
NULL and empty values
Duplicate rows


Tools Used

MySQL — Data cleaning, multi-table JOINs, CTEs, CASE WHEN aggregations
Power BI — SLA breach dashboard with regional and driver-level KPIs


Approach
Step 1 — Data Cleaning
Applied a professional 3-table structure: raw → clean → final

Standardized date formats using COALESCE + STR_TO_DATE across 5 formats
Fixed inconsistent salesperson and category naming using LOWER + TRIM + CASE WHEN
Handled NULL values appropriately — retained lost order NULLs as expected
Removed duplicates at final table stage using SELECT DISTINCT

Step 2 — Analysis
Connected all three tables using INNER JOINs to enable cross-table analysis:
sqlSELECT d.driver_name, s.delivery_region, o.category,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END) AS breaches,
       ROUND(SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END) 
             * 100.0 / COUNT(*), 2) AS breach_rate
FROM logistics_shipments_final s
JOIN logistics_drivers_final d ON s.driver_id = d.driver_id
JOIN logistics_orders_final o ON s.order_id = o.order_id
GROUP BY d.driver_name, s.delivery_region, o.category
ORDER BY breach_rate DESC;
Step 3 — Benchmark Analysis (CTE)
Used a CTE to compare each driver's breach rate against the regional and category average — to determine if underperformance was individual or structural.

Key Findings
AreaFindingHighest breach rate driverKavita Reddy — 80.77%Second highestDeepak Yadav — 79.17%North region breach rate75% — highest across all regionsElectronics in North83% breach rate despite being top sales categoryMost breached categoriesFood and Furniture — consistently high across regions

Conclusion
SLA breaches were driven primarily by regional operational constraints, not individual driver performance. Both top suspects (Kavita and Deepak) operated in the North region — which showed 75% breach rate across all drivers and categories, including Electronics which performs well elsewhere.
Drivers were cleared of individual blame. The problem is structural.

Recommendation

Revisit SLA timelines specifically for the North region — current timelines may be unrealistic given operational conditions
Investigate Food and Furniture supply chain for category-specific bottlenecks
Obtain transit time and distance data to confirm root cause and set data-driven SLA targets
Implement driver benchmarking relative to region and category — not absolute breach rate

Dashboard Preview
Built in Power BI — showing breach rate by region, category, and driver with interactive region filter.
Show Image

Files
├── logistics_orders.csv          # Raw orders data
├── logistics_shipments.csv       # Raw shipments data  
├── logistics_drivers.csv         # Driver reference data
├── cleaning_queries.sql          # All data cleaning SQL
├── analysis_queries.sql          # All analysis SQL
├── dashboard.pbix                # Power BI dashboard file
└── README.md

Author
Deepika Y — Aspiring MIS & Data Analyst, Bangalore
LinkedIn | GitHub
