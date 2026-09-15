CREATE OR REFRESH MATERIALIZED VIEW customer_behavior AS
WITH orders_items_summary AS (
    WITH restaurant_orders AS (
        SELECT
            customer_id,
            o.restaurant_id,
            r.`name` AS restaurant_name,
            count(*) AS total_orders,
            max(order_timestamp) AS last_order_date_orders
        FROM ${catalog}.${schema_silver}.orders o
        INNER JOIN ${catalog}.${schema_silver}.restaurants r
        ON o.restaurant_id = r.restaurant_id
        GROUP BY customer_id, o.restaurant_id, r.`name`
    ),
    item_orders AS (
        SELECT
            o.customer_id,
            item_id,
            item_name,
            o_i.restaurant_id,
            restaurant_name,
            count(*) AS total_items,
            total_orders,
            max(o_i.order_timestamp) AS last_order_date_orders
        FROM ${catalog}.${schema_silver}.order_items o_i
        INNER JOIN ${catalog}.${schema_silver}.orders o
        ON o.order_id = o_i.order_id
        INNER JOIN restaurant_orders r_o
        ON o.restaurant_id = r_o.restaurant_id AND o.customer_id = r_o.customer_id
        GROUP BY o.customer_id, item_id, o_i.restaurant_id, item_name, total_orders,restaurant_name
    )
    SELECT
        customer_id,
        restaurant_id AS favorite_restaurant_id,
        restaurant_name AS favorite_restaurant_name,
        total_orders,
        total_items,
        item_name AS favorite_item
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY total_orders DESC, last_order_date_orders DESC
            ) AS rn
        FROM item_orders
    ) ranking -- ranking is the name of the sub query result
    WHERE rn = 1),
customer_summary AS (
    SELECT
        o.customer_id,
        c.name,
        c.email,
        c.phone,
        c.city,
        c.join_date,
        count(*) AS total_orders,
        sum(cast(total_amount AS DECIMAL(18,2))) AS lifetime_spend,
        avg(cast(total_amount AS DECIMAL(18,2))) AS avg_order_value,
        max(order_date) AS last_order_date,
        CASE
            WHEN last_order_date > (current_date() - INTERVAL 90 DAY) THEN FALSE
            ELSE TRUE
        END AS is_at_risk
    FROM ${catalog}.${schema_silver}.orders o
    INNER JOIN ${catalog}.${schema_silver}.customers c
    ON o.customer_id = c.customer_id
    GROUP BY o.customer_id,
            c.name,
            c.email,
            c.phone,
            c.city,
            c.join_date
),
reviews_summary AS (
    SELECT
        customer_id,
        count(*) AS total_reviews,
        avg(cast(rating AS DECIMAL(18,2))) AS avg_rating
    FROM ${catalog}.${schema_silver}.reviews
    GROUP BY customer_id
)
SELECT
    a.customer_id,
    a.name,
    a.email,
    a.phone,
    a.city,
    a.join_date,
    a.total_orders,
    a.lifetime_spend,
    a.avg_order_value,
    a.last_order_date,
    c.favorite_restaurant_id,
    c.favorite_restaurant_name,
    c.favorite_item,
    coalesce(b.total_reviews,0) AS total_reviews,
    coalesce(b.avg_rating,0) AS avg_rating,
    a.is_at_risk
FROM customer_summary a
LEFT JOIN reviews_summary b
ON a.customer_id = b.customer_id
INNER JOIN orders_items_summary c
ON a.customer_id = c.customer_id