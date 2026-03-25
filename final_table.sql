-- ANALYSIS WITH JOINS OF LOGISTICS --
/*
SELECT o.category,s.shipment_id,s.order_id,s.driver_id,
s.expected_delivery_date,s.actual_delivery_date,
s.delivery_status,s.delivery_region,s.SLA_days
FROM logistics_orders_final o
INNER JOIN logistics_shipments_final s ON o.order_id = s.order_id
INNER JOIN logistics_drivers_final d ON s.driver_id = d.driver_id;
*/
/*
SELECT 
o.category,
s.shipment_id,
s.order_id,
s.driver_id,
s.expected_delivery_date,
s.actual_delivery_date,
s.delivery_status,
s.delivery_region,
s.SLA_days
FROM logistics_orders_final o
INNER JOIN logistics_shipments_final s 
ON o.order_id = s.order_id
INNER JOIN logistics_drivers_final d 
ON s.driver_id = d.driver_id
WHERE s.actual_delivery_date > s.expected_delivery_date;
*/
/*
SELECT d.driver_name, 
COUNT(*) as total_orders,
SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END)
 AS breached_orders,
 ROUND(SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END)
 * 100 /COUNT(*),2)
 as breach_rate 
 FROM logistics_shipments_final s
JOIN logistics_drivers_final d
ON s.driver_id = d.driver_id

GROUP BY d.driver_name
ORDER BY breach_rate DESC;
*/

/*
SELECT s.delivery_region,
COUNT(*) AS total_orders,
SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END) AS 
breach_orders,
ROUND(SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END)
*100/COUNT(*),2) AS breach_rate
FROM logistics_shipments_final s
INNER JOIN logistics_drivers_final d
ON s.driver_id = d.driver_id
GROUP BY s.delivery_region;
*/
/*
SELECT
delivery_region,
AVG(DATEDIFF(actual_delivery_date, expected_delivery_date)) AS avg_delay_days
FROM logistics_shipments_final
WHERE actual_delivery_date > expected_delivery_date
GROUP BY delivery_region;
*/
/*
SELECT o.category,s.delivery_region,
COUNT(*) AS total_orders,
SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END) AS breach_orders,
ROUND(SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END)
*100/COUNT(*),2) AS breach_rate
FROM logistics_orders_final o
JOIN logistics_shipments_final s
ON o.order_id = s.order_id
GROUP BY o.category,s.delivery_region
ORDER BY breach_rate DESC;
*/
/*
SELECT o.category,
COUNT(*) AS total_orders,
SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END) AS breach_orders,
ROUND(SUM(CASE WHEN s.actual_delivery_date > s.expected_delivery_date THEN 1 ELSE 0 END)
*100/COUNT(*),2) AS breach_rate
FROM logistics_orders_final o
JOIN logistics_shipments_final s
ON o.order_id = s.order_id
GROUP BY o.category
ORDER BY breach_rate DESC; */

/* CTE IS USED 
WITH driver_performance AS (
    SELECT
        d.driver_name,
        s.delivery_region,
        o.category,

        COUNT(*) AS total_orders,

        SUM(CASE 
            WHEN s.actual_delivery_date > s.expected_delivery_date 
            THEN 1 ELSE 0 END
        ) AS breach_orders,

        ROUND(
        SUM(CASE 
            WHEN s.actual_delivery_date > s.expected_delivery_date 
            THEN 1 ELSE 0 END
        ) * 100.0 / COUNT(*),2
        ) AS driver_breach_rate

    FROM logistics_shipments_final s
    JOIN logistics_drivers_final d
        ON s.driver_id = d.driver_id
    JOIN logistics_orders_final o
        ON s.order_id = o.order_id

    GROUP BY d.driver_name, s.delivery_region, o.category
),

group_avg AS (
    SELECT
        delivery_region,
        category,

        ROUND(AVG(driver_breach_rate),2) AS avg_breach_rate

    FROM driver_performance
    GROUP BY delivery_region, category
)

SELECT
dp.driver_name,
dp.delivery_region,
dp.category,
dp.total_orders,
dp.driver_breach_rate,
ga.avg_breach_rate,

ROUND(dp.driver_breach_rate - ga.avg_breach_rate,2) AS performance_diff

FROM driver_performance dp
JOIN group_avg ga
ON dp.delivery_region = ga.delivery_region
AND dp.category = ga.category

ORDER BY performance_diff DESC;
*/
