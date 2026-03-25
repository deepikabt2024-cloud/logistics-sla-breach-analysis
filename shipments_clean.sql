-- cleaning of shpments table --

-- SELECT * FROM logistics_shipments_raw LIMIT 20;
-- CREATE TABLE logistics_shipments_clean LIKE logistics_shipments_raw;
-- INSERT INTO logistics_shipments_clean
 -- SELECT * FROM logistics_shipments_raw;
 -- SELECT COUNT(*) FROM logistics_shipments_clean;
 /*
 SELECT shipment_id, COUNT(*) AS duplicate_count
 FROM logistics_shipments_clean
 GROUP BY shipment_id
 HAVING COUNT(*) > 1;
*/
/*
SELECT * 
FROM logistics_shipments_clean
WHERE shipment_id IN(
SELECT shipment_id 
FROM logistics_shipments_clean
GROUP BY shipment_id
HAVING COUNT(*) > 1 -- HAS DUPLICATES
)
ORDER BY shipment_id;
*/
/*
SELECT order_id, count(*) as duplicate_count
from logistics_shipments_clean
GROUP BY order_id
HAVING COUNT(*) > 1;
*/ -- HAS DUPLICATES

-- SET SQL_SAFE_UPDATES = 0;
/*
UPDATE logistics_shipments_clean
SET driver_id = NULL
WHERE driver_id = '';
*/
/*
ALTER TABLE logistics_shipments_clean
MODIFY COLUMN driver_id INT;
*/
/*
 SELECT expected_delivery_date
 FROM logistics_shipments_clean LIMIT 20;
 */
 /*
SELECT DISTINCT expected_delivery_date
FROM logistics_shipments_clean
LIMIT 50;
*/
/*
SELECT
CASE
WHEN expected_delivery_date LIKE '____-__-__' THEN 'YYYY-MM-DD'
WHEN expected_delivery_date LIKE '__/__/____' THEN 'MM/DD/YYYY'
WHEN expected_delivery_date LIKE '__-__-____' THEN 'DD-MM-YYYY'
WHEN expected_delivery_date LIKE '% %, ____' THEN 'Month DD, YYYY'
ELSE 'Other'
END AS date_format,
COUNT(*) AS total_rows
FROM logistics_shipments_clean
GROUP BY date_format;
*/
/*
UPDATE logistics_shipments_clean
SET expected_delivery_date =
DATE_FORMAT(STR_TO_DATE(expected_delivery_date,'%d-%b-%Y'),'%Y-%m-%d')
WHERE expected_delivery_date LIKE '%-%-%'
AND expected_delivery_date REGEXP '[A-Za-z]';
*/
/*
UPDATE logistics_shipments_clean
SET expected_delivery_date =
CASE

WHEN expected_delivery_date LIKE '____-__-__'
THEN DATE_FORMAT(STR_TO_DATE(expected_delivery_date,'%Y-%m-%d'),'%Y-%m-%d')

WHEN expected_delivery_date LIKE '__/__/____'
THEN DATE_FORMAT(STR_TO_DATE(expected_delivery_date,'%d/%m/%Y'),'%Y-%m-%d')

WHEN expected_delivery_date LIKE '__-__-____'
AND CAST(SUBSTRING_INDEX(expected_delivery_date,'-',1) AS UNSIGNED) > 12
THEN DATE_FORMAT(STR_TO_DATE(expected_delivery_date,'%d-%m-%Y'),'%Y-%m-%d')

WHEN expected_delivery_date LIKE '__-__-____'
THEN DATE_FORMAT(STR_TO_DATE(expected_delivery_date,'%m-%d-%Y'),'%Y-%m-%d')

WHEN expected_delivery_date LIKE '__-___-____'
THEN DATE_FORMAT(STR_TO_DATE(expected_delivery_date,'%d-%b-%Y'),'%Y-%m-%d')

WHEN expected_delivery_date LIKE '% %, ____'
THEN DATE_FORMAT(STR_TO_DATE(expected_delivery_date,'%M %d, %Y'),'%Y-%m-%d')

WHEN expected_delivery_date LIKE '________'
THEN DATE_FORMAT(STR_TO_DATE(expected_delivery_date,'%Y%m%d'),'%Y-%m-%d')

END;
*/
/*
ALTER TABLE logistics_shipments_clean
MODIFY COLUMN expected_delivery_date DATE;
*/
/*
SELECT DISTINCT actual_delivery_date 
FROM logistics_shipments_clean
LIMIT 30;
*/
/*
UPDATE logistics_shipments_clean
SET actual_delivery_date = NULL
WHERE actual_delivery_date = '';
*/


/*
UPDATE logistics_shipments_clean
SET actual_delivery_date =
CASE

WHEN actual_delivery_date LIKE '____-__-__'
THEN DATE_FORMAT(STR_TO_DATE(actual_delivery_date,'%Y-%m-%d'),'%Y-%m-%d')

WHEN actual_delivery_date LIKE '__/__/____'
THEN DATE_FORMAT(STR_TO_DATE(actual_delivery_date,'%d/%m/%Y'),'%Y-%m-%d')

WHEN actual_delivery_date LIKE '__-__-____'
AND CAST(SUBSTRING_INDEX(actual_delivery_date,'-',1) AS UNSIGNED) > 12
THEN DATE_FORMAT(STR_TO_DATE(actual_delivery_date,'%d-%m-%Y'),'%Y-%m-%d')

WHEN actual_delivery_date LIKE '__-__-____'
THEN DATE_FORMAT(STR_TO_DATE(actual_delivery_date,'%m-%d-%Y'),'%Y-%m-%d')

WHEN actual_delivery_date LIKE '__-___-____'
THEN DATE_FORMAT(STR_TO_DATE(actual_delivery_date,'%d-%b-%Y'),'%Y-%m-%d')

WHEN actual_delivery_date LIKE '% %, ____'
THEN DATE_FORMAT(STR_TO_DATE(actual_delivery_date,'%M %d, %Y'),'%Y-%m-%d')

WHEN actual_delivery_date LIKE '________'
THEN DATE_FORMAT(STR_TO_DATE(actual_delivery_date,'%Y%m%d'),'%Y-%m-%d')

END;
*/
-- ALTER TABLE logistics_shipments_clean
-- MODIFY COLUMN actual_delivery_date DATE;

 -- ALTER TABLE logistics_shipments_clean
-- MODIFY COLUMN SLA_days INT;
/*
CREATE TABLE logistics_orders_final AS
SELECT DISTINCT * FROM logistics_orders_clean; 
*/
/*
CREATE TABLE logistics_shipments_final AS
SELECT DISTINCT * FROM logistics_shipments_clean;
*/
/*
CREATE TABLE logistics_drivers_final AS
SELECT DISTINCT * FROM logistics_drivers_raw; 
*/

