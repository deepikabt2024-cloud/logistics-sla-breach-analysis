-- observation to cleaning orders table --

-- SELECT * FROM logistics_orders_raw;
-- SELECT * FROM logistics_drivers_raw LIMIT 10;
/*
SELECT 
SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS null_orders,
SUM(CASE WHEN sales_person IS NULL OR sales_person = '' THEN 1 ELSE 0 END) AS missing_names,
SUM(CASE WHEN category IS NULL OR category = '' THEN 1 ELSE 0 END ) AS missing_category,
SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END ) AS missing_city,
SUM(CASE WHEN region IS NULL OR region = '' THEN 1 ELSE 0 END ) AS missing_region,
SUM(CASE WHEN units_sold IS NULL OR units_sold= '' THEN 1 ELSE 0 END ) AS missing_units,
SUM(CASE WHEN unit_price IS NULL OR unit_price = '' THEN 1 ELSE 0 END ) AS missing_price,
SUM(CASE WHEN total_amount IS NULL OR total_amount = '' THEN 1 ELSE 0 END ) AS missing_amount,
SUM(CASE WHEN payment_method IS NULL OR payment_method = '' THEN 1 ELSE 0 END ) AS missing_payment,
SUM(CASE WHEN order_date IS NULL OR order_date = '' THEN 1 ELSE 0 END ) AS missing_dates
FROM logistics_orders_raw;
*/
/*
SELECT 
SUM(CASE WHEN shipment_id IS NULL OR shipment_id = '' THEN 1 ELSE 0 END) AS null_shipments,
SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS missing_orders,
SUM(CASE WHEN driver_id IS NULL OR driver_id= '' THEN 1 ELSE 0 END ) AS missing_driver_ids,
SUM(CASE WHEN expected_delivery_date IS NULL OR expected_delivery_date = '' THEN 1 ELSE 0 END ) AS delivery_dates,
SUM(CASE WHEN actual_delivery_date IS NULL OR actual_delivery_date = '' THEN 1 ELSE 0 END ) AS actual_date,
SUM(CASE WHEN delivery_status IS NULL OR delivery_status = '' THEN 1 ELSE 0 END ) AS missing_status,
SUM(CASE WHEN delivery_region IS NULL OR delivery_region= '' THEN 1 ELSE 0 END ) AS missing_region,
SUM(CASE WHEN SLA_days IS NULL OR SLA_days= '' THEN 1 ELSE 0 END) AS missing_sla
FROM logistics_shipments_raw;
*/

-- CREATE TABLE logistics_orders_clean LIKE logistics_orders_raw;

-- INSERT INTO logistics_orders_clean
-- SELECT * FROM logistics_orders_raw;
-- SELECT COUNT(*) FROM logistics_orders_clean;
-- TRUNCATE TABLE logistics_orders_clean;

-- INSERT INTO logistics_orders_clean
-- SELECT * FROM logistics_orders_raw;
/*
select order_id ,COUNT(*) AS duplicates
from logistics_orders_clean
GROUP BY order_id
HAVING COUNT(*)  > 1;
*/
/*
SELECT *
FROM logistics_orders_clean
WHERE order_id IN (
    SELECT order_id
    FROM logistics_orders_clean
    GROUP BY order_id
    HAVING COUNT(*) > 1
)
ORDER BY order_id;
*/
-- SET SQL_SAFE_UPDATES = 0;
/*
SELECT sales_person, COUNT(*) 
FROM logistics_orders_clean 
GROUP BY sales_person 
ORDER BY sales_person;
*/
/*
UPDATE logistics_orders_clean
SET sales_person = CASE
    WHEN LOWER(TRIM(sales_person)) IN ('ARJUN') THEN 'Arjun'
    WHEN LOWER(TRIM(sales_person)) IN ('priya') THEN 'Priya'
    WHEN LOWER(TRIM(sales_person)) IN ('Rahul') THEN 'Rahul'
    WHEN LOWER(TRIM(sales_person)) IN ('sara') THEN 'Sara'
    WHEN LOWER(TRIM(sales_person)) IN ('Meera') THEN 'Meera'
    WHEN LOWER(TRIM(sales_person)) IN ('Divya') THEN 'Divya'
    WHEN LOWER(TRIM(sales_person)) IN ('vijay') THEN 'Vijay'
    ELSE sales_person
END;
*/
/*
UPDATE logistics_orders_clean
SET sales_person = 'UNKNOWN'
WHERE sales_person IS NULL;
*/

/*
SELECT category, COUNT(*) 
FROM logistics_orders_clean 
GROUP BY category 
ORDER BY category;
*/
/*
UPDATE logistics_orders_clean
SET category = 'unknown'
WHERE category IS NULL;
*/
/*
UPDATE logistics_orders_clean
SET units_sold = NULL,
     unit_price = NULL,
     total_amount = NULL
WHERE units_sold = ''
   OR unit_price = ''
   OR total_amount = '';
*/
/*
ALTER TABLE logistics_orders_clean
 MODIFY COLUMN units_sold INT,
  MODIFY COLUMN unit_price INT,
   MODIFY COLUMN total_amount INT;
*/
/*
SELECT COUNT(*) FROM logistics_orders_clean
WHERE units_sold IS NULL;
*/
-- SET SQL_SAFE_UPDATES = 0;

-- SELECT DISTINCT order_date FROM logistics_orders_clean LIMIT 20;
/*
SELECT 
order_date,

CASE

    -- Already correct YYYY-MM-DD
    WHEN order_date LIKE '____-__-__'
        THEN order_date

    -- DD-Mon-YY like 23-Aug-24
    WHEN order_date LIKE '%-___-__'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%d-%b-%y'),
            '%Y-%m-%d'
        )

    -- DD-MM-YYYY like 25-07-2023
    WHEN order_date LIKE '__-__-____'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%d-%m-%Y'),
            '%Y-%m-%d'
        )

    -- DD/MM/YYYY like 20/05/2024
    WHEN order_date LIKE '%/%/%'
        AND CAST(SUBSTRING_INDEX(order_date,'/',1) AS UNSIGNED) > 12
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%d/%m/%Y'),
            '%Y-%m-%d'
        )

    -- M/D/YYYY like 4/17/2024
    WHEN order_date LIKE '%/%/%'
        AND CAST(
            SUBSTRING_INDEX(
                SUBSTRING_INDEX(order_date,'/',2),
            '/',-1) AS UNSIGNED
        ) > 12
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%m/%d/%Y'),
            '%Y-%m-%d'
        )

    -- Default MM/DD/YYYY
    WHEN order_date LIKE '%/%/%'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%m/%d/%Y'),
            '%Y-%m-%d'
        )

    ELSE order_date

END AS cleaned_date

FROM logistics_orders_clean;
*/
/*
UPDATE logistics_orders_clean
SET order_date = CASE

    -- Already correct format
    WHEN order_date LIKE '____-__-__'
        THEN order_date

    -- DD-Mon-YY (23-Aug-24)
    WHEN order_date LIKE '%-___-__'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%d-%b-%y'),
            '%Y-%m-%d'
        )

    -- MM-DD-YYYY (04-17-2024)
    WHEN order_date LIKE '__-__-____'
    AND CAST(SUBSTRING_INDEX(order_date,'-',1) AS UNSIGNED) <= 12
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%m-%d-%Y'),
            '%Y-%m-%d'
        )

    -- DD-MM-YYYY (25-07-2023)
    WHEN order_date LIKE '__-__-____'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%d-%m-%Y'),
            '%Y-%m-%d'
        )

    -- DD/MM/YYYY (20/05/2024)
    WHEN order_date LIKE '%/%/%'
    AND CAST(SUBSTRING_INDEX(order_date,'/',1) AS UNSIGNED) > 12
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%d/%m/%Y'),
            '%Y-%m-%d'
        )

    -- MM/DD/YYYY (4/17/2024)
    WHEN order_date LIKE '%/%/%'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date,'%m/%d/%Y'),
            '%Y-%m-%d'
        )

    ELSE order_date

END;
*/
/*
SELECT order_date
FROM logistics_orders_clean
LIMIT 20;
*/

/*
UPDATE logistics_orders_clean
SET order_date = DATE_FORMAT(
        STR_TO_DATE(order_date,'%m/%d/%Y'),
        '%Y-%m-%d'
)
WHERE order_date LIKE '%/%/%';
*/
/*
SELECT DISTINCT order_date FROM logistics_orders_clean
WHERE order_date NOT LIKE '____-__-__'
LIMIT 20;
*/
/*
UPDATE logistics_orders_clean
SET order_date = CASE

    -- Format: May 22, 2024
    WHEN order_date LIKE '%,%'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date, '%M %d, %Y'),
            '%Y-%m-%d'
        )

    -- Format: 23-Aug-2024
    WHEN order_date LIKE '__-___-____'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date, '%d-%b-%Y'),
            '%Y-%m-%d'
        )

    -- Format: 23-Aug-24
    WHEN order_date LIKE '__-___-__'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date, '%d-%b-%y'),
            '%Y-%m-%d'
        )

    -- Format: 5/22/2024
    WHEN order_date LIKE '%/%/%'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date, '%m/%d/%Y'),
            '%Y-%m-%d'
        )

    ELSE order_date

END;
*/
-- DESCRIBE logistics_orders_clean;
-- select order_date from logistics_orders_clean;
/*
ALTER TABLE logistics_orders_clean
MODIFY COLUMN order_date DATE;
*/