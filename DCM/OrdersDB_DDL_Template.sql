--!jinja

{% set environments = ['dev', 'qa', 'staging', 'prod'] %}

{% for environment in environments %}

   {% set database_name = {{ environment }}+'_' +DATA_PRODUCT+'db_' + BU_GEO %}
   {% set s3_url = 's3://demohubpublic/data/' %}  --Public dataset used for demos. Change this if you have to. 

{% endfor %}
