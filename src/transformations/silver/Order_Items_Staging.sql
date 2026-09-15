CREATE OR REFRESH STREAMING TABLE order_items 
(
    CONSTRAINT valid_order_id EXPECT (order_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_item_id EXPECT (item_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_timestamp EXPECT (order_timestamp IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_restaurant_id EXPECT (restaurant_id IS NOT NULL)
) AS SELECT 
    order_id,
    item:item_id::STRING AS item_id,
    restaurant_id,
    order_timestamp,
    order_date,
    item:`name`::STRING AS item_name,
    item:category::STRING AS category,
    item:quantity::DOUBLE AS quantity,
    item:unit_price::DOUBLE AS unit_price,
    item:subtotal::DOUBLE AS subtotal,
    current_timestamp() AS ingestion_date
FROM (
    SELECT
        order_id,
        restaurant_id,
        to_timestamp(`timestamp`) AS order_timestamp,
        date(`timestamp`) AS order_date,
        explode(parse_json(items)::ARRAY<VARIANT>) AS item
    FROM STREAM(
        ${catalog}.${schema_bronze}.orders_landing
    )
);
