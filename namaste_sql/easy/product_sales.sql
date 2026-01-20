-- Problem: Product Sales
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/72-product-sales?question_type=0
-- Concepts: JOIN, Aggregation, SUM, GROUP BY

-- Approach:
-- 1. Join Sales with Products using product_id to get product price and name.
-- 2. Calculate total sales amount for each product using SUM(quantity * price).
-- 3. Group by product name to get totals per product.
-- 4. Sort the result by product name in ascending order.

SELECT
    b.product_name,
    SUM(a.quantity * b.price) AS total_sales
FROM sales a
LEFT JOIN products b
    ON b.product_id = a.product_id
GROUP BY
    b.product_name
ORDER BY
    b.product_name;
