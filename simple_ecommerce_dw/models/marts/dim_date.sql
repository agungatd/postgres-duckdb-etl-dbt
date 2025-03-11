{{ config(materialized='table') }}

SELECT
    cast(date_day as date) as date_key,
    EXTRACT(YEAR FROM date_day) AS year,
    EXTRACT(MONTH FROM date_day) AS month,
    EXTRACT(DAY FROM date_day) AS day,
    EXTRACT(DAYOFWEEK FROM date_day) AS day_of_week,
    EXTRACT(WEEK FROM date_day) AS week_of_year,
    CAST(FORMAT_TIMESTAMP('%B', date_day) as VARCHAR) AS month_name,
    CAST(FORMAT_TIMESTAMP('%A', date_day) as VARCHAR) AS day_name,
    CASE WHEN EXTRACT(DAYOFWEEK FROM date_day) IN (1,7) THEN TRUE ELSE FALSE END AS is_weekend
FROM
    {{ generate_date_dimension("2022-01-01", "2025-12-31") }}