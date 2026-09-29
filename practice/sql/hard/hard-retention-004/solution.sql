-- Xom Data · Ma trận tỷ lệ quay lại ba tháng đầu
-- Problem: https://xomdata.com/practice/hard-retention-004
-- Solved: 2026-09-29

WITH cte AS(
    SELECT customer_id,MIN(order_date) OVER(PARTITION BY customer_id) AS cohort_month,order_date
    FROM orders
), ctd AS(
    SELECT DISTINCT customer_id, strftime('%Y-%m',cohort_month) AS cohort_month,
    (strftime('%Y',order_date) - strftime('%Y',cohort_month) )*12 + (strftime('%m',order_date) - strftime('%m',cohort_month) ) AS total_month
    FROM cte

)



SELECT 
cohort_month, COUNT(DISTINCT customer_id) AS cohort_size,100 AS m0_pct,
ROUND(SUM((CASE WHEN total_month = 1 THEN 1 ELSE 0 END))*100.0/ COUNT(DISTINCT customer_id),2) AS m1_pct,
ROUND(SUM((CASE WHEN total_month = 2 THEN 1 ELSE 0 END))*100.0/ COUNT(DISTINCT customer_id),2) AS m2_pct


FROM ctd
GROUP BY cohort_month
