{% macro generate_date_dimension(start_date, end_date) %}

    {{dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ start_date ~ "' as date)",
        end_date="cast('" ~ end_date ~ "' as date)"
    )}}

{% endmacro %}