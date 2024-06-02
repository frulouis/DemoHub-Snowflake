--!jinja
 
{% set database_name = 'ordersdb_' + DEPLOYMENT_TYPE + '_' + BU_GEO %}
{% set s3_url = 's3://' + BUCKET_NAME + '/data/orders' %}

-- +----------------------------------------------------+
-- |       1. DATABASE AND SCHEMA SETUP       |
-- +----------------------------------------------------+

CREATE OR REPLACE DATABASE {{ database_name }};
USE DATABASE {{ database_name }};
