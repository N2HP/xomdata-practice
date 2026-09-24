-- Xom Data · Delivery performance by size class
-- Problem: https://xomdata.com/practice/medium-case-160
-- Solved: 2026-09-24

WITH cte as(
    SELECT t.vehicle_type, t.capacity_tons, 
    COUNT(s.truck_id ) as shipment_count,
    CASE WHEN capacity_tons >= 10 THEN 'Large Truck'
    WHEN capacity_tons < 5 THEN 'Small Truck'
    ELSE 'Medium Truck' END AS size_class,
    SUM(CASE WHEN d.results = 'success' THEN 1 ELSE 0 END) AS delivered
    FROM shipments s 
    JOIN trucks t on s.truck_id = t.id
    JOIN deliveries d on d.shipment_id = s.id
    GROUP BY t.vehicle_type, t.capacity_tons
), ctee as(
    SELECT cte.*, 
    ROUND((delivered*100.0)/shipment_count,2) as delivery_rate
    FROM cte

)

SELECT ctee.*,
RANK() OVER(PARTITION BY size_class ORDER BY delivery_rate DESC) AS rank_in_size 
FROM ctee
ORDER BY size_class, rank_in_size, vehicle_type
