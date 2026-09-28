-- Xom Data · Nhịp mua hàng và tín hiệu rời bỏ
-- Problem: https://xomdata.com/practice/hard-gap-001
-- Solved: 2026-09-28

WITH cte AS(
    SELECT 
    customer_id, julianday(order_date) - julianday(LAG(order_date, 1) OVER(PARTITION BY customer_id ORDER BY order_date)) AS gap_days

    FROM orders

)

SELECT customer_id,
ROUND(AVG(gap_days),1) AS avg_gap_days,
CASE WHEN AVG(gap_days) IS NULL THEN 'single'
WHEN AVG(gap_days) > 30 THEN 'slow'
ELSE 'fast'
END AS pace 
FROM cte
GROUP BY customer_id
