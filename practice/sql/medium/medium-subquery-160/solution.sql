-- Xom Data · Low-activity users
-- Problem: https://xomdata.com/practice/medium-subquery-160
-- Solved: 2026-09-24

WITH cte AS(
    SELECT u.user_name, 
    COUNT(o.id) AS order_count , 
    SUM(o.value) AS total_value ,
    AVG(o.value) AS avg_order_value
    FROM users u LEFT JOIN orders o on u.id = o.user_id
    GROUP BY u.user_name


)

SELECT cte.*,
CASE WHEN order_count == 0 THEN 'Inactive'
WHEN total_value < (SELECT AVG(total_value) FROM cte) THEN 'Low' 
ELSE 'Normal' END AS tier,
RANK() OVER(ORDER BY total_value) AS activity_rank,
ROUND(PERCENT_RANK() OVER (ORDER BY total_value ASC) * 100, 2) AS pct_above_peers
FROM cte
WHERE total_value < (SELECT AVG(total_value) FROM cte) OR order_count = 0
ORDER BY activity_rank, user_name
