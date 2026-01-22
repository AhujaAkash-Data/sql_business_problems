-- Problem: Employees Current Salary
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/150-employees-current-salary?question_type=0
-- Concepts: Recursive CTE, ROW_NUMBER, Window Functions, Salary Compounding, UNION ALL

-- Approach:
-- 1. Assign a sequential order to each promotion per employee using ROW_NUMBER
--    ordered by promotion_date.
-- 2. Use a recursive CTE to calculate salary progression:
--    a) Anchor step initializes salary after the first promotion.
--    b) Recursive step compounds salary for subsequent promotions using
--       the previously calculated salary.
-- 3. Extract the final (latest) salary per employee by taking the maximum
--    computed salary across promotions.
-- 4. Handle employees with no promotions separately by retaining their
--    joining salary as the current salary.
-- 5. Round the final salary to 1 decimal place.
-- 6. Order the result by employee id.

WITH RECURSIVE promotions_data AS (
    SELECT
        emp_id,
        promotion_date,
        percent_increase,
        ROW_NUMBER() OVER (
            PARTITION BY emp_id
            ORDER BY promotion_date
        ) AS rn
    FROM promotions
),

base AS (
    -- Anchor: first promotion per employee
    SELECT
        e.id,
        e.name,
        e.joining_salary,
        p.rn,
        e.joining_salary * (1 + p.percent_increase / 100.0) AS new_salary
    FROM employees e
    JOIN promotions_data p
        ON p.emp_id = e.id
    WHERE p.rn = 1

    UNION ALL

    -- Recursive: apply subsequent promotions sequentially
    SELECT
        b.id,
        b.name,
        b.joining_salary,
        p.rn,
        b.new_salary * (1 + p.percent_increase / 100.0) AS new_salary
    FROM base b
    JOIN promotions_data p
        ON p.emp_id = b.id
       AND p.rn = b.rn + 1
),

final AS (
    SELECT
        id,
        name,
        joining_salary,
        rn AS promotion_number,
        new_salary
    FROM base
)

-- Employees with no promotions
SELECT
    e.id,
    e.name,
    e.joining_salary,
    ROUND(e.joining_salary, 1) AS current_salary
FROM employees e
WHERE e.id NOT IN (
    SELECT DISTINCT emp_id FROM promotions
)

UNION ALL

-- Employees with promotions (take latest salary)
SELECT
    id,
    name,
    joining_salary,
    ROUND(MAX(new_salary), 1) AS current_salary
FROM final
GROUP BY
    id,
    name,
    joining_salary
ORDER BY
    id;
