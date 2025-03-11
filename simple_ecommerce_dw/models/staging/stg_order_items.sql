{{ config(materialized='view', database='postgres_source', schema='public') }}

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price
FROM
    {{ source('postgres_source', 'order_items') }}