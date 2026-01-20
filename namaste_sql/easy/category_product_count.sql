-- Problem: Category Product Count
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/73-category-product-count?question_type=0
-- Concepts: String Functions, LENGTH, REPLACE, Aggregation

-- Approach:
-- 1. Use string functions to count the number of commas in the products list.
-- 2. The number of products is commas + 1 (since products are comma-separated).
-- 3. Return category and product count.
-- 4. Sort results by product count and category in ascending order.

SELECT
    category,
    LENGTH(products) - LENGTH(REPLACE(products, ',', '')) + 1 AS prod_count
FROM categories
ORDER BY
    prod_count,
    category;
