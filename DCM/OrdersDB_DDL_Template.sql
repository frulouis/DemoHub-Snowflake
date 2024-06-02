--!jinja

{% set environments = ['dev', 'qa', 'staging', 'prod'] %}

{% for environment in environments %}


   {% set database_name = {{ environment }}+'_' +DATA_PRODUCT+'db_' + BU_GEO %}
   {% set s3_url = 's3://demohubpublic/data/' %}  --Public dataset used for demos. Change this if you have to. 
   
   -- +----------------------------------------------------+
   -- |       1. DATABASE AND SCHEMA SETUP       |
   -- +----------------------------------------------------+
   
   CREATE OR REPLACE DATABASE {{ database_name }};
   USE DATABASE {{ database_name }};
   
   CREATE OR REPLACE FILE FORMAT CSV_SCHEMA_DETECTION TYPE = CSV PARSE_HEADER = TRUE SKIP_BLANK_LINES = TRUE TRIM_SPACE = TRUE ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;
   
   CREATE OR REPLACE STAGE DEMOHUB_S3_INT URL = '{{ s3_url }}' DIRECTORY = (ENABLE = true) COMMENT = 'DemoHub S3 datasets';
   
   -- +----------------------------------------------------+
   -- |       2. LOADING DATA WITH SCHEMATIZATION      |
   -- +----------------------------------------------------+
   
   {% for table_name in ['customer', 'device', 'sales_order', 'sales_order_item'] %}
    CREATE OR REPLACE TABLE {{ table_name }} USING TEMPLATE (SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) FROM TABLE (INFER_SCHEMA(LOCATION => '@demohub_s3_int/orders/{{ table_name }}/', FILE_FORMAT => 'CSV_SCHEMA_DETECTION')));
   {% endfor %}
   
   
   -- +----------------------------------------------------+
   -- |       3. CONSTRAINTS AND REFERENTIAL INTEGRITY      |
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
   -- |       4. COPY DATA INTO TABLE       |
   -- +----------------------------------------------------+
   
   {% for table_name in ['customer', 'device', 'sales_order', 'sales_order_item'] %}
   COPY INTO {{ table_name }} FROM '@demohub_s3_int/orders/{{ table_name }}/' FILE_FORMAT = 'CSV_SCHEMA_DETECTION' MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
   {% endfor %}

{% endfor %}
