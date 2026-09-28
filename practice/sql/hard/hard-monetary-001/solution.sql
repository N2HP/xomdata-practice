-- Xom Data · Splitting customers into five spend tiers
-- Problem: https://xomdata.com/practice/hard-monetary-001
-- Solved: 2026-09-28

SELECT customer_id, SUM(amount) AS total_spent , NTILE(5) OVER(ORDER BY SUM(amount) DESC,customer_id) AS spend_rank FROM orders GROUP BY customer_id ORDER BY spend_rank, customer_id
