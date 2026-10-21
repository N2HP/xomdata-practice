-- Xom Data · Monthly customer churn rate
-- Problem: https://xomdata.com/practice/hard-churn-003
-- Solved: 2026-10-21

WITH cte AS (
    SELECT DISTINCT 
        customer_id, 
        DATE_TRUNC('month', order_date::date)::date AS order_month
    FROM orders
),
filtered_cte AS (
    SELECT customer_id, order_month
    FROM cte
    -- Loại bỏ tháng lớn nhất toàn cục (dựa trên order_month)
    WHERE order_month != (SELECT MAX(order_month) FROM cte)
),
consecutive_months AS (
    SELECT 
        TO_CHAR(a.order_month, 'YYYY-MM') AS month,  
        COUNT(DISTINCT a.customer_id) AS active_customers, 
        COUNT(DISTINCT CASE WHEN b.order_month IS NULL THEN a.customer_id END) AS churned_customers 
    FROM filtered_cte a 
    LEFT JOIN cte b 
      ON a.customer_id = b.customer_id 
     AND a.order_month + INTERVAL '1 month' = b.order_month
    GROUP BY a.order_month
)
SELECT 
    month,
    active_customers,
    churned_customers,
    ROUND((100.0 * churned_customers) / NULLIF(active_customers, 0), 2) AS churn_rate_pct 
FROM consecutive_months 
ORDER BY month;
