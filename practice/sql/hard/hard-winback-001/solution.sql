-- Xom Data · Những người quay về sau hai tháng im ắng
-- Problem: https://xomdata.com/practice/hard-winback-001
-- Solved: 2026-09-28

WITH cte AS(
    SELECT customer_id, order_date, 
    julianday(order_date) - julianday(LAG(order_date,1) OVER(PARTITION BY customer_id ORDER BY order_date)) AS gap_days 
    FROM orders
)
SELECT cte.* FROM cte WHERE gap_days >= 60
