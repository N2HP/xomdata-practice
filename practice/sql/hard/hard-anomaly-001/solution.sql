-- Xom Data · Detect anomalous days vs the average
-- Problem: https://xomdata.com/practice/hard-anomaly-001
-- Solved: 2026-11-03

WITH OverallStats AS (
    SELECT 
        AVG(value * 1.0) AS mean,
        -- Dùng hàm độ lệch chuẩn tổng thể (hoặc công thức sqrt(AVG(POWER(value - mean, 2))))
        SQRT(AVG(POWER(value - (SELECT AVG(value * 1.0) FROM daily_metrics), 2))) AS stddev
    FROM daily_metrics
)
SELECT 
d.date, d.value, 
ROUND(o.mean,2) AS mean, ROUND(o.stddev,2) AS stddev,

CASE WHEN stddev = 0 THEN 0 ELSE ROUND((( (value - mean)) / stddev),2) END AS z_score,
CASE WHEN stddev = 0 THEN 'normal' ELSE
CASE WHEN (( (value - mean)) / stddev) < -2 THEN 'low' ELSE
CASE WHEN (( (value - mean)) / stddev) > 2 THEN 'high' ELSE 'normal' END END END AS flag   
FROM daily_metrics d cross JOIN OverallStats o 
ORDER BY d.date
