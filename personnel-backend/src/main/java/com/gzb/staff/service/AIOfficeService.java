package com.gzb.staff.service;

import com.gzb.staff.entity.AIConversationHistory;
import com.gzb.staff.entity.AIDocumentTemplate;
import com.gzb.staff.mapper.AIConversationHistoryMapper;
import com.gzb.staff.mapper.AIDocumentTemplateMapper;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

/**
 * AI办公服务类
 * 提供各种AI辅助办公功能
 */
@Service
@Transactional
public class AIOfficeService {

    @Autowired(required = false)
    private ChatClient chatClient;
    
    @Autowired
    private AIConversationHistoryMapper conversationHistoryMapper;
    
    @Autowired
    private AIDocumentTemplateMapper documentTemplateMapper;

    /**
     * 智能文档生成
     * @param documentType 文档类型（如：工作报告、会议纪要、通知公告等）
     * @param content 文档内容要点
     * @param department 部门信息
     * @param userId 用户ID
     * @return 生成的文档内容
     */
    public String generateDocument(String documentType, String content, String department, String userId) {
        String promptText = """
            请帮我生成一份{documentType}，要求如下：
            1. 部门：{department}
            2. 内容要点：{content}
            3. 格式要求：正式、专业、结构清晰
            4. 语言：中文
            
            请生成完整的文档内容。
            """;
        
        PromptTemplate promptTemplate = new PromptTemplate(promptText);
        Map<String, Object> variables = new HashMap<>();
        variables.put("documentType", documentType);
        variables.put("content", content);
        variables.put("department", department);
        
        Prompt prompt = promptTemplate.create(variables);
        
        if (chatClient == null) {
            return "AI服务未配置。请设置环境变量 OPENAI_API_KEY 为您的OpenAI API密钥，然后重启服务。\n\n" +
                   "配置步骤：\n" +
                   "1. 获取OpenAI API密钥：https://platform.openai.com/api-keys\n" +
                   "2. 设置环境变量：OPENAI_API_KEY=your_api_key\n" +
                   "3. 重启后端服务\n\n" +
                   "详细配置指南请参考项目根目录的 OPENAI_SETUP_GUIDE.md 文件。";
        }
        
        String result = chatClient.prompt(prompt).call().content();
        
        // 保存对话历史
        saveConversationHistory(userId, "document", 
            String.format("生成%s文档，部门：%s，内容：%s", documentType, department, content), 
            result);
        
        return result;
    }

    /**
     * 数据分析报告生成
     * @param dataDescription 数据描述
     * @param analysisType 分析类型
     * @param userId 用户ID
     * @return 分析报告
     */
    public String generateDataAnalysis(String dataDescription, String analysisType, String userId) {
        String promptText = """
            请基于以下数据信息生成{analysisType}分析报告：
            
            数据描述：{dataDescription}
            
            请提供：
            1. 数据概览
            2. 关键指标分析
            3. 趋势分析
            4. 问题识别
            5. 改进建议
            
            要求：专业、客观、有数据支撑
            """;
        
        PromptTemplate promptTemplate = new PromptTemplate(promptText);
        Map<String, Object> variables = new HashMap<>();
        variables.put("dataDescription", dataDescription);
        variables.put("analysisType", analysisType);
        
        Prompt prompt = promptTemplate.create(variables);
        
        if (chatClient == null) {
            return "AI服务未配置。请设置环境变量 OPENAI_API_KEY 为您的OpenAI API密钥，然后重启服务。\n\n" +
                   "配置步骤：\n" +
                   "1. 获取OpenAI API密钥：https://platform.openai.com/api-keys\n" +
                   "2. 设置环境变量：OPENAI_API_KEY=your_api_key\n" +
                   "3. 重启后端服务\n\n" +
                   "详细配置指南请参考项目根目录的 OPENAI_SETUP_GUIDE.md 文件。";
        }
        
        String result = chatClient.prompt(prompt).call().content();
        
        // 保存对话历史
        saveConversationHistory(userId, "analysis", 
            String.format("生成%s分析报告，数据：%s", analysisType, dataDescription), 
            result);
        
        return result;
    }

    /**
     * 智能问答
     * @param question 用户问题
     * @param context 上下文信息
     * @param userId 用户ID
     * @return AI回答
     */
    public String intelligentQA(String question, String context, String userId) {
        String promptText = """
            作为企业人事管理系统的AI助手，请回答以下问题：
            
            问题：{question}
            
            上下文信息：{context}
            
            请提供准确、专业的回答，如果涉及具体操作，请给出详细步骤。
            """;
        
        PromptTemplate promptTemplate = new PromptTemplate(promptText);
        Map<String, Object> variables = new HashMap<>();
        variables.put("question", question);
        variables.put("context", context != null ? context : "无特定上下文");
        
        Prompt prompt = promptTemplate.create(variables);
        
        if (chatClient == null) {
            return "AI服务未配置。请设置环境变量 OPENAI_API_KEY 为您的OpenAI API密钥，然后重启服务。\n\n" +
                   "配置步骤：\n" +
                   "1. 获取OpenAI API密钥：https://platform.openai.com/api-keys\n" +
                   "2. 设置环境变量：OPENAI_API_KEY=your_api_key\n" +
                   "3. 重启后端服务\n\n" +
                   "详细配置指南请参考项目根目录的 OPENAI_SETUP_GUIDE.md 文件。";
        }
        
        String result = chatClient.prompt(prompt).call().content();
        
        // 保存对话历史
        saveConversationHistory(userId, "qa", question, result);
        
        return result;
    }

    /**
     * 邮件内容生成
     * @param emailType 邮件类型
     * @param recipient 收件人
     * @param mainContent 主要内容
     * @return 邮件内容
     */
    public String generateEmail(String emailType, String recipient, String mainContent) {
        String promptText = """
            请帮我生成一封{emailType}邮件：
            
            收件人：{recipient}
            主要内容：{mainContent}
            
            要求：
            1. 格式规范
            2. 语言得体
            3. 内容完整
            4. 包含适当的称呼和结尾
            """;
        
        PromptTemplate promptTemplate = new PromptTemplate(promptText);
        Map<String, Object> variables = new HashMap<>();
        variables.put("emailType", emailType);
        variables.put("recipient", recipient);
        variables.put("mainContent", mainContent);
        
        Prompt prompt = promptTemplate.create(variables);
        
        if (chatClient == null) {
            return "AI服务未配置。请设置环境变量 OPENAI_API_KEY 为您的OpenAI API密钥，然后重启服务。\n\n" +
                   "配置步骤：\n" +
                   "1. 获取OpenAI API密钥：https://platform.openai.com/api-keys\n" +
                   "2. 设置环境变量：OPENAI_API_KEY=your_api_key\n" +
                   "3. 重启后端服务\n\n" +
                   "详细配置指南请参考项目根目录的 OPENAI_SETUP_GUIDE.md 文件。";
        }
        
        String result = chatClient.prompt(prompt).call().content();
        
        return result;
    }
    
    /**
     * 保存对话历史
     */
    private void saveConversationHistory(String userId, String functionType, String question, String answer) {
        AIConversationHistory history = new AIConversationHistory();
        history.setUserId(userId);
        history.setSessionId(UUID.randomUUID().toString());
        history.setFunctionType(functionType);
        history.setQuestion(question);
        history.setAnswer(answer);
        history.setCreatedTime(LocalDateTime.now());
        conversationHistoryMapper.insert(history);
    }
    
    /**
     * 获取用户对话历史
     */
    public List<AIConversationHistory> getUserConversationHistory(String userId, Integer limit) {
        return conversationHistoryMapper.selectRecentByUser(userId, limit != null ? limit : 10);
    }
    
    /**
     * 获取文档模板
     */
    public List<AIDocumentTemplate> getDocumentTemplates(String templateType) {
        if (templateType != null && !templateType.isEmpty()) {
            return documentTemplateMapper.selectByTemplateType(templateType);
        }
        return documentTemplateMapper.selectSystemTemplates();
    }
    
    /**
     * 保存自定义模板
     */
    public boolean saveCustomTemplate(AIDocumentTemplate template) {
        template.setCreatedTime(LocalDateTime.now());
        template.setUpdatedTime(LocalDateTime.now());
        template.setIsSystem(0);
        template.setUsageCount(0);
        return documentTemplateMapper.insert(template) > 0;
    }
    
    /**
     * 使用模板生成文档
     */
    public String generateDocumentFromTemplate(String templateId, Map<String, String> variables, String userId) {
        AIDocumentTemplate template = documentTemplateMapper.selectById(templateId);
        if (template == null) {
            throw new RuntimeException("模板不存在");
        }
        
        // 替换模板变量
        String content = template.getTemplateContent();
        for (Map.Entry<String, String> entry : variables.entrySet()) {
            content = content.replace("{" + entry.getKey() + "}", entry.getValue());
        }
        
        // 增加使用次数
        documentTemplateMapper.incrementUsageCount(templateId);
        
        // 保存对话历史
        saveConversationHistory(userId, "template", 
            "使用模板：" + template.getTemplateName(), content);
        
        return content;
    }

    /**
     * 会议纪要生成
     * @param meetingTitle 会议主题
     * @param participants 参会人员
     * @param keyPoints 关键要点
     * @return 会议纪要
     */
    public String generateMeetingMinutes(String meetingTitle, List<String> participants, String keyPoints) {
        String promptText = """
            请生成会议纪要：
            
            会议主题：{meetingTitle}
            参会人员：{participants}
            关键要点：{keyPoints}
            
            请按照标准会议纪要格式生成，包括：
            1. 会议基本信息
            2. 参会人员
            3. 会议内容
            4. 决议事项
            5. 后续行动
            """;
        
        PromptTemplate promptTemplate = new PromptTemplate(promptText);
        Map<String, Object> variables = new HashMap<>();
        variables.put("meetingTitle", meetingTitle);
        variables.put("participants", String.join("、", participants));
        variables.put("keyPoints", keyPoints);
        
        Prompt prompt = promptTemplate.create(variables);
        
        if (chatClient == null) {
            return "AI服务未配置。请设置环境变量 OPENAI_API_KEY 为您的OpenAI API密钥，然后重启服务。\n\n" +
                   "配置步骤：\n" +
                   "1. 获取OpenAI API密钥：https://platform.openai.com/api-keys\n" +
                   "2. 设置环境变量：OPENAI_API_KEY=your_api_key\n" +
                   "3. 重启后端服务\n\n" +
                   "详细配置指南请参考项目根目录的 OPENAI_SETUP_GUIDE.md 文件。";
        }
        
        return chatClient.prompt(prompt).call().content();
    }

    /**
     * 工作计划生成
     * @param planType 计划类型（周计划、月计划、季度计划等）
     * @param objectives 目标
     * @param resources 可用资源
     * @return 工作计划
     */
    public String generateWorkPlan(String planType, String objectives, String resources) {
        String promptText = """
            请帮我制定{planType}：
            
            目标：{objectives}
            可用资源：{resources}
            
            请提供：
            1. 目标分解
            2. 时间安排
            3. 资源配置
            4. 风险评估
            5. 成功指标
            """;
        
        PromptTemplate promptTemplate = new PromptTemplate(promptText);
        Map<String, Object> variables = new HashMap<>();
        variables.put("planType", planType);
        variables.put("objectives", objectives);
        variables.put("resources", resources);
        
        Prompt prompt = promptTemplate.create(variables);
        
        if (chatClient == null) {
            return "AI服务未配置。请设置环境变量 OPENAI_API_KEY 为您的OpenAI API密钥，然后重启服务。\n\n" +
                   "配置步骤：\n" +
                   "1. 获取OpenAI API密钥：https://platform.openai.com/api-keys\n" +
                   "2. 设置环境变量：OPENAI_API_KEY=your_api_key\n" +
                   "3. 重启后端服务\n\n" +
                   "详细配置指南请参考项目根目录的 OPENAI_SETUP_GUIDE.md 文件。";
        }
        
        return chatClient.prompt(prompt).call().content();
    }
}