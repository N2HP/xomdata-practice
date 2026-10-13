-- Xom Data · How much is left after one month
-- Problem: https://xomdata.com/practice/hard-retention-002
-- Solved: 2026-10-13

WITH cte AS(
    SELECT customer_id as id, MIN(order_date) AS min_month
    FROM orders GROUP BY customer_id 

), ctd AS(
    SELECT strftime('%Y-%m',c.min_month) AS cohort_month, COUNT(DISTINCT customer_id) AS cohort_size,
    SUM(CASE WHEN (strftime('%Y',o.order_date) - strftime('%Y',c.min_month) )*12 + strftime('%m',o.order_date) - strftime('%m',c.min_month)  = 1 THEN 1 ELSE 0 END) AS retained_m1 

    FROM orders o JOIN cte c ON o.customer_id = c.id
    GROUP BY strftime('%Y-%m',c.min_month)
)

SELECT ctd.*, 
ROUND(((retained_m1*100.0)/cohort_size ),2) AS retention_pct 

FROM ctd
