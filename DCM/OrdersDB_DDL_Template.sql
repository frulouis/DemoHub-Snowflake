--!jinja

{% set environments = ['dev', 'qa', 'staging', 'prod'] %}
{% set DATA_PRODUCT = "ORDERS" %}  
   
{% set BU_GEO = "US" %}

{% for environment in environments %}
    {% set database_name = environment + '_' + DATA_PRODUCT + 'db_' + BU_GEO %}
    CREATE OR REPLACE DATABASE {{ database_name }};
    {% set s3_url = 's3://demohubpublic/data/' %}
{% endfor %}
