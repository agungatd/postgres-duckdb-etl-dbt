{{ config(materialized='view', database='postgres_source', schema='public') }}

SELECT
    order_id,
    customer_id,
    order_date,
    status AS order_status,  -- Rename for clarity
    total_amount
FROM
    {{ source('postgres_source', 'orders') }}