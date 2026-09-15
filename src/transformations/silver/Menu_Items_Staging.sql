CREATE OR REFRESH STREAMING TABLE menu_items
(
    CONSTRAINT valid_item_id EXPECT (item_id IS NOT NULL) ON VIOLATION DROP ROW
)
AS SELECT 
    restaurant_id,
    item_id,
    `name`,
    category,
    price,
    ingredients,
    is_vegetarian,
    spice_level,
    current_timestamp() AS ingestion_date
FROM STREAM(
    ${catalog}.${schema_bronze}.menu_items_landing
);