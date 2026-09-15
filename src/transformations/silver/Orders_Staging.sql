CREATE OR REFRESH STREAMING TABLE orders 
(
    CONSTRAINT valid_order_id EXPECT (order_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_customer_id EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_timestamp EXPECT (order_timestamp IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_restaurant_id EXPECT (restaurant_id IS NOT NULL)
)
AS SELECT 
    order_id,
    to_timestamp(`timestamp`) AS order_timestamp,
    date(`timestamp`) AS order_date,
    hour(`timestamp`) AS order_hour,
    dayname(`timestamp`) AS day_of_week,
    CASE
        WHEN dayofweek(`timestamp`) in (1,7) THEN true
        ELSE false
    END AS is_weekend,
    restaurant_id,
    customer_id,
    order_type,
    size(parse_json(items)::ARRAY<VARIANT>) AS item_count,
    total_amount,
    payment_method,
    order_status,
    current_timestamp() AS ingestion_date
FROM STREAM(
    ${catalog}.${schema_bronze}.orders_landing
);