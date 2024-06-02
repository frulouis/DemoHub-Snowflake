--!jinja

{% set environments = ['dev', 'qa', 'staging', 'prod'] %}
{% set DATA_PRODUCT = "ORDERS" %}  
   
{% set BU_GEO = "US" %}

{% for environment in environments %}

    {% set s3_url = 's3://demohubpublic/data/' %}
{% endfor %}
