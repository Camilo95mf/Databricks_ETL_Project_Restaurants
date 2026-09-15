CREATE OR REFRESH STREAMING TABLE reviews
(
    CONSTRAINT valid_order_id EXPECT (order_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_customer_id EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_timestamp EXPECT (review_timestamp IS NOT NULL),
    CONSTRAINT valid_restaurant_id EXPECT (restaurant_id IS NOT NULL) ON VIOLATION DROP ROW
)
AS SELECT 
    review_id,
    order_id,
    customer_id,
    restaurant_id,
    rating,
    review_text,
    to_timestamp(review_timestamp) AS review_timestamp,
    current_timestamp() AS ingestion_date
FROM STREAM(
    ${catalog}.${schema_bronze}.customer_reviews_landing
);