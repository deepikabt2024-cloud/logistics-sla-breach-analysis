-- DATA LOAD OF LIGISTICS --
-- CREATE DATABASE logistics_data;
/*
CREATE TABLE logistics_orders_raw(
order_id VARCHAR(20),
sales_person VARCHAR(20),
category VARCHAR(15),
city VARCHAR(20),
region VARCHAR(10),
units_sold VARCHAR(10),
unit_price VARCHAR(10),
total_amount VARCHAR(15),
payment_method VARCHAR(20),
order_date VARCHAR(25)
);
*/

/*
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/logistics_orders.csv'
INTO TABLE logistics_orders_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(order_id,
 sales_person,
 category,
 city,
 region,
 units_sold,
 unit_price,
 total_amount,
 payment_method,
 order_date
);
*/
-- DROP TABLE logistics_shipments_raw;
/*
CREATE TABLE logistics_shipments_raw(
shipment_id VARCHAR(15),
order_id VARCHAR(15),
driver_id VARCHAR(5),
expected_delivery_date VARCHAR(25),
actual_delivery_date VARCHAR(20),
delivery_status VARCHAR(15),
delivery_region VARCHAR(10),
SLA_days VARCHAR(5)
);
*/
/*
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/logistics_shipments.csv'
INTO TABLE logistics_shipments_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(shipment_id,
order_id,
 driver_id,
 expected_delivery_date,
 actual_delivery_date,
 delivery_status,
 delivery_region,
 SLA_days
 );
 */
 /*
 CREATE TABLE logistics_drivers_raw(
 driver_id INT,
 driver_name VARCHAR(25),
 region VARCHAR(10),
 license_no VARCHAR(15),
 rating DECIMAL(3,1)
 );
 */
 /*
 LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/logistics_drivers.csv'
INTO TABLE logistics_drivers_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(driver_id,
driver_name,
region,
license_no,
rating );
