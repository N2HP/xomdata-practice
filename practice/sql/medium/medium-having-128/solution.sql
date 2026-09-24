-- Xom Data · Employees averaging over 5 overtime hours
-- Problem: https://xomdata.com/practice/medium-having-128
-- Solved: 2026-09-24

WITH cte AS(
    SELECT
    e.full_name, e.employee_code,
    FLOOR(AVG(a.work_days)) as avg_work_days, 
    ROUND(AVG(a.overtime_hours),2) as avg_overtime_hours, 
    ROUND(AVG(p.net_salary),2) AS avg_salary,
    ROUND((ROUND(AVG(a.overtime_hours),2)/FLOOR(AVG(a.work_days))),4) AS overtime_intensity
    FROM employees e 
    JOIN attendance a on e.id = a.employee_id
    JOIN payroll p on p.employee_id = e.id
    GROUP BY e.full_name, e.employee_code
)

SELECT cte.*,
RANK() OVER(ORDER BY overtime_intensity DESC) as intensity_rank ,
NTILE(4) OVER(ORDER BY overtime_intensity DESC) AS workload_quartile 
FROM cte
WHERE avg_overtime_hours > 5 AND avg_work_days >= 18
ORDER BY intensity_rank, employee_code
