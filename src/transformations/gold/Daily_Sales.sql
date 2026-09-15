CREATE OR REFRESH MATERIALIZED VIEW daily_sales_summary AS
SELECT
    order_date,
    is_weekend,
    day_of_week,
    count(order_id) AS total_orders,
    sum(total_amount) AS total_revenue,
    avg(total_amount) AS avg_order_value,
    COUNT(CASE WHEN order_type = 'takeaway' THEN order_id END) AS takeaway_orders,
    COUNT(CASE WHEN order_type = 'dine_in' THEN order_id END) AS dine_in_orders,
    COUNT(CASE WHEN order_type = 'delivery' THEN order_id END) AS delivery_orders
FROM ${catalog}.${schema_silver}.orders
GROUP BY order_date, is_weekend, day_of_week
ORDER BY order_date DESC