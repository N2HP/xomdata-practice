-- Xom Data · Scoring fairly when multiple customers are tied
-- Problem: https://xomdata.com/practice/hard-rfm-005
-- Solved: 2026-10-22

WITH cte AS(
    SELECT customer_id, SUM(amount) AS total_spent FROM orders GROUP BY customer_id

), ctd AS (
    SELECT cte.*,
    CASE WHEN COUNT(*) OVER() <= 1 THEN 0 ELSE
    (RANK() OVER(order by total_spent DESC) - 1.0)/ (COUNT(*) OVER() - 1.0) 
    END AS m
    FROM cte
)

SELECT customer_id, total_spent,
CASE WHEN m < 0.2 THEN 5 ELSE
    CASE WHEN m < 0.4 THEN 4 ELSE
        CASE WHEN m < 0.6 THEN 3 ELSE
            CASE WHEN m < 0.8 THEN 2 ELSE 1 END
        END
    END
END AS m_score 
FROM ctd
ORDER BY total_spent DESC
