-- Xom Data · Rank hotels by room price within each destination
-- Problem: https://xomdata.com/practice/medium-join-155
-- Solved: 2026-09-26

WITH cte AS(
    SELECT h.id, h.star_class, h.hotel_name , d.destination_name, COUNT(hr.hotel_id) AS room_count,
    MIN(nightly_rate) AS min_price, MAX(nightly_rate) AS max_price,
    AVG(nightly_rate) AS avg_price,
    -MIN(nightly_rate) + MAX(nightly_rate) AS price_spread 
    FROM hotels h 
    JOIN destinations d ON d.id = h.destination_id
    JOIN hotel_rooms hr ON hr.hotel_id = h.id
    GROUP BY h.id, h.hotel_name , d.destination_name

)

SELECT hotel_name, star_class, destination_name, room_count, min_price, max_price, avg_price, price_spread,
RANK() OVER(PARTITION BY destination_name ORDER BY avg_price DESC) AS rank_in_destination 
FROM cte
WHERE room_count >= 2
ORDER BY destination_name, rank_in_destination, hotel_name
