-- Problem: Penultimate Order
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/64-penultimate-order?question_type=0&page=1
-- Concepts: Window Functions, ROW_NUMBER, COUNT, CTE, Partitioning

-- Approach:
-- 1. Use a CTE to rank orders for each customer by order_date in descending order.
-- 2. Calculate total number of orders per customer using COUNT over the partition.
-- 3. Filter the results to get:
--    a) the penultimate order (rn = 2) for customers with more than 1 order
--    b) the only order (total_orders = 1) for customers with a single order
-- 4. Order the final output by customer_name in ascending order.

WITH base_data AS (
    SELECT
        a.order_id,
        a.order_date,
        a.customer_name,
        a.product_name,
        a.sales,
        ROW_NUMBER() OVER (
            PARTITION BY customer_name
            ORDER BY order_date DESC
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY customer_name
        ) AS total_orders
    FROM orders a
)

SELECT
    order_id,
    order_date,
    customer_name,
    product_name,
    sales
FROM base_data
WHERE total_orders = 1
   OR rn = 2
ORDER BY customer_name;
