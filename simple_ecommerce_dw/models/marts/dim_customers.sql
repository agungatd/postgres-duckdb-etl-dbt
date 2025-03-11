{{ config(materialized='table') }}

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.customer_created_at,
    a.street_address,
    a.city,
    a.state,
    a.postal_code,
    a.country
FROM
    {{ ref('stg_customers') }} AS c
LEFT JOIN 
    {{ ref('stg_addresses') }} AS a
    ON c.customer_id = a.customer_id