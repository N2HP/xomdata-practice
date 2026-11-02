-- Xom Data · Longest run of consecutive active months
-- Problem: https://xomdata.com/practice/hard-streak-001
-- Solved: 2026-11-02

WITH cte AS(
    SELECT customer_id, order_date,
    - ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ) +
    EXTRACT(month FROM order_date::date) + 12 * EXTRACT(year FROM order_date::date) AS hi
    FROM orders

), ctd AS(
    SELECT DISTINCT customer_id, COUNT(*) AS longest_streak ,
    RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(*) DESC)
    FROM cte
    GROUP BY customer_id, hi
)


SELECT customer_id, longest_streak FROM ctd 
WHERE RANK = 1
ORDER BY longest_streak DESC, customer_id
