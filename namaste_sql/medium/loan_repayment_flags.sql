-- Problem: Loan Repayment Flags
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/52-loan-repayment
-- Difficulty: Medium
-- Concepts: Aggregation, CASE, LEFT JOIN, NULL handling

WITH loan_dets AS (
    SELECT
        loan_id,
        MAX(payment_date) AS latest_pay_date,
        SUM(amount_paid) AS total_repaid
    FROM payments
    GROUP BY loan_id
)

SELECT
    l.loan_id,
    l.loan_amount,
    l.due_date,
    CASE
        WHEN COALESCE(p.total_repaid, 0) >= l.loan_amount THEN 1
        ELSE 0
    END AS fully_paid_flag,
    CASE
        WHEN COALESCE(p.total_repaid, 0) >= l.loan_amount
             AND p.latest_pay_date <= l.due_date
        THEN 1
        ELSE 0
    END AS on_time_flag
FROM loans l
LEFT JOIN loan_dets p
    ON l.loan_id = p.loan_id
ORDER BY l.loan_id;
