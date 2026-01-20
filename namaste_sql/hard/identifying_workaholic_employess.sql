-- Problem: Find Workaholic Employees working > 10 hours (twice a week) or > 8 hours (thrice a week) 
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/14-workaholics-employees?question_type=0&page=1&complete_status=1 
-- Concepts: Aggregation, Joins, Window functions

-- Approach:
-- 1. Find the total hours each employee works
-- 2. Create flags to identify if an employee works over 8 or 10 hours respectively
-- 3. Define the cateogries to identify those who worked > 8 hours or 10 hours or both

WITH base AS (
	SELECT emp_id,
	sum(CASE WHEN HOUR(TIMEDIFF(logout,login)) >= 8 THEN 1 ELSE 0 END) AS over_8_hours,
	sum(CASE WHEN HOUR(TIMEDIFF(logout,login)) >= 10 THEN 1 ELSE 0 END) AS over_10_hours
	FROM employees
	GROUP BY 1
)

SELECT emp_id,
CASE WHEN over_8_hours >= 3 AND over_10_hours < 2 THEN 1
	 when over_8_hours < 3 AND over_10_hours >= 2 THEN 2
	 when over_8_hours >= 3 AND over_10_hours >= 2 THEN 'Both' END
	 AS criteria
FROM base
ORDER BY 1