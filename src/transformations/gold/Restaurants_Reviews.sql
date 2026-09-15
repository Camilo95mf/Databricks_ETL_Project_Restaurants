CREATE OR REFRESH MATERIALIZED VIEW restaurant_reviews
SELECT
    a.restaurant_id,
    b.name AS restaurant_name,
    b.city,
    count(*) AS total_reviews,
    avg(cast(a.rating AS DECIMAL(3,2))) AS avg_rating,
    count(CASE WHEN a.rating = 1 THEN 1 END) AS count_1_stars,
    count(CASE WHEN a.rating = 2 THEN 1  END) AS count_2_stars,
    count(CASE WHEN a.rating = 3 THEN 1 END) AS count_3_stars,
    count(CASE WHEN a.rating = 4 THEN 1 END) AS count_4_stars,
    count(CASE WHEN a.rating = 5 THEN 1 END) AS count_5_stars
FROM ${catalog}.${schema_silver}.reviews a
INNER JOIN ${catalog}.${schema_silver}.restaurants b
ON a.restaurant_id = b.restaurant_id
GROUP BY a.restaurant_id, b.name, b.city