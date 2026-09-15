CREATE OR REFRESH STREAMING TABLE restaurants
(
    CONSTRAINT valid_restaurant_id EXPECT (restaurant_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_opening_date EXPECT (opening_date IS NOT NULL)
)
AS SELECT 
    restaurant_id,
    `name`,
    city,
    country,
    address,
    opening_date,
    phone,
    current_timestamp() AS ingestion_date
FROM STREAM(
    ${catalog}.${schema_bronze}.restaurants_landing
);