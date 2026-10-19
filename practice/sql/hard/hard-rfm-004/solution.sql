-- Xom Data · A three-digit code says it all
-- Problem: https://xomdata.com/practice/hard-rfm-004
-- Solved: 2026-10-19

WITH cte AS (
    SELECT 
        customer_id, 
        '2024-06-30'::date - MAX(order_date::date) AS Recency,
        COUNT(order_id) AS Frequency,
        SUM(amount) AS Monetary 
    FROM orders
    WHERE order_date <= '2024-06-30'
    GROUP BY customer_id 
), ctd AS (
    SELECT 
        customer_id,
        -- R: Recency nhỏ hơn thì tốt hơn (ngày mua gần ngày 2024-06-30 nhất)
        -- Hai khách ngang nhau thì customer_id nhỏ hơn vào nhóm tốt hơn (ASC)
        6 - NTILE(5) OVER(ORDER BY Recency ASC, customer_id ASC) AS Recency_rank,
        
        -- F: Frequency lớn hơn thì tốt hơn
        -- Hai khách ngang nhau thì customer_id nhỏ hơn vào nhóm tốt hơn (ASC)
        6 - NTILE(5) OVER(ORDER BY Frequency DESC, customer_id ASC) AS Frequency_rank,
        
        -- M: Monetary lớn hơn thì tốt hơn
        -- Hai khách ngang nhau thì customer_id nhỏ hơn vào nhóm tốt hơn (ASC)
        6 - NTILE(5) OVER(ORDER BY Monetary DESC, customer_id ASC) AS Monetary_rank
    FROM cte
)
SELECT 
    customer_id, 
    CONCAT(Recency_rank, Frequency_rank, Monetary_rank) AS rfm_code 
FROM ctd
ORDER BY rfm_code DESC, customer_id ASC;
