-- Xom Data · Churned and returning customers
-- Problem: https://xomdata.com/practice/hard-churn-001
-- Solved: 2026-10-22

WITH cte AS(
    SELECT user_id, order_date AS prev_order, LEAD(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS next_order,
    (LEAD(order_date) OVER(PARTITION BY user_id ORDER BY order_date))::date - order_date::date AS gap_days 
    FROM orders
)

SELECT cte.* FROM cte WHERE gap_days >= 90 AND next_order IS NOT NULL ORDER BY gap_days DESC, user_id
