-- Xom Data · Players with 3 or more goals
-- Problem: https://xomdata.com/practice/medium-having-187
-- Solved: 2026-09-25

WITH cte AS(
    SELECT p.id , p.full_name , p.positions, t.team_name, COUNT(g.player_id) AS goal_count,
    COUNT(DISTINCT g.match_id ) AS scoring_matches,ROUND((COUNT(g.player_id)*1.0/COUNT( DISTINCT g.match_id )),2) AS goals_per_match
    FROM players p 
    JOIN teams t on p.team_id = t.id
    JOIN goals g on p.id = g.player_id
    GROUP BY p.id

), pen AS (
    SELECT player_id , COUNT(player_id) AS cards_received FROM penalties GROUP BY player_id
)

SELECT c.full_name , c.positions, c.team_name, c.goal_count, c.scoring_matches, COALESCE(p.cards_received,0) AS cards_received, c.goals_per_match,
DENSE_RANK() OVER(ORDER BY c.goals_per_match DESC) AS efficiency_rank,
RANK() OVER(ORDER BY c.goal_count DESC)  AS volume_rank 
FROM cte c LEFT JOIN pen p on  c.id = p.player_id
WHERE c.goal_count >= 3
ORDER BY goals_per_match , c.full_name
