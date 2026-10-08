-- Xom Data · Running inventory balance over time
-- Problem: https://xomdata.com/practice/hard-fifo-001
-- Solved: 2026-10-08

SELECT sku, occurred_at, type, quantity,
SUM(
    CASE WHEN type = 'IN' THEN quantity 
    ELSE -quantity END
)
OVER(PARTITION BY sku ORDER BY occurred_at,id) AS running_balance
FROM inventory_movements
