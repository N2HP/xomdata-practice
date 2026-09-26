-- Xom Data · Average score per subject
-- Problem: https://xomdata.com/practice/medium-groupby-027
-- Solved: 2026-09-26

WITH cte AS(
    SELECT s.id ,s.subject_name, s.credits, COUNT(g.subject_id) AS student_count, ROUND((AVG(final_score )),2) AS avg_score ,
    ROUND(SUM(CASE WHEN g.final_score >= 5 THEN 1 ELSE 0 END)*100.0 / COUNT(g.subject_id),2) AS  pass_rate 
    FROM grades g JOIN subjects s ON g.subject_id = s.id
    GROUP BY s.id, s.subject_name, s.credits


)

SELECT subject_name, credits, student_count, avg_score, pass_rate,
RANK() OVER(ORDER BY avg_score DESC) AS rank_by_avg,
NTILE(4) OVER(ORDER BY avg_score DESC, subject_name) AS difficulty_quartile 
FROM cte
ORDER BY rank_by_avg, subject_name
