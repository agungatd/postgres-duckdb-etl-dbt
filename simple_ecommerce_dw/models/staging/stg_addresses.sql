{{ config(materialized='view', database='postgres_source', schema='public') }}

SELECT
    address_id,
    customer_id,
    street_address,
    city,
    state,
    postal_code,
    country
FROM
    {{ source('postgres_source', 'addresses') }}