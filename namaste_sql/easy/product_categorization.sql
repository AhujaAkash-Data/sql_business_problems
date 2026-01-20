-- Problem: Count number of products by price category
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/2-product-category?question_type=0&page=1
-- Difficulty: Easy
-- Concepts: CASE statement, Aggregation, GROUP BY, ORDER BY

-- Approach:
-- 1. Categorize each product into Low, Medium, or High price using a CASE expression.
-- 2. Group products by the derived price category.
-- 3. Count the number of distinct products in each category.
-- 4. Sort the result in descending order of product count.

SELECT
    CASE
        WHEN price > 500 THEN 'High Price'
        WHEN price >= 100 THEN 'Medium Price'
        ELSE 'Low Price'
    END AS category,
    COUNT(DISTINCT product_id) AS total_products
FROM products
GROUP BY category
ORDER BY total_products DESC;
