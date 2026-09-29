-- Xom Data · Bản đồ tám nhóm khách hàng
-- Problem: https://xomdata.com/practice/hard-rfm-006
-- Solved: 2026-09-29

WITH cte AS(
    SELECT customer_id,julianday('2024-06-30') - julianday(MAX(order_date)) AS total_r,
    COUNT(customer_id) AS total_f
    FROM orders
    GROUP BY customer_id
), ctd AS(
    SELECT customer_id,
    CASE WHEN total_r <= 30 THEN 4
    WHEN total_r <= 60 THEN 3
    WHEN total_r <= 120 THEN 2
    ELSE 1 END AS r_score,
    CASE WHEN total_f >= 10 THEN 4
    WHEN total_f >= 5 THEN 3
    WHEN total_f >= 2 THEN 2
    ELSE 1 END AS f_score
    FROM cte
)

SELECT ctd.*,
CASE WHEN  r_score >= 3 THEN
    CASE WHEN f_score >=3 THEN 'Champions'  
    WHEN f_score = 2 THEN  'Potential Loyalist'
    ELSE 'New Customers' END
WHEN r_score = 2 THEN
    CASE WHEN f_score >=3 THEN 'At Risk'
    WHEN f_score <= 2 THEN 'About To Sleep'  END
ELSE 
    CASE WHEN f_score >=3 THEN 'Cannot Lose Them'
    WHEN f_score = 2 THEN 'Hibernating' 
    ELSE  'Lost'  END
END AS segment 

FROM ctd
