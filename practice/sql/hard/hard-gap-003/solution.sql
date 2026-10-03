-- Xom Data · Dự đoán ngày khách ghé tiếp theo
-- Problem: https://xomdata.com/practice/hard-gap-003
-- Solved: 2026-10-03

WITH cte AS(

    SELECT customer_id,
     - julianday(order_date) + julianday(LEAD(order_date,1) OVER(PARTITION BY customer_id order by order_date)) AS hi
    FROM orders
), ctd AS(
    SELECT o.customer_id,
    MAX(o.order_date) AS last_order_date,
    cast(AVG(hi) AS interger) AS avg_gap_days
    FROM orders o JOIN cte c ON o.customer_id = c.customer_id

    GROUP BY o.customer_id
)

SELECT ctd.*, date(julianday(last_order_date) + avg_gap_days) AS predicted_next_date  FROM ctd
WHERE predicted_next_date IS NOT NULL
