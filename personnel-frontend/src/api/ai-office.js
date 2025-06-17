import request from '@/utils/request'

// 获取AI功能列表
export function getAIFunctions() {
  return request({
    url: '/ai-office/functions',
    method: 'get'
  })
}

// 获取文档类型列表
export function getDocumentTypes() {
  return request({
    url: '/ai-office/document-types',
    method: 'get'
  })
}

// 获取分析类型列表
export function getAnalysisTypes() {
  return request({
    url: '/ai-office/analysis-types',
    method: 'get'
  })
}

// 生成智能文档
export function generateDocument(data) {
  return request({
    url: '/ai-office/generate-document',
    method: 'post',
    data: data
  })
}

// 生成数据分析报告
export function generateDataAnalysis(data) {
  return request({
    url: '/ai-office/generate-analysis',
    method: 'post',
    data: data
  })
}

// 智能问答
export function intelligentQA(data) {
  return request({
    url: '/ai-office/intelligent-qa',
    method: 'post',
    data: data
  })
}

// 生成邮件
export function generateEmail(data) {
  return request({
    url: '/ai-office/generate-email',
    method: 'post',
    data: data
  })
}

// 生成会议纪要
export function generateMeetingMinutes(data) {
  return request({
    url: '/ai-office/generate-meeting-minutes',
    method: 'post',
    data: data
  })
}

// 生成工作计划
export function generateWorkPlan(data) {
  return request({
    url: '/ai-office/generate-work-plan',
    method: 'post',
    data: data
  })
}

// 获取用户对话历史
export function getConversationHistory(userId, limit = 20) {
  return request({
    url: `/ai-office/conversation-history/${userId}`,
    method: 'get',
    params: {
      limit: limit
    }
  })
}

// 获取文档模板列表
export function getDocumentTemplates(params) {
  return request({
    url: '/ai-office/templates',
    method: 'get',
    params: params
  })
}

// 保存自定义模板
export function saveCustomTemplate(data) {
  return request({
    url: '/ai-office/save-template',
    method: 'post',
    data: data
  })
}

// 从模板生成文档
export function generateDocumentFromTemplate(data) {
  return request({
    url: '/ai-office/generate-from-template',
    method: 'post',
    data: data
  })
}

// AI办公统计数据
export function getAIOfficeStats(userId) {
  return request({
    url: `/ai-office/stats/${userId}`,
    method: 'get'
  })
}

// 获取AI配置信息
export function getAIConfig() {
  return request({
    url: '/ai-office/config',
    method: 'get'
  })
}

// 更新AI配置（管理员功能）
export function updateAIConfig(data) {
  return request({
    url: '/ai-office/config',
    method: 'put',
    data: data
  })
}

// 批量删除对话历史
export function deleteConversationHistory(historyIds) {
  return request({
    url: '/ai-office/conversation-history',
    method: 'delete',
    data: {
      historyIds: historyIds
    }
  })
}

// 导出对话历史
export function exportConversationHistory(userId, params) {
  return request({
    url: `/ai-office/conversation-history/${userId}/export`,
    method: 'get',
    params: params,
    responseType: 'blob'
  })
}

// 获取AI使用统计报告
export function getUsageReport(params) {
  return request({
    url: '/ai-office/usage-report',
    method: 'get',
    params: params
  })
}

// 检查AI服务状态
export function checkAIServiceStatus() {
  return request({
    url: '/ai-office/service-status',
    method: 'get'
  })
}

// 重置AI会话
export function resetAISession(userId) {
  return request({
    url: `/ai-office/reset-session/${userId}`,
    method: 'post'
  })
}

// 获取AI模型列表
export function getAIModels() {
  return request({
    url: '/ai-office/models',
    method: 'get'
  })
}

// 切换AI模型
export function switchAIModel(modelName) {
  return request({
    url: '/ai-office/switch-model',
    method: 'post',
    data: {
      modelName: modelName
    }
  })
}

// 获取AI提示词模板
export function getPromptTemplates(category) {
  return request({
    url: '/ai-office/prompt-templates',
    method: 'get',
    params: {
      category: category
    }
  })
}

// 保存AI提示词模板
export function savePromptTemplate(data) {
  return request({
    url: '/ai-office/prompt-templates',
    method: 'post',
    data: data
  })
}

// AI内容审核
export function moderateContent(content) {
  return request({
    url: '/ai-office/moderate',
    method: 'post',
    data: {
      content: content
    }
  })
}

// 获取AI使用配额
export function getUsageQuota(userId) {
  return request({
    url: `/ai-office/quota/${userId}`,
    method: 'get'
  })
}

// 文本翻译
export function translateText(data) {
  return request({
    url: '/ai-office/translate',
    method: 'post',
    data: data
  })
}

// 文本摘要
export function summarizeText(data) {
  return request({
    url: '/ai-office/summarize',
    method: 'post',
    data: data
  })
}

// 关键词提取
export function extractKeywords(data) {
  return request({
    url: '/ai-office/extract-keywords',
    method: 'post',
    data: data
  })
}

// 情感分析
export function analyzeSentiment(data) {
  return request({
    url: '/ai-office/sentiment-analysis',
    method: 'post',
    data: data
  })
}