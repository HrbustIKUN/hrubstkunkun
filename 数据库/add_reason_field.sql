-- 为考勤表添加请假原因字段
USE staff_information_management2;

-- 添加reason字段到attendance表
ALTER TABLE `attendance` 
ADD COLUMN `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请假原因' AFTER `audit`;

-- 查看表结构确认
DESC attendance;