-- Xom Data · How many of last month's customers are lost this month
-- Problem: https://xomdata.com/practice/hard-churn-002
-- Solved: 2026-10-23

WITH cte AS (
    -- Lấy danh sách các tháng mà mỗi khách hàng có phát sinh đơn
    SELECT DISTINCT 
        customer_id AS id, 
        DATE_TRUNC('month', order_date::date)::date AS format_date
    FROM orders
), 
ctd AS (
    SELECT 
        id, 
        format_date,
        -- Lấy tháng có đơn hàng tiếp theo của khách hàng đó
        LEAD(format_date, 1) OVER (PARTITION BY id ORDER BY format_date) AS next_date
    FROM cte
)
SELECT 
    TO_CHAR(format_date, 'YYYY-MM') AS month,
    -- Đếm những khách mà 'next_date' khác với tháng kế tiếp theo lịch (format_date + 1 tháng) HOẶC next_date bị NULL
    COUNT(CASE 
        WHEN next_date IS NULL OR next_date != format_date + INTERVAL '1 month' THEN 1 
    END) AS churned_customers 
FROM ctd
WHERE format_date != (SELECT MAX(format_date) FROM cte)
GROUP BY TO_CHAR(format_date, 'YYYY-MM')
ORDER BY month;
