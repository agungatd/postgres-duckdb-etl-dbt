{{ config(materialized='view', database='postgres_source', schema='public') }}

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    created_at AS customer_created_at
FROM
    {{ source('postgres_source', 'customers') }}