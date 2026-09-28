-- Xom Data · Giá trị trọn đời trung bình của mỗi thế hệ
-- Problem: https://xomdata.com/practice/hard-ltv-001
-- Solved: 2026-09-28

WITH cte AS(
    SELECT customer_id, strftime('%Y-%m',order_date) AS cohort_month, SUM(amount) AS total_amount FROM orders
    GROUP BY customer_id
)

SELECT cohort_month, COUNT(customer_id) AS cohort_size, ROUND(AVG(total_amount),2) AS avg_ltv 
FROM cte
GROUP BY cohort_month
