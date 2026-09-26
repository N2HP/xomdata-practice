-- Xom Data · Top 10 most-engaged posts
-- Problem: https://xomdata.com/practice/medium-groupby-097
-- Solved: 2026-09-26

WITH cte AS (
    SELECT 
        u.id AS user_id, 
        u.full_name, 
        p.id AS post_id,
        p.post_type, 
        p.post_date, 
        (p.like_count + p.comment_count + p.share_count) AS total_interactions
    FROM posts p 
    JOIN users u ON p.user_id = u.id
)
SELECT 
    full_name, 
    post_type, 
    post_date, 
    total_interactions, 
    RANK() OVER (ORDER BY total_interactions DESC) AS overall_rank, 
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY total_interactions DESC, post_date ASC) AS rank_in_author,
    ROUND((total_interactions * 100.0) / (SELECT MAX(total_interactions) FROM cte), 2) AS pct_of_top  
FROM cte 
ORDER BY overall_rank ASC, full_name ASC, rank_in_author ASC 
LIMIT 10;
