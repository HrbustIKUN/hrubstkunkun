-- Profile功能增强SQL脚本
-- 为员工表添加技能字段和相关功能

USE staff_information_management2;

-- 1. 为clerk表添加技能字段
ALTER TABLE `clerk` ADD COLUMN `skills` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '专业技能，JSON格式存储' AFTER `address`;

-- 2. 添加技能字段的索引（可选，用于搜索）
ALTER TABLE `clerk` ADD INDEX `idx_clerk_skills`(`skills`(255));

-- 3. 创建用户技能更新的存储过程
DELIMITER //
CREATE PROCEDURE `sp_update_clerk_skills`(
    IN p_clerk_id CHAR(19),
    IN p_skills TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 更新员工技能
    UPDATE `clerk` 
    SET `skills` = p_skills,
        `gmt_modified` = NOW()
    WHERE `id` = p_clerk_id AND `is_deleted` = 0;
    
    -- 检查是否更新成功
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '员工不存在或已删除';
    END IF;
    
    COMMIT;
END //
DELIMITER ;

-- 4. 创建获取员工详细信息的存储过程（包含技能）
DELIMITER //
CREATE PROCEDURE `sp_get_clerk_profile`(
    IN p_clerk_id CHAR(19)
)
BEGIN
    SELECT 
        c.id,
        c.name,
        c.sex,
        c.phone_number,
        c.email,
        c.photo,
        c.id_card,
        c.address,
        c.position,
        c.skills,
        d.name as department_name,
        c.gmt_create,
        c.gmt_modified
    FROM `clerk` c
    LEFT JOIN `department` d ON c.department_id = d.id
    WHERE c.id = p_clerk_id AND c.is_deleted = 0;
END //
DELIMITER ;

-- 5. 创建根据用户ID获取员工信息的存储过程
DELIMITER //
CREATE PROCEDURE `sp_get_clerk_by_user_id`(
    IN p_user_id CHAR(19)
)
BEGIN
    SELECT 
        c.id,
        c.name,
        c.sex,
        c.phone_number,
        c.email,
        c.photo,
        c.id_card,
        c.address,
        c.position,
        c.skills,
        d.name as department_name,
        c.gmt_create,
        c.gmt_modified
    FROM `clerk` c
    LEFT JOIN `department` d ON c.department_id = d.id
    WHERE c.user_id = p_user_id AND c.is_deleted = 0;
END //
DELIMITER ;

-- 6. 创建技能搜索的存储过程
DELIMITER //
CREATE PROCEDURE `sp_search_clerks_by_skill`(
    IN p_skill_keyword VARCHAR(100),
    IN p_page_num INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    SET v_offset = (p_page_num - 1) * p_page_size;
    
    SELECT 
        c.id,
        c.name,
        c.position,
        c.skills,
        d.name as department_name
    FROM `clerk` c
    LEFT JOIN `department` d ON c.department_id = d.id
    WHERE c.is_deleted = 0 
    AND c.skills IS NOT NULL 
    AND c.skills LIKE CONCAT('%', p_skill_keyword, '%')
    ORDER BY c.gmt_modified DESC
    LIMIT v_offset, p_page_size;
    
    -- 返回总数
    SELECT COUNT(*) as total
    FROM `clerk` c
    WHERE c.is_deleted = 0 
    AND c.skills IS NOT NULL 
    AND c.skills LIKE CONCAT('%', p_skill_keyword, '%');
END //
DELIMITER ;

-- 7. 插入一些示例技能数据
UPDATE `clerk` SET `skills` = '["Java", "Spring Boot", "MySQL", "Vue.js"]' WHERE `id` = '1638778252236267521';
UPDATE `clerk` SET `skills` = '["Python", "Django", "PostgreSQL", "React"]' WHERE `id` = '1638779582375895042';
UPDATE `clerk` SET `skills` = '["项目管理", "团队协作", "战略规划"]' WHERE `id` = '1638779765465653250';
UPDATE `clerk` SET `skills` = '["JavaScript", "Node.js", "MongoDB"]' WHERE `id` = '1638780386969231362';
UPDATE `clerk` SET `skills` = '["UI设计", "Photoshop", "Figma"]' WHERE `id` = '1638781944314306561';

-- 8. 创建技能统计视图
CREATE OR REPLACE VIEW `v_skill_statistics` AS
SELECT 
    d.name as department_name,
    COUNT(c.id) as total_employees,
    COUNT(CASE WHEN c.skills IS NOT NULL AND c.skills != '[]' THEN 1 END) as employees_with_skills,
    ROUND(
        COUNT(CASE WHEN c.skills IS NOT NULL AND c.skills != '[]' THEN 1 END) * 100.0 / COUNT(c.id), 
        2
    ) as skill_coverage_rate
FROM `clerk` c
LEFT JOIN `department` d ON c.department_id = d.id
WHERE c.is_deleted = 0
GROUP BY d.id, d.name
ORDER BY skill_coverage_rate DESC;

-- 执行完成提示
SELECT 'Profile功能增强SQL脚本执行完成！' as message;
SELECT '已添加技能字段、存储过程和示例数据' as details;