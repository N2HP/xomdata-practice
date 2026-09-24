-- Xom Data · Showtime count and average ticket price per film
-- Problem: https://xomdata.com/practice/medium-join-076
-- Solved: 2026-09-24

WITH cte AS(
    SELECT
    m.movie_name, m.genres, COUNT(s.movie_id) AS showtime_count , 
    ROUND((AVG(ticket_price)),2) AS avg_ticket_price 


    FROM movies m JOIN showtimes s on m.id = s.movie_id     
    GROUP BY m.movie_name, m.genres


)

SELECT cte.*,
DENSE_RANK() OVER(PARTITION BY genres ORDER BY avg_ticket_price DESC) AS rank_in_genre,
FIRST_VALUE(movie_name) OVER(PARTITION BY genres ORDER BY avg_ticket_price DESC) AS top_movie_in_genre 

FROM cte
ORDER BY genres, rank_in_genre, movie_name
