-- AI办公功能数据库表（修复版本）
-- 适配MyBatis Plus 3.5.3.1和Spring Boot 3.2.5

USE staff_information_management3;

-- 删除现有AI相关表（如果存在）
DROP TABLE IF EXISTS ai_function_usage_stats;
DROP TABLE IF EXISTS ai_conversation_history;
DROP TABLE IF EXISTS ai_document_template;
DROP TABLE IF EXISTS ai_knowledge_base;
DROP TABLE IF EXISTS ai_config;
DROP VIEW IF EXISTS v_ai_usage_overview;
DROP PROCEDURE IF EXISTS CleanExpiredAIHistory;

-- 1. AI对话历史表
CREATE TABLE ai_conversation_history (
    id VARCHAR(20) NOT NULL COMMENT 'ID - 使用雪花算法生成',
    user_id VARCHAR(20) NOT NULL COMMENT '用户ID',
    session_id VARCHAR(64) NOT NULL COMMENT '会话ID',
    question TEXT NOT NULL COMMENT '用户问题',
    answer TEXT NOT NULL COMMENT 'AI回答',
    function_type VARCHAR(50) NOT NULL COMMENT '功能类型(document/analysis/qa/email/meeting/plan)',
    context_info TEXT COMMENT '上下文信息',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
    PRIMARY KEY (id),
    INDEX idx_user_id (user_id),
    INDEX idx_session_id (session_id),
    INDEX idx_function_type (function_type),
    INDEX idx_created_time (created_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI对话历史表';

-- 2. AI文档模板表
CREATE TABLE ai_document_template (
    id VARCHAR(20) NOT NULL COMMENT 'ID - 使用雪花算法生成',
    template_name VARCHAR(100) NOT NULL COMMENT '模板名称',
    template_type VARCHAR(50) NOT NULL COMMENT '模板类型',
    template_content TEXT NOT NULL COMMENT '模板内容',
    department_id VARCHAR(20) COMMENT '适用部门ID',
    role_type VARCHAR(50) COMMENT '适用角色类型',
    is_system TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否系统模板 1是 0否',
    usage_count INT NOT NULL DEFAULT 0 COMMENT '使用次数',
    creator_id VARCHAR(20) COMMENT '创建者ID',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
    PRIMARY KEY (id),
    INDEX idx_template_type (template_type),
    INDEX idx_department_id (department_id),
    INDEX idx_role_type (role_type),
    INDEX idx_creator_id (creator_id),
    INDEX idx_template_name (template_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI文档模板表';

-- 3. AI功能使用统计表
CREATE TABLE ai_function_usage_stats (
    id VARCHAR(20) NOT NULL COMMENT 'ID - 使用雪花算法生成',
    user_id VARCHAR(20) NOT NULL COMMENT '用户ID',
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
    INDEX idx_function_type (function_type),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI功能使用统计表';

-- 4. AI知识库表
CREATE TABLE ai_knowledge_base (
    id VARCHAR(20) NOT NULL COMMENT 'ID - 使用雪花算法生成',
    title VARCHAR(200) NOT NULL COMMENT '知识标题',
    content TEXT NOT NULL COMMENT '知识内容',
    category VARCHAR(50) NOT NULL COMMENT '知识分类',
    tags VARCHAR(200) COMMENT '标签',
    department_id VARCHAR(20) COMMENT '关联部门ID',
    priority INT NOT NULL DEFAULT 0 COMMENT '优先级',
    view_count INT NOT NULL DEFAULT 0 COMMENT '查看次数',
    creator_id VARCHAR(20) NOT NULL COMMENT '创建者ID',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
    PRIMARY KEY (id),
    INDEX idx_category (category),
    INDEX idx_department_id (department_id),
    INDEX idx_creator_id (creator_id),
    INDEX idx_title (title),
    FULLTEXT KEY ft_content (title, content)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI知识库表';

-- 5. AI配置表
CREATE TABLE ai_config (
    id VARCHAR(20) NOT NULL COMMENT 'ID - 使用雪花算法生成',
    config_key VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value TEXT NOT NULL COMMENT '配置值',
    config_type VARCHAR(50) NOT NULL COMMENT '配置类型',
    description VARCHAR(500) COMMENT '配置描述',
    is_system TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否系统配置 1是 0否',
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_config_key (config_key),
    INDEX idx_config_type (config_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI配置表';

-- 插入默认AI配置数据
INSERT INTO ai_config (id, config_key, config_value, config_type, description, is_system) VALUES
('1001', 'ai.office.enabled', 'true', 'system', 'AI办公功能总开关', 1),
('1002', 'ai.office.max_daily_usage', '100', 'limit', '每日最大使用次数', 1),
('1003', 'ai.office.max_tokens_per_request', '2000', 'limit', '单次请求最大token数', 1),
('1004', 'ai.office.default_temperature', '0.7', 'model', '默认温度参数', 1),
('1005', 'ai.office.timeout_seconds', '30', 'system', '请求超时时间(秒)', 1),
('1006', 'ai.office.default_model', 'gpt-3.5-turbo', 'model', '默认AI模型', 1),
('1007', 'ai.office.max_history_days', '90', 'system', '对话历史保留天数', 1);

-- 插入默认文档模板数据
INSERT INTO ai_document_template (id, template_name, template_type, template_content, is_system, creator_id) VALUES
('2001', '工作报告模板', '工作报告', 
'# {部门}工作报告\n\n## 报告期间\n{报告期间}\n\n## 工作概述\n{工作概述}\n\n## 主要成果\n{主要成果}\n\n## 存在问题\n{存在问题}\n\n## 下期计划\n{下期计划}\n\n报告人：{报告人}\n报告时间：{报告时间}', 1, 'system'),

('2002', '会议纪要模板', '会议纪要',
'# 会议纪要\n\n**会议主题：** {会议主题}\n**会议时间：** {会议时间}\n**会议地点：** {会议地点}\n**主持人：** {主持人}\n**参会人员：** {参会人员}\n**记录人：** {记录人}\n\n## 会议议程\n{会议议程}\n\n## 讨论内容\n{讨论内容}\n\n## 决议事项\n{决议事项}\n\n## 后续行动\n{后续行动}', 1, 'system'),

('2003', '通知公告模板', '通知公告',
'# {通知标题}\n\n各部门、各位同事：\n\n{通知内容}\n\n## 具体要求\n{具体要求}\n\n## 注意事项\n{注意事项}\n\n请各部门认真执行，如有疑问请及时联系。\n\n{发布部门}\n{发布时间}', 1, 'system'),

('2004', '请假申请模板', '请假申请',
'# 请假申请\n\n**申请人：** {申请人}\n**部门：** {部门}\n**职位：** {职位}\n**请假类型：** {请假类型}\n**请假时间：** {开始时间} 至 {结束时间}\n**请假天数：** {请假天数}\n**请假原因：** {请假原因}\n\n**工作安排：** {工作安排}\n\n申请日期：{申请日期}\n申请人签名：{申请人}', 1, 'system');

-- 插入默认知识库内容
INSERT INTO ai_knowledge_base (id, title, content, category, tags, priority, creator_id) VALUES
('3001', '员工入职流程指南', 
'## 员工入职完整流程\n\n### 1. 入职前准备\n- 人事部门接收入职通知\n- 准备入职材料和工位\n- 准备员工手册和相关资料\n\n### 2. 入职当天\n- 办理入职手续\n- 签署劳动合同\n- 填写员工信息表\n- 拍摄员工照片\n\n### 3. 系统配置\n- 开通系统账号\n- 分配邮箱账号\n- 配置办公设备\n\n### 4. 培训安排\n- 公司文化培训\n- 岗位技能培训\n- 安全培训\n\n### 5. 部门对接\n- 介绍团队成员\n- 工作交接\n- 制定试用期目标', 
'人事管理', '入职,流程,新员工,培训', 10, 'system'),

('3002', '考勤管理制度详解',
'## 考勤管理规定\n\n### 工作时间\n- 标准工作时间：9:00-18:00\n- 午休时间：12:00-13:00\n- 周工作时间：40小时\n\n### 考勤规则\n- 迟到早退处理规定\n- 请假申请流程\n- 加班申请和审批\n- 考勤异常处理\n\n### 请假类型\n- 年假、病假、事假\n- 婚假、产假、陪产假\n- 丧假、工伤假\n\n### 考勤统计\n- 月度考勤汇总\n- 异常考勤处理\n- 考勤与薪资关联', 
'考勤管理', '考勤,规定,时间,请假', 9, 'system'),

('3003', '薪资福利体系说明',
'## 薪资福利政策\n\n### 薪资结构\n- 基本工资\n- 岗位津贴\n- 绩效奖金\n- 年终奖\n\n### 绩效考核\n- 考核周期和标准\n- 考核流程\n- 结果应用\n\n### 福利待遇\n- 社会保险\n- 住房公积金\n- 商业保险\n- 节日福利\n- 培训机会\n\n### 薪资调整\n- 调薪机制\n- 晋升加薪\n- 市场调研', 
'薪资福利', '薪资,福利,绩效,保险', 8, 'system'),

('3004', 'AI办公功能使用指南',
'## AI办公助手使用说明\n\n### 主要功能\n- 智能文档生成\n- 数据分析报告\n- 会议纪要整理\n- 邮件草拟\n- 工作计划制定\n\n### 使用技巧\n- 清晰描述需求\n- 提供充分上下文\n- 合理使用模板\n- 及时反馈优化\n\n### 注意事项\n- 保护敏感信息\n- 核实生成内容\n- 遵守使用规范\n- 合理控制使用频率', 
'AI办公', 'AI,办公,助手,使用指南', 7, 'system');

-- 创建AI使用概览视图
CREATE VIEW v_ai_usage_overview AS
SELECT 
    u.id as user_id,
    u.username,
    COALESCE(c.name, '未分配') as clerk_name,
    COALESCE(d.name, '未分配') as department_name,
    COUNT(h.id) as total_conversations,
    COUNT(DISTINCT h.session_id) as total_sessions,
    COUNT(DISTINCT h.function_type) as used_functions,
    MAX(h.created_time) as last_usage_time,
    DATE(MAX(h.created_time)) as last_usage_date
FROM user u
LEFT JOIN clerk c ON u.id = c.user_id AND c.is_deleted = 0
LEFT JOIN department d ON c.department_id = d.id AND d.is_deleted = 0
LEFT JOIN ai_conversation_history h ON u.id = h.user_id AND h.is_deleted = 0
WHERE u.is_deleted = 0
GROUP BY u.id, u.username, c.name, d.name;

-- 创建清理过期AI对话历史的存储过程
DELIMITER //
CREATE PROCEDURE CleanExpiredAIHistory(IN days_to_keep INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 软删除过期的对话历史
    UPDATE ai_conversation_history 
    SET is_deleted = 1, updated_time = NOW()
    WHERE created_time < DATE_SUB(NOW(), INTERVAL days_to_keep DAY)
    AND is_deleted = 0;
    
    -- 记录清理日志
    SELECT ROW_COUNT() as cleaned_records, NOW() as cleanup_time;
    
    COMMIT;
END //
DELIMITER ;

-- 创建AI使用统计存储过程
DELIMITER //
CREATE PROCEDURE GetAIUsageStats(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT 
        function_type,
        COUNT(*) as usage_count,
        COUNT(DISTINCT user_id) as unique_users,
        AVG(total_tokens) as avg_tokens,
        SUM(success_count) as total_success,
        SUM(error_count) as total_errors
    FROM ai_function_usage_stats
    WHERE usage_date BETWEEN start_date AND end_date
    GROUP BY function_type
    ORDER BY usage_count DESC;
END //
DELIMITER ;

COMMIT;

SELECT 'AI办公功能数据库表创建完成！' as message;
SELECT 'MyBatis Plus 3.5.3.1 兼容版本' as version_info;
SELECT '请使用 IdType.ASSIGN_ID 作为主键策略' as id_strategy;