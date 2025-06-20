import request from '@/utils/request'

// 获取AI功能列表
export function getAIFunctions() {
  return request({
    url: '/staff/ai-office/functions',
    method: 'get'
  })
}

// 获取文档类型列表
export function getDocumentTypes() {
  return request({
    url: '/staff/ai-office/document-types',
    method: 'get'
  })
}

// 获取分析类型列表
export function getAnalysisTypes() {
  return request({
    url: '/staff/ai-office/analysis-types',
    method: 'get'
  })
}

// 生成智能文档
export function generateDocument(data) {
  return request({
    url: '/staff/ai-office/generate-document',
    method: 'post',
    data
  })
}

// 生成数据分析报告
export function generateDataAnalysis(data) {
  return request({
    url: '/staff/ai-office/generate-analysis',
    method: 'post',
    data
  })
}

// 智能问答
export function intelligentQA(data) {
  return request({
    url: '/staff/ai-office/intelligent-qa',
    method: 'post',
    data
  })
}

// 生成邮件
export function generateEmail(data) {
  return request({
    url: '/staff/ai-office/generate-email',
    method: 'post',
    data
  })
}

// 生成会议纪要
export function generateMeetingMinutes(data) {
  return request({
    url: '/staff/ai-office/generate-meeting-minutes',
    method: 'post',
    data
  })
}

// 生成工作计划
export function generateWorkPlan(data) {
  return request({
    url: '/staff/ai-office/generate-work-plan',
    method: 'post',
    data
  })
}

// 获取用户对话历史
export function getConversationHistory(userId, limit = 20) {
  return request({
    url: `/staff/ai-office/conversation-history/${userId}`,
    method: 'get',
    params: {
      limit: limit
    }
  })
}

// 获取文档模板列表
export function getDocumentTemplates(params) {
  return request({
    url: '/staff/ai-office/templates',
    method: 'get',
    params: params
  })
}

// 保存自定义模板
export function saveCustomTemplate(data) {
  return request({
    url: '/staff/ai-office/save-template',
    method: 'post',
    data: data
  })
}

// 从模板生成文档
export function generateDocumentFromTemplate(data) {
  return request({
    url: '/staff/ai-office/generate-from-template',
    method: 'post',
    data: data
  })
}

// AI办公统计数据
export function getAIOfficeStats(userId) {
  return request({
    url: `/staff/ai-office/stats/${userId}`,
    method: 'get'
  })
}

// 获取AI配置信息
export function getAIConfig() {
  return request({
    url: '/staff/ai-office/config',
    method: 'get'
  })
}

// 更新AI配置（管理员功能）
export function updateAIConfig(data) {
  return request({
    url: '/staff/ai-office/config',
    method: 'put',
    data: data
  })
}

// 批量删除对话历史
export function deleteConversationHistory(historyIds) {
  return request({
    url: '/staff/ai-office/conversation-history',
    method: 'delete',
    data: {
      historyIds: historyIds
    }
  })
}

// 导出对话历史
export function exportConversationHistory(userId, params) {
  return request({
    url: `/staff/ai-office/conversation-history/${userId}/export`,
    method: 'get',
    params: params,
    responseType: 'blob'
  })
}

// 获取AI使用统计报告// 获取使用报告
export function getUsageReport(params) {
  return request({
    url: '/staff/ai-office/usage-report',
    method: 'get',
    params
  })
}

// 获取服务状态
export function getServiceStatus() {
  return request({
    url: '/staff/ai-office/service-status',
    method: 'get'
  })
}

// 重置AI会话
export function resetAISession(userId) {
  return request({
    url: `/staff/ai-office/reset-session/${userId}`,
    method: 'post'
  })
}

// 获取可用模型列表
export function getAvailableModels() {
  return request({
    url: '/staff/ai-office/models',
    method: 'get'
  })
}

// 切换AI模型
export function switchAIModel(data) {
  return request({
    url: '/staff/ai-office/switch-model',
    method: 'post',
    data
  })
}

// 获取提示词模板
export function getPromptTemplates(type) {
  return request({
    url: '/staff/ai-office/prompt-templates',
    method: 'get',
    params: { type }
  })
}

// 保存提示词模板
export function savePromptTemplate(data) {
  return request({
    url: '/staff/ai-office/prompt-templates',
    method: 'post',
    data
  })
}

// 内容审核
export function moderateContent(data) {
  return request({
    url: '/staff/ai-office/moderate',
    method: 'post',
    data
  })
}

// 获取AI使用配额
export function getUsageQuota(userId) {
  return request({
    url: `/staff/ai-office/quota/${userId}`,
    method: 'get'
  })
}

// 文本翻译
export function translateText(data) {
  return request({
    url: '/staff/ai-office/translate',
    method: 'post',
    data
  })
}

// 文本摘要
export function summarizeText(data) {
  return request({
    url: '/staff/ai-office/summarize',
    method: 'post',
    data
  })
}

// 关键词提取
export function extractKeywords(data) {
  return request({
    url: '/staff/ai-office/extract-keywords',
    method: 'post',
    data
  })
}

// 情感分析
export function sentimentAnalysis(data) {
  return request({
    url: '/staff/ai-office/sentiment-analysis',
    method: 'post',
    data
  })
}

// 检查AI服务状态
export function checkAIServiceStatus() {
  return request({
    url: '/staff/ai-office/service-status',
    method: 'get'
  })
}