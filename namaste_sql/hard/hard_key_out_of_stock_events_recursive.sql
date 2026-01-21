-- Problem: Key Out-of-Stock Events
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/144-key-out-of-stock-events?question_type=0
-- Concepts: Recursive CTE, ROW_NUMBER, Window Functions, Date Arithmetic, Event Chaining

-- Approach:
-- 1. Assign a sequential row number to OOS events for each (MASTER_ID, MARKETPLACE_ID)
--    ordered by OOS_DATE.
-- 2. Use a recursive CTE to iterate through events in sequence.
-- 3. Start with the earliest OOS event (rn = 1) and mark it as valid.
-- 4. For each subsequent event, compare its OOS_DATE with the last selected valid OOS_DATE.
-- 5. If the current OOS_DATE is at least 7 days after the previous valid event,
--    mark it as a valid key OOS event.
-- 6. Filter and return only valid key OOS events.
-- 7. Order the final result by MASTER_ID, MARKETPLACE_ID, and OOS_DATE.

WITH RECURSIVE events AS (
    SELECT
        master_id,
        marketplace_id,
        oos_date,
        ROW_NUMBER() OVER (
            PARTITION BY master_id, marketplace_id
            ORDER BY oos_date
        ) AS rn
    FROM DETAILED_OOS_EVENTS
),

base AS (
    -- Anchor: first OOS event per product & marketplace
    SELECT
        master_id,
        marketplace_id,
        oos_date,
        rn,
        1 AS valid
    FROM events
    WHERE rn = 1

    UNION ALL

    -- Recursive step: evaluate next OOS event in sequence
    SELECT
        e.master_id,
        e.marketplace_id,
        CASE
            WHEN e.oos_date >= b.oos_date + INTERVAL '7' DAY
            THEN e.oos_date
            ELSE b.oos_date
        END AS oos_date,
        e.rn,
        CASE
            WHEN e.oos_date >= b.oos_date + INTERVAL '7' DAY
            THEN 1
        END AS valid
    FROM events e
    JOIN base b
        ON b.master_id = e.master_id
       AND b.marketplace_id = e.marketplace_id
       AND e.rn = b.rn + 1
)

SELECT
    master_id,
    marketplace_id,
    oos_date
FROM base
WHERE valid = 1
ORDER BY
    master_id,
    marketplace_id,
    oos_date;
