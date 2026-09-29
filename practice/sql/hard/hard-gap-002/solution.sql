-- Xom Data · Quãng im lặng dài nhất của mỗi khách
-- Problem: https://xomdata.com/practice/hard-gap-002
-- Solved: 2026-09-29

WITH cte AS(
    SELECT customer_id, LAG(order_date,1) OVER(PARTITION BY customer_id ORDER BY order_date) AS gap_start, order_date AS gap_end
    FROM orders

), ctd AS(
    SELECT customer_id, gap_start, gap_end, julianday(gap_end) - julianday(gap_start) AS  gap_days, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY (julianday(gap_end) - julianday(gap_start)) DESC) AS rank
    FROM cte
)

SELECT customer_id, gap_start, gap_end, gap_days  FROM ctd WHERE rank = 1 AND gap_start IS NOT NULL ORDER BY gap_days DESC, customer_id
