-- Xom Data · Scholarship-eligible students
-- Problem: https://xomdata.com/practice/easy-where-010
-- Solved: 2026-09-21

select full_name    , student_code , avg_score from students where avg_score >= 8 order by avg_score desc
