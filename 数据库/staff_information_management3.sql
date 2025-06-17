/*
 Navicat Premium Dump SQL

 Source Server         : sd
 Source Server Type    : MySQL
 Source Server Version : 80036 (8.0.36)
 Source Host           : localhost:3306
 Source Schema         : staff_information_management3

 Target Server Type    : MySQL
 Target Server Version : 80036 (8.0.36)
 File Encoding         : 65001

 Date: 17/06/2025 10:59:05
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_config
-- ----------------------------
DROP TABLE IF EXISTS `ai_config`;
CREATE TABLE `ai_config`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ID - 使用雪花算法生成',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置值',
  `config_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置类型',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置描述',
  `is_system` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否系统配置 1是 0否',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key` ASC) USING BTREE,
  INDEX `idx_config_type`(`config_type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_config
-- ----------------------------
INSERT INTO `ai_config` VALUES ('1001', 'ai.office.enabled', 'true', 'system', 'AI办公功能总开关', 1, '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_config` VALUES ('1002', 'ai.office.max_daily_usage', '100', 'limit', '每日最大使用次数', 1, '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_config` VALUES ('1003', 'ai.office.max_tokens_per_request', '2000', 'limit', '单次请求最大token数', 1, '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_config` VALUES ('1004', 'ai.office.default_temperature', '0.7', 'model', '默认温度参数', 1, '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_config` VALUES ('1005', 'ai.office.timeout_seconds', '30', 'system', '请求超时时间(秒)', 1, '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_config` VALUES ('1006', 'ai.office.default_model', 'gpt-3.5-turbo', 'model', '默认AI模型', 1, '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_config` VALUES ('1007', 'ai.office.max_history_days', '90', 'system', '对话历史保留天数', 1, '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);

-- ----------------------------
-- Table structure for ai_conversation_history
-- ----------------------------
DROP TABLE IF EXISTS `ai_conversation_history`;
CREATE TABLE `ai_conversation_history`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ID - 使用雪花算法生成',
  `user_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户ID',
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '会话ID',
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户问题',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'AI回答',
  `function_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '功能类型(document/analysis/qa/email/meeting/plan)',
  `context_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '上下文信息',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_session_id`(`session_id` ASC) USING BTREE,
  INDEX `idx_function_type`(`function_type` ASC) USING BTREE,
  INDEX `idx_created_time`(`created_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI对话历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_conversation_history
-- ----------------------------

-- ----------------------------
-- Table structure for ai_document_template
-- ----------------------------
DROP TABLE IF EXISTS `ai_document_template`;
CREATE TABLE `ai_document_template`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ID - 使用雪花算法生成',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板名称',
  `template_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板类型',
  `template_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板内容',
  `department_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '适用部门ID',
  `role_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '适用角色类型',
  `is_system` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否系统模板 1是 0否',
  `usage_count` int NOT NULL DEFAULT 0 COMMENT '使用次数',
  `creator_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_template_type`(`template_type` ASC) USING BTREE,
  INDEX `idx_department_id`(`department_id` ASC) USING BTREE,
  INDEX `idx_role_type`(`role_type` ASC) USING BTREE,
  INDEX `idx_creator_id`(`creator_id` ASC) USING BTREE,
  INDEX `idx_template_name`(`template_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI文档模板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_document_template
-- ----------------------------
INSERT INTO `ai_document_template` VALUES ('2001', '工作报告模板', '工作报告', '# {部门}工作报告\n\n## 报告期间\n{报告期间}\n\n## 工作概述\n{工作概述}\n\n## 主要成果\n{主要成果}\n\n## 存在问题\n{存在问题}\n\n## 下期计划\n{下期计划}\n\n报告人：{报告人}\n报告时间：{报告时间}', NULL, NULL, 1, 0, 'system', '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_document_template` VALUES ('2002', '会议纪要模板', '会议纪要', '# 会议纪要\n\n**会议主题：** {会议主题}\n**会议时间：** {会议时间}\n**会议地点：** {会议地点}\n**主持人：** {主持人}\n**参会人员：** {参会人员}\n**记录人：** {记录人}\n\n## 会议议程\n{会议议程}\n\n## 讨论内容\n{讨论内容}\n\n## 决议事项\n{决议事项}\n\n## 后续行动\n{后续行动}', NULL, NULL, 1, 0, 'system', '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_document_template` VALUES ('2003', '通知公告模板', '通知公告', '# {通知标题}\n\n各部门、各位同事：\n\n{通知内容}\n\n## 具体要求\n{具体要求}\n\n## 注意事项\n{注意事项}\n\n请各部门认真执行，如有疑问请及时联系。\n\n{发布部门}\n{发布时间}', NULL, NULL, 1, 0, 'system', '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_document_template` VALUES ('2004', '请假申请模板', '请假申请', '# 请假申请\n\n**申请人：** {申请人}\n**部门：** {部门}\n**职位：** {职位}\n**请假类型：** {请假类型}\n**请假时间：** {开始时间} 至 {结束时间}\n**请假天数：** {请假天数}\n**请假原因：** {请假原因}\n\n**工作安排：** {工作安排}\n\n申请日期：{申请日期}\n申请人签名：{申请人}', NULL, NULL, 1, 0, 'system', '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);

-- ----------------------------
-- Table structure for ai_function_usage_stats
-- ----------------------------
DROP TABLE IF EXISTS `ai_function_usage_stats`;
CREATE TABLE `ai_function_usage_stats`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ID - 使用雪花算法生成',
  `user_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户ID',
  `function_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '功能类型',
  `usage_date` date NOT NULL COMMENT '使用日期',
  `usage_count` int NOT NULL DEFAULT 1 COMMENT '使用次数',
  `total_tokens` int NOT NULL DEFAULT 0 COMMENT '总token消耗',
  `success_count` int NOT NULL DEFAULT 0 COMMENT '成功次数',
  `error_count` int NOT NULL DEFAULT 0 COMMENT '错误次数',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_function_date`(`user_id` ASC, `function_type` ASC, `usage_date` ASC) USING BTREE,
  INDEX `idx_usage_date`(`usage_date` ASC) USING BTREE,
  INDEX `idx_function_type`(`function_type` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI功能使用统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_function_usage_stats
-- ----------------------------

-- ----------------------------
-- Table structure for ai_knowledge_base
-- ----------------------------
DROP TABLE IF EXISTS `ai_knowledge_base`;
CREATE TABLE `ai_knowledge_base`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ID - 使用雪花算法生成',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '知识标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '知识内容',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '知识分类',
  `tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  `department_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联部门ID',
  `priority` int NOT NULL DEFAULT 0 COMMENT '优先级',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '查看次数',
  `creator_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1已删除 0未删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE,
  INDEX `idx_department_id`(`department_id` ASC) USING BTREE,
  INDEX `idx_creator_id`(`creator_id` ASC) USING BTREE,
  INDEX `idx_title`(`title` ASC) USING BTREE,
  FULLTEXT INDEX `ft_content`(`title`, `content`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI知识库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_knowledge_base
-- ----------------------------
INSERT INTO `ai_knowledge_base` VALUES ('3001', '员工入职流程指南', '## 员工入职完整流程\n\n### 1. 入职前准备\n- 人事部门接收入职通知\n- 准备入职材料和工位\n- 准备员工手册和相关资料\n\n### 2. 入职当天\n- 办理入职手续\n- 签署劳动合同\n- 填写员工信息表\n- 拍摄员工照片\n\n### 3. 系统配置\n- 开通系统账号\n- 分配邮箱账号\n- 配置办公设备\n\n### 4. 培训安排\n- 公司文化培训\n- 岗位技能培训\n- 安全培训\n\n### 5. 部门对接\n- 介绍团队成员\n- 工作交接\n- 制定试用期目标', '人事管理', '入职,流程,新员工,培训', NULL, 10, 0, 'system', '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_knowledge_base` VALUES ('3002', '考勤管理制度详解', '## 考勤管理规定\n\n### 工作时间\n- 标准工作时间：9:00-18:00\n- 午休时间：12:00-13:00\n- 周工作时间：40小时\n\n### 考勤规则\n- 迟到早退处理规定\n- 请假申请流程\n- 加班申请和审批\n- 考勤异常处理\n\n### 请假类型\n- 年假、病假、事假\n- 婚假、产假、陪产假\n- 丧假、工伤假\n\n### 考勤统计\n- 月度考勤汇总\n- 异常考勤处理\n- 考勤与薪资关联', '考勤管理', '考勤,规定,时间,请假', NULL, 9, 0, 'system', '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_knowledge_base` VALUES ('3003', '薪资福利体系说明', '## 薪资福利政策\n\n### 薪资结构\n- 基本工资\n- 岗位津贴\n- 绩效奖金\n- 年终奖\n\n### 绩效考核\n- 考核周期和标准\n- 考核流程\n- 结果应用\n\n### 福利待遇\n- 社会保险\n- 住房公积金\n- 商业保险\n- 节日福利\n- 培训机会\n\n### 薪资调整\n- 调薪机制\n- 晋升加薪\n- 市场调研', '薪资福利', '薪资,福利,绩效,保险', NULL, 8, 0, 'system', '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);
INSERT INTO `ai_knowledge_base` VALUES ('3004', 'AI办公功能使用指南', '## AI办公助手使用说明\n\n### 主要功能\n- 智能文档生成\n- 数据分析报告\n- 会议纪要整理\n- 邮件草拟\n- 工作计划制定\n\n### 使用技巧\n- 清晰描述需求\n- 提供充分上下文\n- 合理使用模板\n- 及时反馈优化\n\n### 注意事项\n- 保护敏感信息\n- 核实生成内容\n- 遵守使用规范\n- 合理控制使用频率', 'AI办公', 'AI,办公,助手,使用指南', NULL, 7, 0, 'system', '2025-06-17 09:28:05', '2025-06-17 09:28:05', 0);

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `title` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公告标题',
  `content` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES ('1926236711831240706', '学java上哈理工', NULL, '2025-05-08 08:00:00', 0, '2025-05-24 19:19:55', '2025-05-24 19:19:55');
INSERT INTO `announcement` VALUES ('1933329351185829889', '今天答辩', '<p>今天答辩</p>', '2025-06-06 08:00:00', 0, '2025-06-13 09:03:32', '2025-06-13 09:03:32');

-- ----------------------------
-- Table structure for attendance
-- ----------------------------
DROP TABLE IF EXISTS `attendance`;
CREATE TABLE `attendance`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '考勤名称',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '正常0,事假1,迟到2,早退3,病假4,旷工5,休补6',
  `time` datetime NULL DEFAULT NULL COMMENT '考勤日期',
  `audit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '审核状态:0正在审核，1审核通过，2审核不通过',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请假原因',
  `department_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '部门id',
  `clerk_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '员工id',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考勤表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of attendance
-- ----------------------------
INSERT INTO `attendance` VALUES ('1638782305318051842', NULL, '1', '2025-03-01 00:00:00', '1', NULL, '1340584045776916482', '1638778252236267521', 0, '2025-05-23 13:58:43', '2025-05-23 14:00:14');
INSERT INTO `attendance` VALUES ('1638782560528867330', NULL, '4', '2025-03-01 00:00:00', '1', NULL, '1340584967022235649', '1638779582375895042', 0, '2025-05-23 13:59:44', '2025-05-14 17:28:30');
INSERT INTO `attendance` VALUES ('1926233716179632129', NULL, '2', '2025-05-01 08:00:00', '1', NULL, '1340603278481043457', '1926178966268575747', 0, '2025-05-24 19:08:00', '2025-06-13 08:33:56');
INSERT INTO `attendance` VALUES ('1926271144646967297', NULL, '1', '2025-05-01 08:00:00', '1', NULL, '1340584045776916482', '1922584583866699778', 0, '2025-05-24 21:36:44', '2025-06-13 08:33:57');
INSERT INTO `attendance` VALUES ('1933328118945452033', NULL, '3', '2025-06-05 08:00:00', '1', NULL, '1340584045776916482', '1922584583866699778', 0, '2025-06-13 08:58:38', '2025-06-13 08:58:52');
INSERT INTO `attendance` VALUES ('1934198569401962497', NULL, '1', '2025-06-01 08:00:00', '0', '真的有事情啊', '1933040224980807682', '1934198072309829635', 0, '2025-06-15 18:37:29', '2025-06-16 21:23:16');
INSERT INTO `attendance` VALUES ('1934198637517459458', NULL, '2', '2025-06-04 08:00:00', '1', NULL, '1933040224980807682', '1934198072309829635', 0, '2025-06-15 18:37:46', '2025-06-15 18:37:48');
INSERT INTO `attendance` VALUES ('1934598622566248450', '葛兆博', '4', '2025-06-16 16:00:00', '0', '生病了，需要请个假休息休息', '1933040224980807682', '1934199549174599682', 0, '2025-06-16 21:07:09', '2025-06-16 21:07:09');
INSERT INTO `attendance` VALUES ('1934604170229542914', NULL, '1', '2025-06-02 08:00:00', '0', '有事情', '1340584045776916482', '1926264192198017027', 0, '2025-06-16 21:29:12', '2025-06-16 21:29:12');

-- ----------------------------
-- Table structure for clerk
-- ----------------------------
DROP TABLE IF EXISTS `clerk`;
CREATE TABLE `clerk`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '职员姓名',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '性别:0->女,1->男',
  `phone_number` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号码',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱地址',
  `photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '照片',
  `id_card` char(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证号',
  `address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '家庭住址',
  `skills` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '专业技能，JSON格式存储',
  `position` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '职位',
  `department_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '部门编号',
  `user_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户账号编号',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_clerk_email`(`email` ASC) USING BTREE,
  INDEX `idx_clerk_skills`(`skills`(255) ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '职员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of clerk
-- ----------------------------
INSERT INTO `clerk` VALUES ('1638778252236267521', '张三', '1', '13333333333', 'zhangsan@company.com', '/files/063cae42f8d74b43b46bcde8ec28c5e4file.png', '445111111111111111', '北京市', '[\"Java\", \"Spring Boot\", \"MySQL\", \"Vue.js\"]', '主管', '1340584045776916482', '1638778252097855489', 0, '2025-03-23 13:42:37', '2025-03-24 00:54:39');
INSERT INTO `clerk` VALUES ('1638779582375895042', '李四', '0', '15811111111', 'lisi@company.com', '/files/44f2d988c637407bb94f70ae12061c95file.png', '512111111111111111', '上海市', '[\"Python\", \"Django\", \"PostgreSQL\", \"React\"]', '普通职员', '1340584967022235649', '1638779582187151361', 0, '2025-03-23 13:47:54', '2025-03-24 00:54:47');
INSERT INTO `clerk` VALUES ('1638779765465653250', '王五', '1', '14777777777', 'wangwu@company.com', '/files/f3983b8376fe40d9b5b8ac1c8b830b7bfile.png', '147777444444445555', '重庆市', '[\"项目管理\", \"团队协作\", \"战略规划\"]', '总经理', '1340585021044871170', '1638779765335629826', 0, '2025-03-23 13:48:38', '2025-03-24 00:54:59');
INSERT INTO `clerk` VALUES ('1638780386969231362', '刘六', '1', '18977777777', NULL, '/files/cc8550c3b13c4a15a13da36222ff7ac2file.png', '445444444444444444', '海口市', '[\"JavaScript\", \"Node.js\", \"MongoDB\"]', '普通职工', '1340603278481043457', '1638780386969231361', 0, '2025-03-23 13:51:06', '2025-03-24 00:55:12');
INSERT INTO `clerk` VALUES ('1638781944314306561', '小明', '0', '15944444444', NULL, '/files/67879d35362341fa9abfbaef3078c2ccfile.png', '445111111111111111', '乌兰察布市', '[\"UI设计\", \"Photoshop\", \"Figma\"]', '普通职工', '1340585021044871170', '1638781944117174273', 0, '2025-03-23 13:57:17', '2025-03-24 00:55:21');
INSERT INTO `clerk` VALUES ('1922584583866699778', '葛兆博', '1', '13206861101', NULL, '/files/1043e70da7dd447ea7b2f47fb3f475f6file.png', '231025200402140610', 'hrbust西区7-240', NULL, '大哥', '1340584045776916482', '1922584583866699777', 1, '2025-05-14 17:27:39', '2025-05-14 17:27:39');
INSERT INTO `clerk` VALUES ('1926178966268575747', '葛兆博2', '1', '13206861102', '2578567273@qq.com', '/files/8e76849aab7947d09ff64a7ac7a6f2b5file.png', '231025200402140610', 'hrbust西区7-240', '[\"拍马屁，摸鱼\"]', '植物', '1340603278481043457', '1926178966268575746', 0, '2025-05-24 15:30:27', '2025-06-16 20:42:13');
INSERT INTO `clerk` VALUES ('1926264192198017027', '葛兆博3', '1', '13206861103', NULL, '/files/ddebaaaec0ca481fa57e9f43b44ee185file.png', '231025200402140610', 'hrbust', NULL, '植物', '1340584045776916482', '1926264192198017026', 0, '2025-05-24 21:09:06', '2025-05-24 21:10:53');
INSERT INTO `clerk` VALUES ('1933322231820357634', '葛兆博3', '1', '13206861104', NULL, '/files/e8d7f31c4deb4f2ea4fa170535e63addfile.png', '231025200402140610', 'hrbust', NULL, '植物', '1933040224980807682', '1933322231820357633', 1, '2025-06-13 08:35:14', '2025-06-13 08:35:14');
INSERT INTO `clerk` VALUES ('1933328363725033474', '葛兆博6', '1', '13206861105', NULL, '/files/49ee797154b346de9bfbf3e37b7b6378file.png', '231025200402140610', 'hrbust', NULL, '普通职工', '1933327914259222530', '1933328363657924610', 1, '2025-06-13 08:59:36', '2025-06-13 08:59:36');
INSERT INTO `clerk` VALUES ('1934197749906264067', '葛兆博66', '1', '13206861108', NULL, '/files/d0f5ff2a083b43bc9ef9ae30961acac5file.png', '231025200402140610', 'Hrbust', NULL, '植物', '1934197451720609793', '1934197749906264066', 0, '2025-06-15 18:34:14', '2025-06-15 18:34:14');
INSERT INTO `clerk` VALUES ('1934198072309829635', '葛兆博i', '1', '13206861109', NULL, '/files/046beba9d48a4b90ba6e326d7ef41101file.png', '231025200402140610', 'hrbust', NULL, '植物', '1933040224980807682', '1934198072309829634', 0, '2025-06-15 18:35:31', '2025-06-15 18:36:54');
INSERT INTO `clerk` VALUES ('1934199549174599682', '葛兆博', '1', '13206861101', '936383586@qq.com', '/files/c1794a96ded9403db848993752d4c0eafile.png', '231025200402140610', 'Hrbust1', '[\"java\"]', 'boss', '1933040224980807682', '1934199549174599681', 0, '2025-06-15 18:41:23', '2025-06-16 19:24:01');

-- ----------------------------
-- Table structure for clerk_through
-- ----------------------------
DROP TABLE IF EXISTS `clerk_through`;
CREATE TABLE `clerk_through`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `clerk_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '员工id',
  `position` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '职位',
  `department_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '部门编号',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工经历表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of clerk_through
-- ----------------------------
INSERT INTO `clerk_through` VALUES ('1638778252299182081', '1638778252236267521', '主管', '1340584045776916482', 0, '2025-03-23 13:42:37', '2025-03-23 13:42:37');
INSERT INTO `clerk_through` VALUES ('1638779582375895044', '1638779582375895042', '普通职员', '1340584967022235649', 0, '2025-03-23 13:47:54', '2025-03-23 13:47:54');
INSERT INTO `clerk_through` VALUES ('1638779765465653252', '1638779765465653250', '总经理', '1340585021044871170', 0, '2025-03-23 13:48:38', '2025-03-23 13:48:38');
INSERT INTO `clerk_through` VALUES ('1638780386969231364', '1638780386969231362', '普通职工', '1340603278481043457', 0, '2025-03-23 13:51:06', '2025-03-23 13:51:06');
INSERT INTO `clerk_through` VALUES ('1638781944314306563', '1638781944314306561', '普通职工', '1340585021044871170', 0, '2025-03-23 13:57:17', '2025-03-23 13:57:17');
INSERT INTO `clerk_through` VALUES ('1922584583929614338', '1922584583866699778', '大哥', '1340584045776916482', 0, '2025-05-14 17:27:39', '2025-05-14 17:27:39');
INSERT INTO `clerk_through` VALUES ('1926178966331490307', '1926178966268575747', '植物', '1340603278481043457', 0, '2025-05-24 15:30:27', '2025-05-24 15:30:27');
INSERT INTO `clerk_through` VALUES ('1926264192265125889', '1926264192198017027', '植物', '1340584967022235649', 0, '2025-05-24 21:09:06', '2025-05-24 21:09:06');
INSERT INTO `clerk_through` VALUES ('1926264640682360834', '1926264192198017027', '植物', '1340584045776916482', 0, '2025-05-24 21:10:53', '2025-05-24 21:10:53');
INSERT INTO `clerk_through` VALUES ('1933322231820357636', '1933322231820357634', '植物', '1933040224980807682', 0, '2025-06-13 08:35:14', '2025-06-13 08:35:14');
INSERT INTO `clerk_through` VALUES ('1933328363725033476', '1933328363725033474', '普通职工', '1933327914259222530', 0, '2025-06-13 08:59:36', '2025-06-13 08:59:36');
INSERT INTO `clerk_through` VALUES ('1934197749906264069', '1934197749906264067', '植物', '1934197451720609793', 0, '2025-06-15 18:34:14', '2025-06-15 18:34:14');
INSERT INTO `clerk_through` VALUES ('1934198072372744195', '1934198072309829635', '植物', '1934197451720609793', 0, '2025-06-15 18:35:31', '2025-06-15 18:35:31');
INSERT INTO `clerk_through` VALUES ('1934198419375902721', '1934198072309829635', '植物', '1933040224980807682', 0, '2025-06-15 18:36:54', '2025-06-15 18:36:54');
INSERT INTO `clerk_through` VALUES ('1934199549174599684', '1934199549174599682', 'boss', '1933040224980807682', 0, '2025-06-15 18:41:23', '2025-06-15 18:41:23');

-- ----------------------------
-- Table structure for contract
-- ----------------------------
DROP TABLE IF EXISTS `contract`;
CREATE TABLE `contract`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '合同名称',
  `time` datetime NULL DEFAULT NULL COMMENT '签约日期',
  `clerk_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '员工id',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  `timeout` datetime NULL DEFAULT NULL COMMENT '截至时间',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '合同表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contract
-- ----------------------------
INSERT INTO `contract` VALUES ('1639122704003883009', '张三的卖身契', '2025-03-24 20:28:34', '1638778252236267521', 0, '2025-03-24 12:31:21', '2025-03-24 12:31:21', '2025-03-24 08:00:00', '/files/e4846f83b274452996e1c1fef4e050cefile.png');
INSERT INTO `contract` VALUES ('1928323825540612097', '葛兆博的终身合同', '2025-05-30 08:00:00', '1922584583866699778', 0, '2025-05-30 13:33:21', '2025-05-30 13:33:21', '2034-05-05 08:00:00', '/files/a2e7c71094df47cc829b107e7a6d2c9dfile.png');
INSERT INTO `contract` VALUES ('1933321472248680449', '葛兆博2的合同', '2025-06-01 08:00:00', '1926178966268575747', 0, '2025-06-13 08:32:13', '2025-06-13 08:32:13', '2029-06-01 08:00:00', '/files/f772123d51cd447b9e02e2276d486606file.png');
INSERT INTO `contract` VALUES ('1933328673436635137', '葛兆博6的合同', '2025-06-01 08:00:00', '1933328363725033474', 0, '2025-06-13 09:00:50', '2025-06-13 09:00:50', '2030-06-01 08:00:00', '/files/18a083ce33bb48fc8c3b8ad1265cffa4file.png');
INSERT INTO `contract` VALUES ('1934199026417520641', '葛兆博的第二个合同', '2025-06-01 08:00:00', '1926178966268575747', 0, '2025-06-15 18:39:18', '2025-06-15 18:39:18', '2031-06-01 08:00:00', '/files/a2178850d9294135a2f545896e2f5377file.png');

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '部门名称',
  `note` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES ('1340584045776916482', '人事部门', NULL, 0, '2025-05-20 17:05:18', '2025-06-12 13:54:27');
INSERT INTO `department` VALUES ('1340584967022235649', '运营部门', NULL, 0, '2025-05-20 17:08:58', '2025-05-20 18:22:14');
INSERT INTO `department` VALUES ('1340585021044871170', '市场部', NULL, 0, '2025-05-20 17:09:11', '2025-05-20 17:09:11');
INSERT INTO `department` VALUES ('1340603143789359106', '后勤部', NULL, 1, '2025-05-20 18:21:11', '2025-05-20 18:21:11');
INSERT INTO `department` VALUES ('1340603278481043457', '后勤部', NULL, 0, '2025-05-20 18:21:43', '2025-05-20 18:21:43');
INSERT INTO `department` VALUES ('1926269474223456258', '摸鱼部', '摸鱼', 0, '2025-05-24 21:30:06', '2025-05-24 21:30:06');
INSERT INTO `department` VALUES ('1933040224980807682', '葛兆博的部门', NULL, 0, '2025-06-12 13:54:38', '2025-06-13 09:09:46');
INSERT INTO `department` VALUES ('1933327914259222530', '葛兆博4', NULL, 0, '2025-06-13 08:57:49', '2025-06-13 08:57:49');
INSERT INTO `department` VALUES ('1934197451720609793', 'oooo', NULL, 0, '2025-06-15 18:33:03', '2025-06-15 18:33:03');

-- ----------------------------
-- Table structure for rewards_punishments
-- ----------------------------
DROP TABLE IF EXISTS `rewards_punishments`;
CREATE TABLE `rewards_punishments`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '奖惩类型:0奖励，1惩罚',
  `time` datetime NULL DEFAULT NULL COMMENT '奖惩日期',
  `reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '奖惩原因',
  `amount` decimal(19, 4) NULL DEFAULT NULL COMMENT '奖惩金额',
  `note` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `clerk_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '员工id',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  `department_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '部门编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '奖惩表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rewards_punishments
-- ----------------------------
INSERT INTO `rewards_punishments` VALUES ('1926175391320670210', '0', '2025-05-01 08:00:00', '学习积极', 1000.0000, NULL, '1922584583866699778', 0, '2025-05-24 15:16:15', '2025-05-24 15:16:15', '1340584045776916482');
INSERT INTO `rewards_punishments` VALUES ('1933321654185005057', '0', '2025-06-05 08:00:00', '牛逼', 500.0000, NULL, '1922584583866699778', 0, '2025-06-13 08:32:56', '2025-06-13 08:32:56', '1340584045776916482');
INSERT INTO `rewards_punishments` VALUES ('1933328491122823169', '0', '2025-06-06 08:00:00', '没有原因', 500.0000, NULL, '1933328363725033474', 0, '2025-06-13 09:00:06', '2025-06-13 09:00:06', '1933327914259222530');
INSERT INTO `rewards_punishments` VALUES ('1934198793365213186', '0', '2025-06-05 08:00:00', '无', 500.0000, NULL, '1926178966268575747', 0, '2025-06-15 18:38:23', '2025-06-15 18:38:29', '1340603278481043457');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `userid` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限名称',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '1', '管理员', 0, '2025-05-15 08:22:01', '2025-05-15 08:22:03');
INSERT INTO `role` VALUES ('1638778252236267522', '1638778252097855489', '职员', 0, '2025-05-23 13:42:37', '2025-05-23 13:42:37');
INSERT INTO `role` VALUES ('1638779582375895043', '1638779582187151361', '职员', 0, '2025-05-23 13:47:54', '2025-05-23 13:47:54');
INSERT INTO `role` VALUES ('1638779765465653251', '1638779765335629826', '职员', 0, '2025-05-23 13:48:38', '2025-05-23 13:48:38');
INSERT INTO `role` VALUES ('1638780386969231363', '1638780386969231361', '职员', 0, '2025-05-23 13:51:06', '2025-05-23 13:51:06');
INSERT INTO `role` VALUES ('1638781944314306562', '1638781944117174273', '职员', 0, '2025-05-23 13:57:17', '2025-05-23 13:57:17');
INSERT INTO `role` VALUES ('1638782217577406465', '1638778252097855489', '人事经理', 0, '2025-05-23 13:58:22', '2025-05-23 13:58:22');
INSERT INTO `role` VALUES ('1922584583929614337', '1922584583866699777', '职员', 1, '2025-05-14 17:27:39', '2025-05-14 17:27:39');
INSERT INTO `role` VALUES ('1922584700313161729', '1922584583866699777', '人事经理', 1, '2025-05-14 17:28:07', '2025-05-14 17:28:07');
INSERT INTO `role` VALUES ('1926178966331490306', '1926178966268575746', '职员', 0, '2025-05-24 15:30:27', '2025-05-24 15:30:27');
INSERT INTO `role` VALUES ('1926264192198017028', '1926264192198017026', '职员', 0, '2025-05-24 21:09:06', '2025-05-24 21:09:06');
INSERT INTO `role` VALUES ('1933322231820357635', '1933322231820357633', '职员', 1, '2025-06-13 08:35:14', '2025-06-13 08:35:14');
INSERT INTO `role` VALUES ('1933327850237366273', '1638780386969231361', '人事经理', 0, '2025-06-13 08:57:34', '2025-06-13 08:57:34');
INSERT INTO `role` VALUES ('1933328363725033475', '1933328363657924610', '职员', 1, '2025-06-13 08:59:36', '2025-06-13 08:59:36');
INSERT INTO `role` VALUES ('1934197749906264068', '1934197749906264066', '职员', 0, '2025-06-15 18:34:14', '2025-06-15 18:34:14');
INSERT INTO `role` VALUES ('1934197806265126914', '1934197749906264066', '人事经理', 0, '2025-06-15 18:34:27', '2025-06-15 18:34:27');
INSERT INTO `role` VALUES ('1934198072372744194', '1934198072309829634', '职员', 0, '2025-06-15 18:35:31', '2025-06-15 18:35:31');
INSERT INTO `role` VALUES ('1934199549174599683', '1934199549174599681', '职员', 0, '2025-06-15 18:41:23', '2025-06-15 18:41:23');
INSERT INTO `role` VALUES ('1934199570276143106', '1934199549174599681', '人事经理', 0, '2025-06-15 18:41:28', '2025-06-15 18:41:28');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户账号',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名',
  `introduction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户介绍',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户头像',
  `is_deleted` int NULL DEFAULT 0,
  `gmt_create` datetime NULL DEFAULT NULL,
  `gmt_modified` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', 'e10adc3949ba59abbe56e057f20f883e', '超级管理员', '公司老板', '/files/5131184693674b5c8ad9e938babf6cd4file.png', 0, '2025-05-15 08:21:25', '2025-05-15 08:21:26');
INSERT INTO `user` VALUES ('1638778252097855489', '13333333333', 'e10adc3949ba59abbe56e057f20f883e', '张三', NULL, '/files/28a5961efa5148ecb9a616c615c98d76file.png', 0, '2025-05-23 13:42:37', '2025-05-24 00:58:01');
INSERT INTO `user` VALUES ('1638779582187151361', '15811111111', 'e10adc3949ba59abbe56e057f20f883e', '李四', NULL, '/files/5131184693674b5c8ad9e938babf6cd4file.png', 0, '2025-05-23 13:47:54', '2025-05-24 00:54:47');
INSERT INTO `user` VALUES ('1638779765335629826', '14777777777', 'e10adc3949ba59abbe56e057f20f883e', '王五', NULL, '/files/5131184693674b5c8ad9e938babf6cd4file.png', 0, '2025-05-23 13:48:38', '2025-05-24 00:54:59');
INSERT INTO `user` VALUES ('1638780386969231361', '18977777777', 'e10adc3949ba59abbe56e057f20f883e', '刘六', NULL, '/files/5131184693674b5c8ad9e938babf6cd4file.png', 0, '2025-05-23 13:51:06', '2025-05-24 00:55:12');
INSERT INTO `user` VALUES ('1638781944117174273', '15944444444', 'e10adc3949ba59abbe56e057f20f883e', '小明', NULL, '/files/5131184693674b5c8ad9e938babf6cd4file.png', 0, '2025-05-23 13:57:17', '2025-05-24 00:55:21');
INSERT INTO `user` VALUES ('1922584583866699777', '13206861101', 'a354408cf3c56b939987e8609b899ec9', '葛兆博', '冷酷低调', '/files/1043e70da7dd447ea7b2f47fb3f475f6file.png', 1, '2025-05-14 17:27:39', '2025-06-13 08:42:43');
INSERT INTO `user` VALUES ('1926178966268575746', '13206861102', 'e10adc3949ba59abbe56e057f20f883e', '葛兆博2', '888', '/files/8e76849aab7947d09ff64a7ac7a6f2b5file.png', 0, '2025-05-24 15:30:27', '2025-06-15 18:40:11');
INSERT INTO `user` VALUES ('1926264192198017026', '13206861103', 'e10adc3949ba59abbe56e057f20f883e', '葛兆博3', NULL, '/files/ddebaaaec0ca481fa57e9f43b44ee185file.png', 0, '2025-05-24 21:09:06', '2025-05-24 21:10:53');
INSERT INTO `user` VALUES ('1933322231820357633', '13206861104', 'e10adc3949ba59abbe56e057f20f883e', '葛兆博3', NULL, '/files/e8d7f31c4deb4f2ea4fa170535e63addfile.png', 1, '2025-06-13 08:35:14', '2025-06-13 08:35:14');
INSERT INTO `user` VALUES ('1933328363657924610', '13206861105', 'e10adc3949ba59abbe56e057f20f883e', '葛兆博6', '很帅', '/files/49ee797154b346de9bfbf3e37b7b6378file.png', 1, '2025-06-13 08:59:36', '2025-06-13 09:02:01');
INSERT INTO `user` VALUES ('1934197749906264066', '13206861108', 'e10adc3949ba59abbe56e057f20f883e', '葛兆博66', NULL, '/files/d0f5ff2a083b43bc9ef9ae30961acac5file.png', 0, '2025-06-15 18:34:14', '2025-06-15 18:34:14');
INSERT INTO `user` VALUES ('1934198072309829634', '13206861109', 'e10adc3949ba59abbe56e057f20f883e', '葛兆博i', NULL, '/files/046beba9d48a4b90ba6e326d7ef41101file.png', 0, '2025-06-15 18:35:31', '2025-06-15 18:36:54');
INSERT INTO `user` VALUES ('1934199549174599681', '13206861101', 'e10adc3949ba59abbe56e057f20f883e', '葛兆博', '666', '/files/c1794a96ded9403db848993752d4c0eafile.png', 0, '2025-06-15 18:41:23', '2025-06-16 17:37:02');

-- ----------------------------
-- View structure for v_ai_usage_overview
-- ----------------------------
DROP VIEW IF EXISTS `v_ai_usage_overview`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_ai_usage_overview` AS select `u`.`id` AS `user_id`,`u`.`username` AS `username`,coalesce(`c`.`name`,'未分配') AS `clerk_name`,coalesce(`d`.`name`,'未分配') AS `department_name`,count(`h`.`id`) AS `total_conversations`,count(distinct `h`.`session_id`) AS `total_sessions`,count(distinct `h`.`function_type`) AS `used_functions`,max(`h`.`created_time`) AS `last_usage_time`,cast(max(`h`.`created_time`) as date) AS `last_usage_date` from (((`user` `u` left join `clerk` `c` on(((`u`.`id` = `c`.`user_id`) and (`c`.`is_deleted` = 0)))) left join `department` `d` on(((`c`.`department_id` = `d`.`id`) and (`d`.`is_deleted` = 0)))) left join `ai_conversation_history` `h` on(((`u`.`id` = `h`.`user_id`) and (`h`.`is_deleted` = 0)))) where (`u`.`is_deleted` = 0) group by `u`.`id`,`u`.`username`,`c`.`name`,`d`.`name`;

-- ----------------------------
-- View structure for v_skill_statistics
-- ----------------------------
DROP VIEW IF EXISTS `v_skill_statistics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_skill_statistics` AS select `d`.`name` AS `department_name`,count(`c`.`id`) AS `total_employees`,count((case when ((`c`.`skills` is not null) and (`c`.`skills` <> '[]')) then 1 end)) AS `employees_with_skills`,round(((count((case when ((`c`.`skills` is not null) and (`c`.`skills` <> '[]')) then 1 end)) * 100.0) / count(`c`.`id`)),2) AS `skill_coverage_rate` from (`clerk` `c` left join `department` `d` on((`c`.`department_id` = `d`.`id`))) where (`c`.`is_deleted` = 0) group by `d`.`id`,`d`.`name` order by `skill_coverage_rate` desc;

-- ----------------------------
-- Procedure structure for CleanExpiredAIHistory
-- ----------------------------
DROP PROCEDURE IF EXISTS `CleanExpiredAIHistory`;
delimiter ;;
CREATE PROCEDURE `CleanExpiredAIHistory`(IN days_to_keep INT)
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for GetAIUsageStats
-- ----------------------------
DROP PROCEDURE IF EXISTS `GetAIUsageStats`;
delimiter ;;
CREATE PROCEDURE `GetAIUsageStats`(IN start_date DATE, IN end_date DATE)
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_calculate_salary
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_calculate_salary`;
delimiter ;;
CREATE PROCEDURE `sp_calculate_salary`(IN p_clerk_id BIGINT,
    IN p_salary_month VARCHAR(7),
    IN p_basic_salary DECIMAL(10,2),
    IN p_performance_bonus DECIMAL(10,2),
    IN p_allowance DECIMAL(10,2),
    IN p_social_insurance_rate DECIMAL(5,4),
    IN p_housing_fund_rate DECIMAL(5,4),
    OUT p_social_insurance DECIMAL(10,2),
    OUT p_housing_fund DECIMAL(10,2),
    OUT p_personal_tax DECIMAL(10,2),
    OUT p_total_deduction DECIMAL(10,2),
    OUT p_net_salary DECIMAL(10,2))
BEGIN
    DECLARE v_total_income DECIMAL(10,2);
    DECLARE v_taxable_income DECIMAL(10,2);
    
    -- 计算总收入
    SET v_total_income = p_basic_salary + p_performance_bonus + p_allowance;
    
    -- 计算社保
    SET p_social_insurance = v_total_income * p_social_insurance_rate;
    
    -- 计算公积金
    SET p_housing_fund = v_total_income * p_housing_fund_rate;
    
    -- 计算应税收入（总收入 - 社保 - 公积金 - 5000起征点）
    SET v_taxable_income = v_total_income - p_social_insurance - p_housing_fund - 5000;
    
    -- 计算个人所得税（简化计算，实际应按税率表计算）
    IF v_taxable_income <= 0 THEN
        SET p_personal_tax = 0;
    ELSEIF v_taxable_income <= 3000 THEN
        SET p_personal_tax = v_taxable_income * 0.03;
    ELSEIF v_taxable_income <= 12000 THEN
        SET p_personal_tax = v_taxable_income * 0.10 - 210;
    ELSEIF v_taxable_income <= 25000 THEN
        SET p_personal_tax = v_taxable_income * 0.20 - 1410;
    ELSE
        SET p_personal_tax = v_taxable_income * 0.25 - 2660;
    END IF;
    
    -- 确保个税不为负数
    IF p_personal_tax < 0 THEN
        SET p_personal_tax = 0;
    END IF;
    
    -- 计算总扣除
    SET p_total_deduction = p_social_insurance + p_housing_fund + p_personal_tax;
    
    -- 计算实发工资
    SET p_net_salary = v_total_income - p_total_deduction;
    
    -- 确保实发工资不为负数
    IF p_net_salary < 0 THEN
        SET p_net_salary = 0;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_clerk_by_user_id
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_clerk_by_user_id`;
delimiter ;;
CREATE PROCEDURE `sp_get_clerk_by_user_id`(IN p_user_id CHAR(19))
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_clerk_profile
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_clerk_profile`;
delimiter ;;
CREATE PROCEDURE `sp_get_clerk_profile`(IN p_clerk_id CHAR(19))
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_search_clerks_by_skill
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_search_clerks_by_skill`;
delimiter ;;
CREATE PROCEDURE `sp_search_clerks_by_skill`(IN p_skill_keyword VARCHAR(100),
    IN p_page_num INT,
    IN p_page_size INT)
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_update_clerk_skills
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_update_clerk_skills`;
delimiter ;;
CREATE PROCEDURE `sp_update_clerk_skills`(IN p_clerk_id CHAR(19),
    IN p_skills TEXT)
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
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
