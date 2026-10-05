-- Xom Data · Chấm điểm khách hàng trên ba thước đo
-- Problem: https://xomdata.com/practice/hard-rfm-001
-- Solved: 2026-10-05

WITH cte AS (
    SELECT customer_id, 
           julianday('2024-06-30') - julianday(MAX(order_date)) AS r,
           COUNT(order_id) AS f,
           SUM(amount) AS m
    FROM orders
    WHERE order_date < '2024-06-30'
    GROUP BY customer_id
), ctd AS (
    SELECT customer_id,
           -- R: r càng nhỏ càng tốt -> ASC, nếu r bằng nhau thì customer_id nhỏ hơn đứng trước -> ASC
           -- Dùng 6 - NTILE(5) để nhóm tốt nhất (nhóm 1 của NTILE) nhận 5 điểm, nhóm kém nhất nhận 1 điểm
           6 - NTILE(5) OVER (ORDER BY r ASC, customer_id ASC) AS r_score,
           
           -- F: f càng lớn càng tốt -> DESC, nếu bằng nhau thì customer_id nhỏ hơn đứng trước -> ASC
           6 - NTILE(5) OVER (ORDER BY f DESC, customer_id ASC) AS f_score,
           
           -- M: m càng lớn càng tốt -> DESC, nếu bằng nhau thì customer_id nhỏ hơn đứng trước -> ASC
           6 - NTILE(5) OVER (ORDER BY m DESC, customer_id ASC) AS m_score
    FROM cte
)
SELECT customer_id,
       r_score, 
       f_score, 
       m_score,
       r_score + f_score + m_score AS rfm_total 
FROM ctd
ORDER BY rfm_total DESC, customer_id ASC;
