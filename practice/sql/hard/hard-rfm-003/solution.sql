-- Xom Data · Freshness score plus diligence points
-- Problem: https://xomdata.com/practice/hard-rfm-003
-- Solved: 2026-10-22

WITH cte as (
    SELECT customer_id, '2024-06-30' - MAX(order_date::date) AS r, COUNT(order_id) AS f 
    FROM orders
    WHERE order_date::date <= '2024-06-30'
    GROUP BY customer_id
), ctd AS(
    SELECT customer_id,
    6 - NTILE(5) OVER(ORDER BY r, customer_id) AS r_score,
    CASE WHEN f < 4 THEN 1 ELSE 
        CASE WHEN f < 8 THEN 2 ELSE 3 END
    END AS f_score 
    FROM cte 
)

SELECT ctd.*,
f_score  + r_score AS total_score,
CASE WHEN f_score  + r_score < 5 THEN 'Bronze' ELSE
    CASE WHEN f_score  + r_score >= 7 THEN 'Gold' ELSE 'Silver' END
END AS label  
FROM ctd
