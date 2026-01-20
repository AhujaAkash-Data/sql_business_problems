-- Problem: Find product reviews containing 'excellent' or 'amazing'
--          but exclude cases where 'not' appears immediately before them
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/38-product-reviews
-- Difficulty: Easy
-- Concepts: REGEXP_LIKE, Case-insensitive matching, Text filtering

SELECT
    review_id,
    product_id,
    review_text
FROM product_reviews
WHERE
    REGEXP_LIKE(LOWER(review_text), 'excellent|amazing')
    AND NOT REGEXP_LIKE(LOWER(review_text), 'not excellent|not amazing')
ORDER BY review_id;
