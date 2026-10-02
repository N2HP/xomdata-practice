-- Xom Data · Thế hệ khách nhìn theo kênh dẫn về
-- Problem: https://xomdata.com/practice/hard-cohort-004
-- Solved: 2026-10-02

WITH cte AS (
    SELECT 
        o.customer_id, 
        MIN(o.order_date) OVER(PARTITION BY o.customer_id) AS min_month, 
        o.order_date, 
        c.signup_date, 
        c.channel
    FROM orders o 
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT channel, strftime('%Y-%m',min_month) AS cohort_month,
COUNT(DISTINCT customer_id) AS cohort_size,
SUM(CASE WHEN  (strftime('%Y',order_date)-strftime('%Y',min_month))* 12 + strftime('%m',order_date)-strftime('%m',min_month) = 1 THEN 1 ELSE 0 END) AS retained_m1 
FROM cte
GROUP BY channel, strftime('%Y-%m',min_month)
