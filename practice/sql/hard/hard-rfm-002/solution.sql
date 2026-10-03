-- Xom Data · Xếp khách vào nhóm chăm sóc phù hợp
-- Problem: https://xomdata.com/practice/hard-rfm-002
-- Solved: 2026-10-03

WITH cte as(
    SELECT customer_id, julianday('2024-06-30') - julianday(MAX(order_date)) AS days_since,
    COUNT(customer_id) AS order_count FROM orders GROUP BY customer_id

)

SELECT cte.*, 
CASE WHEN  days_since <= 60 THEN
    CASE WHEN order_count >= 3 THEN 'Champions'
    ELSE 'Promising' END
ELSE 
    CASE WHEN order_count >= 3 THEN 'At Risk'
    ELSE 'Hibernating' END
END AS segment     
FROM cte
