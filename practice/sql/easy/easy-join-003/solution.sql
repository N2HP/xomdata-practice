-- Xom Data · Line totals from the price list
-- Problem: https://xomdata.com/practice/easy-join-003
-- Solved: 2026-10-24

-- Write your SQL here
SELECT 
p.product_name, si.quantity, si.quantity * p.price AS line_total 
FROM products p JOIN sale_items si on p.id = si.product_id
