-- Problem: Calculate total sales per product using dynamic pricing based on order date
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/26-dynamic-pricing?question_type=0&page=1
-- Difficulty: Medium
-- Concepts: Window Functions, LEAD, Date Ranges, Joins, Aggregation

-- Approach:
-- 1. Use the products table to create effective price periods for each product
--    by identifying the start and end date for each price using LEAD().
-- 2. Treat price_date as the start_date and the day before the next price_date
--    as the end_date for that price.
-- 3. For the latest price record of a product, use the current date as the end_date.
-- 4. Join orders with the effective price periods using product_id and order_date.
-- 5. Aggregate sales by summing the applicable price for each order.
-- 6. Display the result in ascending order of product_id.

WITH price_det AS (
    SELECT
        product_id,
        price_date AS start_date,
        CASE
            WHEN LEAD(price_date) OVER (
                PARTITION BY product_id
                ORDER BY price_date
            ) IS NOT NULL
            THEN LEAD(price_date) OVER (
                     PARTITION BY product_id
                     ORDER BY price_date
                 ) - INTERVAL 1 DAY
            ELSE CURRENT_DATE
        END AS end_date,
        price
    FROM products
)
SELECT
    o.product_id,
    SUM(p.price) AS total_sales
FROM orders o
LEFT JOIN price_det p
    ON o.product_id = p.product_id
   AND o.order_date BETWEEN p.start_date AND p.end_date
GROUP BY o.product_id
ORDER BY o.product_id;
