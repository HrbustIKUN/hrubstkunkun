-- 验证个人信息查看功能的数据完整性
USE staff_information_management;

-- 1. 检查用户和员工关联关系
SELECT '=== 用户和员工关联关系 ===' as info;
SELECT 
    u.id as user_id,
    u.username,
    u.role,
    c.id as clerk_id,
    c.name as clerk_name,
    c.is_deleted
FROM user u
LEFT JOIN clerk c ON u.id = c.user_id
WHERE u.role IN ('职员', '人事经理')
ORDER BY u.id;

-- 2. 检查每个员工的合同信息
SELECT '=== 员工合同信息 ===' as info;
SELECT 
    c.id as clerk_id,
    c.name as clerk_name,
    COUNT(co.id) as contract_count,
    GROUP_CONCAT(co.name SEPARATOR ', ') as contract_names
FROM clerk c
LEFT JOIN contract co ON c.id = co.clerk_id AND co.is_deleted = 0
WHERE c.is_deleted = 0
GROUP BY c.id, c.name
ORDER BY c.id;

-- 3. 检查每个员工的考勤记录
SELECT '=== 员工考勤记录 ===' as info;
SELECT 
    c.id as clerk_id,
    c.name as clerk_name,
    COUNT(a.id) as attendance_count,
    COUNT(CASE WHEN a.status = 0 THEN 1 END) as normal_count,
    COUNT(CASE WHEN a.status = 1 THEN 1 END) as leave_count,
    COUNT(CASE WHEN a.status = 2 THEN 1 END) as late_count
FROM clerk c
LEFT JOIN attendance a ON c.id = a.clerk_id AND a.is_deleted = 0
WHERE c.is_deleted = 0
GROUP BY c.id, c.name
ORDER BY c.id;

-- 4. 检查每个员工的奖惩记录
SELECT '=== 员工奖惩记录 ===' as info;
SELECT 
    c.id as clerk_id,
    c.name as clerk_name,
    COUNT(rp.id) as rewards_punishments_count,
    COUNT(CASE WHEN rp.type = 0 THEN 1 END) as reward_count,
    COUNT(CASE WHEN rp.type = 1 THEN 1 END) as punishment_count,
    SUM(CASE WHEN rp.type = 0 THEN rp.amount ELSE 0 END) as total_rewards,
    SUM(CASE WHEN rp.type = 1 THEN rp.amount ELSE 0 END) as total_punishments
FROM clerk c
LEFT JOIN rewards_punishments rp ON c.id = rp.clerk_id AND rp.is_deleted = 0
WHERE c.is_deleted = 0
GROUP BY c.id, c.name
ORDER BY c.id;

-- 5. 检查具体的测试数据
SELECT '=== 测试用户的详细信息 ===' as info;

-- 查找一个有完整数据的测试用户
SELECT 
    u.username,
    u.role,
    c.name as clerk_name,
    c.id as clerk_id,
    (SELECT COUNT(*) FROM contract WHERE clerk_id = c.id AND is_deleted = 0) as contract_count,
    (SELECT COUNT(*) FROM attendance WHERE clerk_id = c.id AND is_deleted = 0) as attendance_count,
    (SELECT COUNT(*) FROM rewards_punishments WHERE clerk_id = c.id AND is_deleted = 0) as rp_count
FROM user u
JOIN clerk c ON u.id = c.user_id
WHERE c.is_deleted = 0 AND u.role = '职员'
HAVING contract_count > 0 OR attendance_count > 0 OR rp_count > 0
LIMIT 3;