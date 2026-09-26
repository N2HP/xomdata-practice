-- Xom Data · Consultation revenue by doctor
-- Problem: https://xomdata.com/practice/medium-join-141
-- Solved: 2026-09-26

WITH cte AS(
    SELECT f.faculty_name, d.full_name AS doctor_name, COUNT(m.doctor_id) AS visit_count, AVG(m.visit_fee) AS avg_exam_fee, SUM(m.visit_fee) AS total_exam_fee 
    FROM doctors d 
    JOIN faculties f ON f.id = d.faculty_id
    JOIN medical_visits m ON m.doctor_id = d.id
    GROUP BY d.id ,f.faculty_name, d.full_name

)

SELECT cte.*,
RANK() OVER(ORDER BY total_exam_fee DESC) AS overall_rank,
DENSE_RANK() OVER(PARTITION BY faculty_name ORDER BY total_exam_fee DESC) AS rank_in_faculty 
FROM cte
ORDER BY total_exam_fee DESC, doctor_name
