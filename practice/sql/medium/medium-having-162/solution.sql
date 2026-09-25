-- Xom Data · Suppliers that deliver late frequently
-- Problem: https://xomdata.com/practice/medium-having-162
-- Solved: 2026-09-25

WITH cte AS(
    SELECT
    s.supplier_name,  s.material_type, COUNT(p.supplier_id) AS purchase_count , 
    SUM(total_value) AS total_purchase_value,
    ROUND(AVG(julianday(actual_receipt) - julianday(expected_receipt)),2)  AS avg_late_days,
    ROUND((SUM(CASE WHEN expected_receipt >= actual_receipt THEN 1 ELSE 0 END))*100.0/COUNT(p.supplier_id),2) AS on_time_rate 


    FROM suppliers s JOIN purchase_orders p on s.id = p.supplier_id      
    GROUP BY s.supplier_name,  s.material_type

)

SELECT cte.*,
RANK() OVER(ORDER BY avg_late_days DESC) AS late_rank,
NTILE(4) OVER(ORDER BY avg_late_days DESC) AS risk_tier 
FROM cte
WHERE total_purchase_value >= 3 AND  avg_late_days > 0
