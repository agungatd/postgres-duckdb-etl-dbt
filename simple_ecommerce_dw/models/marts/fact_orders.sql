{{ config(materialized='table') }}

SELECT
    ord.order_id,
    ord.customer_id,
    oi.product_id,
    CAST(ord.order_date as DATE) as order_date_key,
    ord.order_status,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_item_total,
    ord.total_amount
FROM
    {{ ref('stg_orders') }} AS ord
INNER JOIN
    {{ ref('stg_order_items') }} AS oi ON ord.order_id = oi.order_id