-- Xom Data · Dòng tiền tích luỹ theo tuổi thế hệ
-- Problem: https://xomdata.com/practice/hard-ltv-002
-- Solved: 2026-10-05

WITH cte AS(
    SELECT MIN(order_date) OVER(PARTITION BY customer_id) AS min_month,
    order_date, amount 
    FROM orders
), ctd AS(
    SELECT strftime('%Y-%m',min_month) AS cohort_month,
    (strftime('%Y',order_date) - strftime('%Y',min_month)) * 12 + strftime('%m',order_date) - strftime('%m',min_month) AS month_age,
    amount
    FROM cte
), ctc AS(
    SELECT cohort_month, month_age,
    SUM(amount) AS revenue 
    FROM ctd
    GROUP BY cohort_month, month_age
)

SELECT ctc.*,
SUM(revenue) OVER (PARTITION BY cohort_month ORDER BY month_age) AS cumulative_revenue 
FROM ctc
