-- Problem: Identify customers who have returned more than 50% of their orders
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/1-return-orders-customer-feedback?question_type=0&page=1
-- Difficulty: Medium
-- Concepts: Joins, Aggregation, HAVING clause, Percentage calculation, Formatting

-- Approach:
-- 1. Join the orders table with the returns table using order_id to identify returned orders.
-- 2. For each customer, count total distinct orders and total distinct returned orders.
-- 3. Calculate return percentage as (returned_orders / total_orders) * 100.
-- 4. Filter customers whose return percentage is greater than 50%.
-- 5. Round the return percentage to 2 decimal places and sort results by customer name.

SELECT
    a.customer_name,
    FORMAT(
        (CAST(COUNT(DISTINCT b.order_id) AS DOUBLE) / COUNT(DISTINCT a.order_id)) * 100,
        2
    ) AS return_perc
FROM orders a
LEFT JOIN returns b
    ON a.order_id = b.order_id
GROUP BY a.customer_name
HAVING
    CAST(COUNT(DISTINCT b.order_id) AS DOUBLE) / COUNT(DISTINCT a.order_id) > 0.5
ORDER BY a.customer_name;
