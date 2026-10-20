-- Xom Data · Does anyone return the following week
-- Problem: https://xomdata.com/practice/hard-retention-003
-- Solved: 2026-10-20

WITH cte as(
    SELECT customer_id AS id, ((MIN(order_date::date) - '2024-01-01'::date) / 7) + 1 AS cohort_week FROM orders GROUP BY customer_id

), ctd AS (
    SELECT DISTINCT o.order_id, o.customer_id,
    (((order_date::date) - '2024-01-01'::date) / 7) + 1 AS week,
    cohort_week 
    FROM orders o JOIN cte c ON c.id = o.customer_id
    
), ctc AS (
    SELECT DISTINCT customer_id, 
    CASE WHEN week - cohort_week = 1 THEN 1 END AS retained_next_week, cohort_week
    FROM ctd
)

SELECT cohort_week, COUNT(DISTINCT customer_id) AS cohort_size, 
COUNT(DISTINCT CASE WHEN retained_next_week = 1 THEN customer_id END) AS retained_next_week
FROM ctc
GROUP BY cohort_week
