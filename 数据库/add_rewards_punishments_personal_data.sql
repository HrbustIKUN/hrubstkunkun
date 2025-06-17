-- 为个人信息查看功能添加奖惩记录测试数据
USE staff_information_management;

-- 查看现有的员工数据
SELECT c.id as clerk_id, c.name as clerk_name, c.user_id, u.username 
FROM clerk c 
JOIN user u ON c.user_id = u.id 
WHERE c.is_deleted = 0 
LIMIT 5;

-- 为现有员工添加奖惩记录
-- 员工 1638782505286673 的奖惩记录
INSERT INTO rewards_punishments (id, type, reason, amount, clerk_id, is_deleted, gmt_create, gmt_modified) VALUES
('RP_PERSONAL_001', 0, '优秀员工奖励', 1000.00, '1638782505286673', 0, NOW(), NOW()),
('RP_PERSONAL_002', 1, '迟到扣款', 50.00, '1638782505286673', 0, NOW(), NOW()),
('RP_PERSONAL_003', 0, '项目完成奖金', 2000.00, '1638782505286673', 0, NOW(), NOW());

-- 员工 1638782650528673 的奖惩记录
INSERT INTO rewards_punishments (id, type, reason, amount, clerk_id, is_deleted, gmt_create, gmt_modified) VALUES
('RP_PERSONAL_004', 1, '违反公司规定', 200.00, '1638782650528673', 0, NOW(), NOW()),
('RP_PERSONAL_005', 0, '销售业绩奖励', 1500.00, '1638782650528673', 0, NOW(), NOW());

-- 员工 1926271144646967297 的奖惩记录
INSERT INTO rewards_punishments (id, type, reason, amount, clerk_id, is_deleted, gmt_create, gmt_modified) VALUES
('RP_PERSONAL_006', 0, '年终奖励', 3000.00, '1926271144646967297', 0, NOW(), NOW()),
('RP_PERSONAL_007', 1, '工作失误', 100.00, '1926271144646967297', 0, NOW(), NOW()),
('RP_PERSONAL_008', 0, '创新奖励', 800.00, '1926271144646967297', 0, NOW(), NOW());

-- 验证插入的奖惩数据
SELECT '=== 个人奖惩信息 ===' as info;
SELECT 
    rp.id,
    CASE rp.type 
        WHEN 0 THEN '奖励'
        WHEN 1 THEN '惩罚'
    END as type_name,
    rp.reason,
    rp.amount,
    c.name as clerk_name
FROM rewards_punishments rp
JOIN clerk c ON rp.clerk_id = c.id
WHERE rp.id LIKE 'RP_PERSONAL_%'
ORDER BY rp.gmt_create DESC;