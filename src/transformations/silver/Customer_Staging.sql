CREATE OR REFRESH STREAMING TABLE customers
(
    CONSTRAINT valid_customer_id EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_join_date EXPECT (join_date IS NOT NULL)
)
AS SELECT 
    customer_id,
    `name`,
    email,
    phone,
    city,
    join_date,
    current_timestamp() AS ingestion_date
FROM STREAM(
    ${catalog}.${schema_bronze}.customer_landing
);