-- AI办公功能数据库增强脚本
-- 为企业员工信息管理系统添加AI办公相关表

USE staff_information_management3;

-- 1. AI对话历史表
CREATE TABLE IF NOT EXISTS ai_conversation_history (
    id VARCHAR(19) NOT NULL COMMENT 'ID',
    user_id VARCHAR(19) NOT NULL COMMENT '用户ID',
    session_id VARCHAR(50) NOT NULL COMMENT '会话ID',
    question TEXT NOT NULL COMMENT '用户问题',
    answer TEXT NOT NULL COMMENT 'AI回答',
    function_type VARCHAR(50) NOT NULL COMMENT '功能类型(document/analysis/qa/email/meeting/plan)',
    context_info TEXT COMMENT '上下文信息',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
    PRIMARY KEY (id),
    INDEX idx_user_id (user_id),
    INDEX idx_session_id (session_id),
    INDEX idx_function_type (function_type),
    INDEX idx_created_time (created_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI对话历史表';

-- 2. AI文档模板表
CREATE TABLE IF NOT EXISTS ai_document_template (
    id VARCHAR(19) NOT NULL COMMENT 'ID',
    template_name VARCHAR(100) NOT NULL COMMENT '模板名称',
    template_type VARCHAR(50) NOT NULL COMMENT '模板类型',
    template_content TEXT NOT NULL COMMENT '模板内容',
    department_id VARCHAR(19) COMMENT '适用部门ID',
    role_type VARCHAR(50) COMMENT '适用角色类型',
    is_system TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否系统模板 1是 0否',
    usage_count INT NOT NULL DEFAULT 0 COMMENT '使用次数',
    creator_id VARCHAR(19) COMMENT '创建者ID',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
    PRIMARY KEY (id),
    INDEX idx_template_type (template_type),
    INDEX idx_department_id (department_id),
    INDEX idx_role_type (role_type),
    INDEX idx_creator_id (creator_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI文档模板表';

-- 3. AI功能使用统计表
CREATE TABLE IF NOT EXISTS ai_function_usage_stats (
    id VARCHAR(19) NOT NULL COMMENT 'ID',
    user_id VARCHAR(19) NOT NULL COMMENT '用户ID',
    function_type VARCHAR(50) NOT NULL COMMENT '功能类型',
    usage_date DATE NOT NULL COMMENT '使用日期',
    usage_count INT NOT NULL DEFAULT 1 COMMENT '使用次数',
    total_tokens INT NOT NULL DEFAULT 0 COMMENT '总token消耗',
    success_count INT NOT NULL DEFAULT 0 COMMENT '成功次数',
    error_count INT NOT NULL DEFAULT 0 COMMENT '错误次数',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_function_date (user_id, function_type, usage_date),
    INDEX idx_usage_date (usage_date),
    INDEX idx_function_type (function_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI功能使用统计表';

-- 4. AI知识库表
CREATE TABLE IF NOT EXISTS ai_knowledge_base (
    id VARCHAR(19) NOT NULL COMMENT 'ID',
    title VARCHAR(200) NOT NULL COMMENT '知识标题',
    content TEXT NOT NULL COMMENT '知识内容',
    category VARCHAR(50) NOT NULL COMMENT '知识分类',
    tags VARCHAR(200) COMMENT '标签',
    department_id VARCHAR(19) COMMENT '关联部门ID',
    priority INT NOT NULL DEFAULT 0 COMMENT '优先级',
    view_count INT NOT NULL DEFAULT 0 COMMENT '查看次数',
    creator_id VARCHAR(19) NOT NULL COMMENT '创建者ID',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
    PRIMARY KEY (id),
    INDEX idx_category (category),
    INDEX idx_department_id (department_id),
    INDEX idx_creator_id (creator_id),
    FULLTEXT KEY ft_content (title, content)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI知识库表';

-- 5. AI配置表
CREATE TABLE IF NOT EXISTS ai_config (
    id VARCHAR(19) NOT NULL COMMENT 'ID',
    config_key VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value TEXT NOT NULL COMMENT '配置值',
    config_type VARCHAR(50) NOT NULL COMMENT '配置类型',
    description VARCHAR(500) COMMENT '配置描述',
    is_system TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否系统配置 1是 0否',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_config_key (config_key),
    INDEX idx_config_type (config_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI配置表';

-- 插入默认AI配置
INSERT INTO ai_config (id, config_key, config_value, config_type, description) VALUES
('ai_config_001', 'ai.office.enabled', 'true', 'system', 'AI办公功能总开关'),
('ai_config_002', 'ai.office.max_daily_usage', '100', 'limit', '每日最大使用次数'),
('ai_config_003', 'ai.office.max_tokens_per_request', '2000', 'limit', '单次请求最大token数'),
('ai_config_004', 'ai.office.default_temperature', '0.7', 'model', '默认温度参数'),
('ai_config_005', 'ai.office.timeout_seconds', '30', 'system', '请求超时时间(秒)');

-- 插入默认文档模板
INSERT INTO ai_document_template (id, template_name, template_type, template_content, is_system) VALUES
('template_001', '工作报告模板', '工作报告', 
'# {部门}工作报告\n\n## 报告期间\n{报告期间}\n\n## 工作概述\n{工作概述}\n\n## 主要成果\n{主要成果}\n\n## 存在问题\n{存在问题}\n\n## 下期计划\n{下期计划}\n\n报告人：{报告人}\n报告时间：{报告时间}', 1),

('template_002', '会议纪要模板', '会议纪要',
'# 会议纪要\n\n**会议主题：** {会议主题}\n**会议时间：** {会议时间}\n**会议地点：** {会议地点}\n**主持人：** {主持人}\n**参会人员：** {参会人员}\n**记录人：** {记录人}\n\n## 会议议程\n{会议议程}\n\n## 讨论内容\n{讨论内容}\n\n## 决议事项\n{决议事项}\n\n## 后续行动\n{后续行动}', 1),

('template_003', '通知公告模板', '通知公告',
'# {通知标题}\n\n各部门、各位同事：\n\n{通知内容}\n\n## 具体要求\n{具体要求}\n\n## 注意事项\n{注意事项}\n\n请各部门认真执行，如有疑问请及时联系。\n\n{发布部门}\n{发布时间}', 1);

-- 插入默认知识库内容
INSERT INTO ai_knowledge_base (id, title, content, category, tags, priority, creator_id) VALUES
('kb_001', '员工入职流程', 
'1. 人事部门接收入职通知\n2. 准备入职材料和工位\n3. 办理入职手续\n4. 系统账号开通\n5. 入职培训安排\n6. 部门对接和工作交接', 
'人事管理', '入职,流程,新员工', 10, 'system'),

('kb_002', '考勤管理规定',
'1. 标准工作时间：9:00-18:00\n2. 迟到早退处理规定\n3. 请假申请流程\n4. 加班申请和审批\n5. 考勤异常处理', 
'考勤管理', '考勤,规定,时间', 9, 'system'),

('kb_003', '薪资福利政策',
'1. 薪资结构说明\n2. 绩效考核标准\n3. 福利待遇清单\n4. 薪资调整机制\n5. 奖金发放规则', 
'薪资福利', '薪资,福利,绩效', 8, 'system');

-- 为现有用户表添加AI相关字段（如果需要）
-- ALTER TABLE user ADD COLUMN ai_usage_quota INT DEFAULT 100 COMMENT 'AI使用配额';
-- ALTER TABLE user ADD COLUMN ai_last_usage_date DATE COMMENT '最后使用AI日期';

COMMIT;

-- 创建视图：AI功能使用概览
CREATE OR REPLACE VIEW v_ai_usage_overview AS
SELECT 
    u.id as user_id,
    u.username,
    c.name as clerk_name,
    d.name as department_name,
    COUNT(h.id) as total_conversations,
    COUNT(DISTINCT h.session_id) as total_sessions,
    COUNT(DISTINCT h.function_type) as used_functions,
    MAX(h.created_time) as last_usage_time
FROM user u
LEFT JOIN clerk c ON u.id = c.user_id
LEFT JOIN department d ON c.department_id = d.id
LEFT JOIN ai_conversation_history h ON u.id = h.user_id AND h.is_deleted = 0
WHERE u.is_deleted = 0
GROUP BY u.id, u.username, c.name, d.name;

-- 创建存储过程：清理过期AI对话历史
DELIMITER //
CREATE PROCEDURE CleanExpiredAIHistory(IN days_to_keep INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE ai_conversation_history 
    SET is_deleted = 1 
    WHERE created_time < DATE_SUB(NOW(), INTERVAL days_to_keep DAY)
    AND is_deleted = 0;
    
    COMMIT;
END //
DELIMITER ;

-- 创建定时任务清理过期数据（保留90天）
-- 可以通过系统定时任务调用：CALL CleanExpiredAIHistory(90);

SELECT 'AI办公功能数据库增强完成！' as message;