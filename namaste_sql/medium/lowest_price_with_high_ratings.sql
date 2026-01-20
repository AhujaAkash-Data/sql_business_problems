-- Problem: Lowest Price of Products with High Ratings
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/55-lowest-price?question_type=0&page=1
-- Concepts: LEFT JOIN, Conditional Aggregation, CASE, COALESCE

-- Approach:
-- 1. Join products with purchases to identify products that received at least one rating of 4 or above
-- 2. Use LEFT JOIN to ensure all categories are retained even if no product qualifies
-- 3. Use conditional MIN aggregation to find the lowest price among qualifying products per category
-- 4. Replace NULL with 0 for categories with no qualifying products
-- 5. Sort the result by category in ascending order

SELECT
    a.category,
    COALESCE(
        MIN(CASE WHEN b.product_id IS NOT NULL THEN a.price END),
        0
    ) AS minimum_price
FROM products a
LEFT JOIN purchases b
    ON b.product_id = a.id
   AND b.stars >= 4
GROUP BY a.category
ORDER BY a.category;