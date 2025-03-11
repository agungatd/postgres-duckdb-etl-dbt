{{ config(materialized='view', database='postgres_source', schema='public') }}

SELECT
    product_id,
    product_name,
    category,
    price
FROM
    {{ source('postgres_source', 'products') }}