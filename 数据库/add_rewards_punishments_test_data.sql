-- 添加奖惩管理测试数据
-- 确保有足够的测试数据用于验证功能

USE staff_information_management;

-- 插入奖励记录
INSERT INTO rewards_punishments (id, time, amount, reason, type, note, clerk_id, department_id, is_deleted, gmt_create, gmt_modified) VALUES
('1001', '2025-01-01 10:00:00', 500.00, '优秀员工奖励', '0', '年度优秀员工', '1638782505286673', '1340584045776916482', 0, NOW(), NOW()),
('1002', '2025-01-02 14:30:00', 1000.00, '项目完成奖励', '0', '提前完成重要项目', '1638782650528673', '1340584045776916482', 0, NOW(), NOW()),
('1003', '2025-01-03 09:15:00', 300.00, '加班补贴', '0', '周末加班补贴', '1926271144646967297', '1340584045776916482', 0, NOW(), NOW());

-- 插入惩罚记录
INSERT INTO rewards_punishments (id, time, amount, reason, type, note, clerk_id, department_id, is_deleted, gmt_create, gmt_modified) VALUES
('2001', '2025-01-04 11:00:00', 200.00, '迟到扣款', '1', '连续三天迟到', '1933281189454520321', '1340584045776916482', 0, NOW(), NOW()),
('2002', '2025-01-05 16:20:00', 150.00, '违反规定', '1', '未按规定着装', '1934198637517459457', '1933400224908807682', 0, NOW(), NOW()),
('2003', '2025-01-06 13:45:00', 100.00, '工作失误', '1', '文件处理错误', '1934198637517459458', '1933400224908807682', 0, NOW(), NOW());

-- 验证插入的数据
SELECT 
    r.id,
    r.time,
    r.amount,
    r.reason,
    CASE r.type WHEN '0' THEN '奖励' WHEN '1' THEN '惩罚' END as type_name,
    r.note,
    c.name as clerk_name,
    d.name as department_name
FROM rewards_punishments r
JOIN clerk c ON r.clerk_id = c.id
JOIN department d ON r.department_id = d.id
WHERE r.is_deleted = 0
ORDER BY r.time DESC;