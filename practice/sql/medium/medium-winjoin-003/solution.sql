-- Xom Data · Each aisle's best seller
-- Problem: https://xomdata.com/practice/medium-winjoin-003
-- Solved: 2026-09-26

WITH cte AS(
    SELECT c.category_name, p.product_name,p.units_sold ,ROW_NUMBER() OVER(PARTITION BY c.category_name ORDER BY units_sold DESC,p.product_name ) AS rank
FROM products p  JOIN categories c ON p.category_id = c.id

)

SELECT category_name, product_name, units_sold FROM cte WHERE rank = 1
