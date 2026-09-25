-- Xom Data · Monthly income and expense report
-- Problem: https://xomdata.com/practice/medium-groupby-080
-- Solved: 2026-09-25

WITH cte AS(
    SELECT 
    strftime('%Y-%m',transaction_date ) AS month,
    SUM(CASE WHEN type = 'Income' THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN type = 'Expense' THEN amount ELSE 0 END) AS total_expense
    FROM transactions
    GROUP BY strftime('%Y-%m',transaction_date )


)

SELECT 
cte.*,
total_income - total_expense AS balance,
SUM(total_income - total_expense) OVER(ORDER BY month) AS cumulative_balance,
CASE WHEN total_income > total_expense THEN 'Surplus'
WHEN total_income = total_expense THEN 'Balanced'
ELSE 'Deficit' END AS status 
FROM cte
ORDER BY month
