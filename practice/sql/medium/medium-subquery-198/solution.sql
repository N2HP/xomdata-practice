-- Xom Data · Top 10 most-borrowed books
-- Problem: https://xomdata.com/practice/medium-subquery-198
-- Solved: 2026-09-25

WITH cte AS(
    SELECT
    b.id, b.title, a.full_name AS authors, p.publisher_name, g.genre_name, SUM(CASE WHEN r.status = 'ready_pickup' THEN 1 ELSE 0 END) AS pending_reservation  
    FROM books b
    JOIN authors a on b.author_id = a.id
    JOIN publishers p on b.publisher_id = p.id
    JOIN genres g on b.genre_id = g.id
    LEFT JOIN reservations r on b.id = r.book_id
    GROUP BY b.id, 
        b.title, 
        a.full_name, 
        p.publisher_name, 
        g.genre_name 



), loan AS(
    SELECT book_id, COUNT(book_id) AS borrow_count FROM book_loans GROUP BY book_id
)

SELECT c.title, c.authors, c.publisher_name, c.genre_name, l.borrow_count, c.pending_reservation, 
l.borrow_count + c.pending_reservation AS engagement,
DENSE_RANK() OVER(ORDER BY l.borrow_count + c.pending_reservation DESC) AS overall_rank,
RANK() OVER(PARTITION BY c.genre_name ORDER BY l.borrow_count + c.pending_reservation DESC ) AS rank_in_genre 
FROM cte c JOIN loan l ON l.book_id = c.id 
ORDER BY overall_rank, c.title
