-- Problem: User Session Activity
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/118-user-session-activity?question_type=0
-- Concepts: Window Functions, LAG, SUM OVER, Sessionization, GROUP BY

-- Approach:
-- 1. Use LAG to get the previous event_time per user (ordered by event_time).
-- 2. Flag the start of a new session when the time difference between current and previous event is > 30 minutes.
-- 3. Use cumulative SUM of the flag to generate session numbers per user.
-- 4. Group by userid and session number to calculate session metrics:
--    - session_start_time (MIN event_time)
--    - session_end_time (MAX event_time)
--    - session_duration (difference between start and end)
--    - event_count (number of events in the session)

WITH base_data AS (
    SELECT
        userid,
        event_type,
        event_time,
        LAG(event_time, 1, event_time) OVER (PARTITION BY userid ORDER BY event_time) AS prev_event_time,
        CASE 
            WHEN TIMESTAMPDIFF(
                MINUTE,
                LAG(event_time, 1, event_time) OVER (PARTITION BY userid ORDER BY event_time),
                event_time
            ) > 30 THEN 1 
            ELSE 0 
        END AS is_new_session
    FROM events
),

sessions AS (
    SELECT
        userid,
        event_type,
        event_time,
        SUM(is_new_session) OVER (PARTITION BY userid ORDER BY event_time) AS session
    FROM base_data
)

SELECT
    userid,
    session + 1 AS session_id,
    MIN(event_time) AS session_start_time,
    MAX(event_time) AS session_end_time,
    TIMESTAMPDIFF(MINUTE, MIN(event_time), MAX(event_time)) AS session_duration,
    COUNT(event_time) AS event_count
FROM sessions
GROUP BY
    userid,
    session
ORDER BY
    userid,
    session_id;
