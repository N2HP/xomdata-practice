-- Xom Data · Surviving from the second month onward
-- Problem: https://xomdata.com/practice/hard-retention-005
-- Solved: 2026-10-22

WITH cte AS(
    SELECT customer_id AS id, MIN(order_date) AS min_month FROM orders GROUP BY customer_id

), ctd AS(
    SELECT 
    o.customer_id
    FROM orders o JOIN cte c ON o.customer_id = c.id
    WHERE EXTRACT(month FROM order_date::date) - EXTRACT(month FROM min_month::date) + 12*(EXTRACT(year FROM order_date::date) - EXTRACT(year FROM min_month::date)) >= 2
)

SELECT TO_CHAR(min_month::date, 'YYYY-MM') AS cohort_month, COUNT(DISTINCT e.id) AS cohort_size, COUNT(DISTINCT d.customer_id) AS survivors, ROUND((COUNT(DISTINCT d.customer_id) * 100.0)/ COUNT(DISTINCT e.id),2) AS survival_pct  FROM cte e LEFT JOIN ctd d ON e.id = d.customer_id
GROUP BY TO_CHAR(min_month::date, 'YYYY-MM')
order by TO_CHAR(min_month::date, 'YYYY-MM')
