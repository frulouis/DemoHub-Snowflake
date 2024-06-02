/*
------------------------------------------------------------------------------
-- Snowflake Demo Script: Orders Data Model-- 
-- Description: 
-- This script sets up a sales data model in Snowflake. It includes the creation of tables for customers, device,
-- sales_order, and sales_order_item, along with sample data insertion and tagging of 
-- columns for PII, lead source, and sales stage. Additionally, it defines RBAC 
-- privileges, functions, stored procedures, and views for analysis purposes.
--
-- Author: Fru N.
-- Website: DemoHub.dev
--
-- Date: May 26, 2024
--
-- Copyright: (c) 2024 DemoHub.dev. All rights reserved.
--
-- Disclaimer:  
-- This script is for educational and demonstration purposes only. It is not
-- affiliated with or endorsed by Snowflake Computing. Use this code at your 
-- own risk.
------------------------------------------------------------------------------
*/

-- +----------------------------------------------------+
-- |             1. DATABASE AND SCHEMA SETUP             |
-- +----------------------------------------------------+

CREATE OR REPLACE DATABASE ordersdb;
USE ordersdb;

CREATE OR REPLACE FILE FORMAT CSV_SCHEMA_DETECTION
    TYPE = CSV
    PARSE_HEADER = TRUE
    SKIP_BLANK_LINES = TRUE
    TRIM_SPACE = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

CREATE OR REPLACE STAGE DEMOHUB_S3_INT 
    URL = 's3://demohubpublic/data/'
    DIRECTORY = ( ENABLE = true )
    COMMENT = 'DemoHub S3 datasets';


-- +----------------------------------------------------+
-- |             2. LOADING DATA WITH SCHEMATIZATION            |
-- +----------------------------------------------------+
-- Customer
CREATE OR REPLACE TABLE customer USING TEMPLATE (
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
 FROM TABLE (INFER_SCHEMA(
 LOCATION=>'@demohub_s3_int/orders/customer/',
 FILE_FORMAT=>'CSV_SCHEMA_DETECTION')));

-- Device
CREATE OR REPLACE TABLE device USING TEMPLATE (
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
 FROM TABLE (INFER_SCHEMA(
 LOCATION=>'@demohub_s3_int/orders/device/',
 FILE_FORMAT=>'CSV_SCHEMA_DETECTION')));

-- Sales_Order
CREATE OR REPLACE TABLE sales_order USING TEMPLATE (
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
 FROM TABLE (INFER_SCHEMA(
 LOCATION=>'@demohub_s3_int/orders/sales_order/',
 FILE_FORMAT=>'CSV_SCHEMA_DETECTION')));

-- Sales_Order_item
CREATE OR REPLACE TABLE sales_order_item USING TEMPLATE (
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
 FROM TABLE (INFER_SCHEMA(
 LOCATION=>'@demohub_s3_int/orders/sales_order_item/',
 FILE_FORMAT=>'CSV_SCHEMA_DETECTION')));

-- +----------------------------------------------------+
-- |             3. CONSTRAINTS AND REFERENTIAL INTEGRITY            |
-- +----------------------------------------------------+

-- Device table
ALTER TABLE Device ADD PRIMARY KEY (device_id);

-- Customer table
ALTER TABLE Customer ADD PRIMARY KEY (customer_id);

-- Sales_Order table
ALTER TABLE Sales_Order ADD PRIMARY KEY (order_id);
ALTER TABLE Sales_Order ADD CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id);

-- Sales_Order_Item table
ALTER TABLE Sales_Order_Item ADD PRIMARY KEY (order_item_id);
ALTER TABLE Sales_Order_Item ADD CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES Sales_Order(order_id);

-- +----------------------------------------------------+
-- |             4. COPY DATA INTO TABLE             |
-- +----------------------------------------------------+

-- Customer
Copy into customer from '@demohub_s3_int/orders/customer/'
FILE_FORMAT = 'CSV_SCHEMA_DETECTION'
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Device
Copy into device from '@demohub_s3_int/orders/device/'
FILE_FORMAT = 'CSV_SCHEMA_DETECTION'
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Sales_Order
Copy into sales_order from '@demohub_s3_int/orders/sales_order/'
FILE_FORMAT = 'CSV_SCHEMA_DETECTION'
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Sales_Order_Item
Copy into sales_order_item from '@demohub_s3_int/orders/sales_order_item/'
FILE_FORMAT = 'CSV_SCHEMA_DETECTION'
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


