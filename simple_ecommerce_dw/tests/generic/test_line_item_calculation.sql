{% test line_item_calculation(model_name, column_name) %}

SELECT
    *
FROM
    {{ model_name }}
WHERE
    {{ column_name }} = quantity * unit_price

{% endtest %}