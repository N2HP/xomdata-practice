-- Xom Data · Bảng theo dõi khách quay lại theo thế hệ
-- Problem: https://xomdata.com/practice/hard-cohort-002
-- Solved: 2026-09-28

WITH cte AS(
    SELECT customer_id, MIN(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS min_month, order_date 

    FROM orders
), ctd AS(
    SELECT DISTINCT customer_id, min_month, 
    (strftime('%Y', order_date) - strftime('%Y', min_month)) * 12 + 
    (strftime('%m', order_date) - strftime('%m', min_month)) AS so_thang
    FROM cte
)

SELECT strftime('%Y-%m',min_month) AS cohort_month,
SUM(CASE WHEN so_thang = 0 THEN 1 ELSE 0 END) AS m0,
SUM(CASE WHEN so_thang = 1 THEN 1 ELSE 0 END) AS m1,
SUM(CASE WHEN so_thang = 2 THEN 1 ELSE 0 END) AS m2,
SUM(CASE WHEN so_thang = 3 THEN 1 ELSE 0 END) AS m3
FROM ctd
GROUP BY strftime('%Y-%m',min_month)
ORDER BY strftime('%Y-%m',min_month)
