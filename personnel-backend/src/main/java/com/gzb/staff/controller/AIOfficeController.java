package com.gzb.staff.controller;

import com.gzb.staff.service.AIOfficeService;
import com.gzb.staff.utils.R;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * AI办公功能控制器
 * 为所有角色提供AI辅助办公功能
 */
@RestController
@RequestMapping("/staff/ai-office")
@CrossOrigin
@Tag(name = "AI办公", description = "AI辅助办公功能接口")
public class AIOfficeController {

    @Autowired
    private AIOfficeService aiOfficeService;

    /**
     * 智能文档生成
     */
    @PostMapping("/generate-document")
    @Operation(summary = "智能文档生成", description = "根据输入内容生成各类办公文档")
    public R generateDocument(@RequestBody Map<String, String> request) {
        try {
            String documentType = request.get("documentType");
            String content = request.get("content");
            String department = request.get("department");
            
            String userId = request.get("userId");
            String result = aiOfficeService.generateDocument(documentType, content, department, userId);
            return R.ok().data("document", result);
        } catch (Exception e) {
            return R.error().message("文档生成失败：" + e.getMessage());
        }
    }

    /**
     * 数据分析报告生成
     */
    @PostMapping("/generate-analysis")
    @Operation(summary = "数据分析报告生成", description = "基于数据生成分析报告")
    public R generateDataAnalysis(@RequestBody Map<String, String> request) {
        try {
            String dataDescription = request.get("dataDescription");
            String analysisType = request.get("analysisType");
            
            String userId = request.get("userId");
            String result = aiOfficeService.generateDataAnalysis(dataDescription, analysisType, userId);
            return R.ok().data("analysis", result);
        } catch (Exception e) {
            return R.error().message("分析报告生成失败：" + e.getMessage());
        }
    }

    /**
     * 智能问答
     */
    @PostMapping("/intelligent-qa")
    @Operation(summary = "智能问答", description = "AI助手回答用户问题")
    public R intelligentQA(@RequestBody Map<String, String> request) {
        try {
            String question = request.get("question");
            String context = request.get("context");
            
            String userId = request.get("userId");
            String result = aiOfficeService.intelligentQA(question, context, userId);
            return R.ok().data("answer", result);
        } catch (Exception e) {
            return R.error().message("问答服务失败：" + e.getMessage());
        }
    }

    /**
     * 邮件内容生成
     */
    @PostMapping("/generate-email")
    @Operation(summary = "邮件内容生成", description = "生成规范的邮件内容")
    public R generateEmail(@RequestBody Map<String, String> request) {
        try {
            String emailType = request.get("emailType");
            String recipient = request.get("recipient");
            String mainContent = request.get("mainContent");
            
            String result = aiOfficeService.generateEmail(emailType, recipient, mainContent);
            return R.ok().data("email", result);
        } catch (Exception e) {
            return R.error().message("邮件生成失败：" + e.getMessage());
        }
    }

    /**
     * 会议纪要生成
     */
    @PostMapping("/generate-meeting-minutes")
    @Operation(summary = "会议纪要生成", description = "生成标准格式的会议纪要")
    public R generateMeetingMinutes(@RequestBody Map<String, Object> request) {
        try {
            String meetingTitle = (String) request.get("meetingTitle");
            @SuppressWarnings("unchecked")
            List<String> participants = (List<String>) request.get("participants");
            String keyPoints = (String) request.get("keyPoints");
            
            String result = aiOfficeService.generateMeetingMinutes(meetingTitle, participants, keyPoints);
            return R.ok().data("minutes", result);
        } catch (Exception e) {
            return R.error().message("会议纪要生成失败：" + e.getMessage());
        }
    }

    /**
     * 工作计划生成
     */
    @PostMapping("/generate-work-plan")
    @Operation(summary = "工作计划生成", description = "生成详细的工作计划")
    public R generateWorkPlan(@RequestBody Map<String, String> request) {
        try {
            String planType = request.get("planType");
            String objectives = request.get("objectives");
            String resources = request.get("resources");
            
            String result = aiOfficeService.generateWorkPlan(planType, objectives, resources);
            return R.ok().data("plan", result);
        } catch (Exception e) {
            return R.error().message("工作计划生成失败：" + e.getMessage());
        }
    }

    /**
     * 获取AI功能列表
     */
    @GetMapping("/functions")
    @Operation(summary = "获取AI功能列表", description = "获取所有可用的AI办公功能")
    public R getAIFunctions() {
        try {
            return R.ok().data("functions", java.util.Arrays.asList(
                Map.of("id", "document", "name", "智能文档生成", "description", "生成各类办公文档"),
                Map.of("id", "analysis", "name", "数据分析报告", "description", "基于数据生成分析报告"),
                Map.of("id", "qa", "name", "智能问答", "description", "AI助手回答问题"),
                Map.of("id", "email", "name", "邮件生成", "description", "生成规范邮件内容"),
                Map.of("id", "meeting", "name", "会议纪要", "description", "生成会议纪要"),
                Map.of("id", "plan", "name", "工作计划", "description", "制定工作计划")
            ));
        } catch (Exception e) {
            return R.error().message("获取功能列表失败：" + e.getMessage());
        }
    }

    /**
     * 获取文档模板类型
     */
    @GetMapping("/document-types")
    @Operation(summary = "获取文档模板类型", description = "获取支持的文档类型列表")
    public R getDocumentTypes() {
        try {
            return R.ok().data("types", java.util.Arrays.asList(
                "工作报告", "会议纪要", "通知公告", "工作总结", 
                "项目方案", "培训计划", "考核报告", "请假申请",
                "工作交接", "部门规划", "制度文件", "活动方案"
            ));
        } catch (Exception e) {
            return R.error().message("获取文档类型失败：" + e.getMessage());
        }
    }

    /**
     * 获取分析类型
     */
    @GetMapping("/analysis-types")
    @Operation(summary = "获取分析类型", description = "获取支持的数据分析类型")
    public R getAnalysisTypes() {
        try {
            return R.ok().data("types", java.util.Arrays.asList(
                "员工绩效分析", "部门效率分析", "考勤统计分析", "薪资结构分析",
                "培训效果分析", "离职率分析", "招聘效果分析", "成本分析"
            ));
        } catch (Exception e) {
            return R.error().message("获取分析类型失败：" + e.getMessage());
        }
    }

    /**
     * 获取用户对话历史
     */
    @GetMapping("/conversation-history/{userId}")
    @Operation(summary = "获取对话历史", description = "获取用户的AI对话历史记录")
    public R getConversationHistory(@PathVariable String userId, 
                                   @RequestParam(defaultValue = "10") Integer limit) {
        try {
            return R.ok().data("history", aiOfficeService.getUserConversationHistory(userId, limit));
        } catch (Exception e) {
            return R.error().message("获取对话历史失败：" + e.getMessage());
        }
    }

    /**
     * 获取文档模板
     */
    @GetMapping("/templates")
    @Operation(summary = "获取文档模板", description = "获取可用的文档模板")
    public R getDocumentTemplates(@RequestParam(required = false) String templateType) {
        try {
            return R.ok().data("templates", aiOfficeService.getDocumentTemplates(templateType));
        } catch (Exception e) {
            return R.error().message("获取模板失败：" + e.getMessage());
        }
    }

    /**
     * 保存自定义模板
     */
    @PostMapping("/save-template")
    @Operation(summary = "保存自定义模板", description = "保存用户自定义的文档模板")
    public R saveCustomTemplate(@RequestBody Map<String, String> request) {
        try {
            com.gzb.staff.entity.AIDocumentTemplate template = new com.gzb.staff.entity.AIDocumentTemplate();
            template.setTemplateName(request.get("templateName"));
            template.setTemplateType(request.get("templateType"));
            template.setTemplateContent(request.get("templateContent"));
            template.setDepartmentId(request.get("departmentId"));
            template.setRoleType(request.get("roleType"));
            template.setCreatorId(request.get("creatorId"));
            
            boolean success = aiOfficeService.saveCustomTemplate(template);
            if (success) {
                return R.ok().message("模板保存成功");
            } else {
                return R.error().message("模板保存失败");
            }
        } catch (Exception e) {
            return R.error().message("保存模板失败：" + e.getMessage());
        }
    }

    /**
     * 使用模板生成文档
     */
    @PostMapping("/generate-from-template")
    @Operation(summary = "使用模板生成文档", description = "基于模板生成文档内容")
    public R generateFromTemplate(@RequestBody Map<String, Object> request) {
        try {
            String templateId = (String) request.get("templateId");
            String userId = (String) request.get("userId");
            @SuppressWarnings("unchecked")
            Map<String, String> variables = (Map<String, String>) request.get("variables");
            
            String result = aiOfficeService.generateDocumentFromTemplate(templateId, variables, userId);
            return R.ok().data("document", result);
        } catch (Exception e) {
            return R.error().message("模板生成失败：" + e.getMessage());
        }
    }
}