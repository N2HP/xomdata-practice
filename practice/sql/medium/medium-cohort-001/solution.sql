-- Xom Data · The customer's joining month on every order
-- Problem: https://xomdata.com/practice/medium-cohort-001
-- Solved: 2026-09-21

select customer_name, order_date, min(strftime('%Y-%m',order_date )) over(partition by customer_name)  as cohort_month  from orders  order by  customer_name, order_date
