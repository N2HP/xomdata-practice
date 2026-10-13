-- Xom Data · Total sales by org branch
-- Problem: https://xomdata.com/practice/hard-hierarchical-001
-- Solved: 2026-10-13

WITH RECURSIVE subordinate_tree AS (
    -- Bước khởi tạo (Anchor member): Mỗi nhân viên ban đầu liên kết với chính họ (để tính direct_sales của họ)
    SELECT id AS agent_id, id AS descendant_id, direct_sales
    FROM agents
    
    UNION ALL
    
    -- Bước đệ quy (Recursive member): Đi ngược lên tìm quản lý cấp trên
    SELECT a.manager_id AS agent_id, t.descendant_id, t.direct_sales
    FROM agents a
    JOIN subordinate_tree t ON a.id = t.agent_id
    WHERE a.manager_id IS NOT NULL
)
SELECT 
    ag.id AS agent_id,
    ag.name AS agent_name,
    ag.direct_sales,
    SUM(st.direct_sales) AS team_total
FROM agents ag
JOIN subordinate_tree st ON ag.id = st.agent_id
GROUP BY ag.id, ag.name, ag.direct_sales
ORDER BY team_total DESC, agent_id ASC;
