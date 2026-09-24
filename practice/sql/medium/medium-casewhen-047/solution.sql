-- Xom Data · Portfolio profit/loss
-- Problem: https://xomdata.com/practice/medium-casewhen-047
-- Solved: 2026-09-24

WITH cte AS(
    SELECT
    s.stock_code, c.stock_quantity, c.avg_cost_price, s.current_price,
    ROUND((-c.avg_cost_price  + s.current_price)*c.stock_quantity,0) as profit_loss,
    ROUND(((-c.avg_cost_price  + s.current_price)*100.0/c.avg_cost_price),2) AS profit_pct
    FROM stocks s JOIN categories c ON c.stock_id = s.id
)

SELECT cte.*,
CASE WHEN profit_pct > 10 THEN 'Strong Gain'
WHEN profit_pct <= -10 THEN 'Strong Loss'
WHEN profit_pct = 0 THEN 'Break Even'
WHEN profit_pct > 0 AND profit_pct <= 10 THEN 'Mild Gain'
ELSE 'Mild Loss' END AS status,
RANK() OVER(ORDER BY profit_pct DESC) AS  rank_by_pct,
SUM(avg_cost_price * stock_quantity) OVER(ORDER BY profit_pct DESC,stock_code) AS cumulative_invested 
FROM cte
ORDER BY rank_by_pct
