-- Problem: Project Budget Forecast
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/125-project-budget?question_type=0
-- Concepts: JOINs, Date Arithmetic, Aggregation, CASE WHEN, CTE

-- Approach:
-- 1. Derive project duration in days using start_date and end_date.
-- 2. Allocate each employee’s annual salary on a per-day basis (salary / 365).
-- 3. Calculate total projected salary cost for a project by multiplying
--    per-day salary with project duration and summing across all assigned employees.
-- 4. Compare total projected cost with the project budget.
-- 5. Label the project as "overbudget" if projected cost exceeds budget,
--    otherwise label it as "within budget".
-- 6. Order the result by project title.

WITH project_dets AS (
    SELECT
        p.id AS project_id,
        p.title,
        p.start_date,
        p.end_date,
        ROUND(DATEDIFF(p.end_date, p.start_date)) AS project_duration_in_days,
        p.budget
    FROM projects p
)

SELECT
    pd.title,
    pd.budget,
    CASE
        WHEN pd.budget >=
             SUM((e.salary / 365) * pd.project_duration_in_days)
        THEN 'within budget'
        ELSE 'overbudget'
    END AS label
FROM project_employees pe
LEFT JOIN employees e
    ON e.id = pe.employee_id
LEFT JOIN project_dets pd
    ON pd.project_id = pe.project_id
GROUP BY
    pd.title,
    pd.budget
ORDER BY
    pd.title;
