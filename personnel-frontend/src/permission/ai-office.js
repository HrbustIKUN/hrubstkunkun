// AI办公功能权限配置

// AI功能权限映射
export const AI_PERMISSIONS = {
  // 基础AI功能 - 所有角色都可以使用
  BASIC_AI: {
    roles: ['admin', 'hr', 'employee'],
    functions: [
      'intelligent-qa',        // 智能问答
      'document-generation',   // 文档生成
      'email-generation',      // 邮件生成
      'text-translation',      // 文本翻译
      'text-summary'          // 文本摘要
    ]
  },
  
  // 高级AI功能 - 管理员和HR可以使用
  ADVANCED_AI: {
    roles: ['admin', 'hr'],
    functions: [
      'data-analysis',         // 数据分析
      'meeting-minutes',       // 会议纪要
      'work-plan',            // 工作计划
      'batch-processing',      // 批量处理
      'advanced-templates'     // 高级模板
    ]
  },
  
  // 管理功能 - 仅管理员可以使用
  ADMIN_AI: {
    roles: ['admin'],
    functions: [
      'ai-configuration',      // AI配置
      'model-management',      // 模型管理
      'usage-statistics',      // 使用统计
      'user-quota-management', // 用户配额管理
      'system-monitoring'      // 系统监控
    ]
  }
}

// AI功能使用限制
export const AI_LIMITS = {
  // 普通员工限制
  employee: {
    dailyQuota: 50,           // 每日使用次数
    maxTokensPerRequest: 2000, // 单次请求最大token数
    allowedModels: ['gpt-3.5-turbo'], // 允许使用的模型
    maxHistoryDays: 7,        // 历史记录保留天数
    maxTemplates: 5           // 最大自定义模板数
  },
  
  // HR限制
  hr: {
    dailyQuota: 200,
    maxTokensPerRequest: 4000,
    allowedModels: ['gpt-3.5-turbo', 'gpt-4'],
    maxHistoryDays: 30,
    maxTemplates: 20
  },
  
  // 管理员限制
  admin: {
    dailyQuota: -1,           // 无限制
    maxTokensPerRequest: 8000,
    allowedModels: ['gpt-3.5-turbo', 'gpt-4', 'claude-3'],
    maxHistoryDays: 365,
    maxTemplates: -1          // 无限制
  }
}

// 检查用户是否有权限使用指定AI功能
export function hasAIPermission(userRole, functionName) {
  // 检查基础功能权限
  if (AI_PERMISSIONS.BASIC_AI.functions.includes(functionName)) {
    return AI_PERMISSIONS.BASIC_AI.roles.includes(userRole)
  }
  
  // 检查高级功能权限
  if (AI_PERMISSIONS.ADVANCED_AI.functions.includes(functionName)) {
    return AI_PERMISSIONS.ADVANCED_AI.roles.includes(userRole)
  }
  
  // 检查管理功能权限
  if (AI_PERMISSIONS.ADMIN_AI.functions.includes(functionName)) {
    return AI_PERMISSIONS.ADMIN_AI.roles.includes(userRole)
  }
  
  return false
}

// 获取用户可用的AI功能列表
export function getUserAIFunctions(userRole) {
  const availableFunctions = []
  
  // 添加基础功能
  if (AI_PERMISSIONS.BASIC_AI.roles.includes(userRole)) {
    availableFunctions.push(...AI_PERMISSIONS.BASIC_AI.functions)
  }
  
  // 添加高级功能
  if (AI_PERMISSIONS.ADVANCED_AI.roles.includes(userRole)) {
    availableFunctions.push(...AI_PERMISSIONS.ADVANCED_AI.functions)
  }
  
  // 添加管理功能
  if (AI_PERMISSIONS.ADMIN_AI.roles.includes(userRole)) {
    availableFunctions.push(...AI_PERMISSIONS.ADMIN_AI.functions)
  }
  
  return availableFunctions
}

// 获取用户AI使用限制
export function getUserAILimits(userRole) {
  return AI_LIMITS[userRole] || AI_LIMITS.employee
}

// 检查用户是否超出使用限制
export function checkUsageLimit(userRole, currentUsage) {
  const limits = getUserAILimits(userRole)
  
  // 检查每日配额
  if (limits.dailyQuota !== -1 && currentUsage.dailyCount >= limits.dailyQuota) {
    return {
      allowed: false,
      reason: 'daily_quota_exceeded',
      message: `已超出每日使用限制（${limits.dailyQuota}次）`
    }
  }
  
  // 检查token限制
  if (currentUsage.requestTokens > limits.maxTokensPerRequest) {
    return {
      allowed: false,
      reason: 'token_limit_exceeded',
      message: `请求内容过长，超出单次限制（${limits.maxTokensPerRequest} tokens）`
    }
  }
  
  return {
    allowed: true,
    remaining: limits.dailyQuota === -1 ? -1 : limits.dailyQuota - currentUsage.dailyCount
  }
}

// AI功能菜单配置
export const AI_MENU_CONFIG = {
  admin: [
    {
      title: 'AI办公助手',
      icon: 'el-icon-cpu',
      children: [
        { title: '智能问答', path: '/ai-office/qa', icon: 'el-icon-chat-dot-round' },
        { title: '文档生成', path: '/ai-office/document', icon: 'el-icon-document' },
        { title: '数据分析', path: '/ai-office/analysis', icon: 'el-icon-data-analysis' },
        { title: '邮件生成', path: '/ai-office/email', icon: 'el-icon-message' },
        { title: '会议纪要', path: '/ai-office/meeting', icon: 'el-icon-notebook-1' },
        { title: '工作计划', path: '/ai-office/plan', icon: 'el-icon-date' },
        { title: '模板管理', path: '/ai-office/templates', icon: 'el-icon-folder-opened' },
        { title: '对话历史', path: '/ai-office/history', icon: 'el-icon-time' },
        { title: '使用统计', path: '/ai-office/statistics', icon: 'el-icon-data-line' },
        { title: 'AI设置', path: '/ai-office/settings', icon: 'el-icon-setting' }
      ]
    }
  ],
  
  hr: [
    {
      title: 'AI办公助手',
      icon: 'el-icon-cpu',
      children: [
        { title: '智能问答', path: '/ai-office/qa', icon: 'el-icon-chat-dot-round' },
        { title: '文档生成', path: '/ai-office/document', icon: 'el-icon-document' },
        { title: '数据分析', path: '/ai-office/analysis', icon: 'el-icon-data-analysis' },
        { title: '邮件生成', path: '/ai-office/email', icon: 'el-icon-message' },
        { title: '会议纪要', path: '/ai-office/meeting', icon: 'el-icon-notebook-1' },
        { title: '工作计划', path: '/ai-office/plan', icon: 'el-icon-date' },
        { title: '模板管理', path: '/ai-office/templates', icon: 'el-icon-folder-opened' },
        { title: '对话历史', path: '/ai-office/history', icon: 'el-icon-time' },
        { title: '使用统计', path: '/ai-office/statistics', icon: 'el-icon-data-line' }
      ]
    }
  ],
  
  employee: [
    {
      title: 'AI办公助手',
      icon: 'el-icon-cpu',
      children: [
        { title: '智能问答', path: '/ai-office/qa', icon: 'el-icon-chat-dot-round' },
        { title: '文档生成', path: '/ai-office/document', icon: 'el-icon-document' },
        { title: '邮件生成', path: '/ai-office/email', icon: 'el-icon-message' },
        { title: '模板管理', path: '/ai-office/templates', icon: 'el-icon-folder-opened' },
        { title: '对话历史', path: '/ai-office/history', icon: 'el-icon-time' }
      ]
    }
  ]
}

// 获取用户AI菜单配置
export function getUserAIMenu(userRole) {
  return AI_MENU_CONFIG[userRole] || AI_MENU_CONFIG.employee
}

// AI功能状态检查
export function checkAIFunctionStatus(functionName) {
  // 这里可以添加AI服务状态检查逻辑
  // 例如检查模型是否可用、服务是否正常等
  return {
    available: true,
    status: 'active',
    message: '功能正常'
  }
}

// 导出权限检查中间件
export function createAIPermissionMiddleware() {
  return (to, from, next) => {
    const userRole = store.getters.role
    const requiredPermission = to.meta.aiPermission
    
    if (requiredPermission && !hasAIPermission(userRole, requiredPermission)) {
      next({ path: '/401' })
    } else {
      next()
    }
  }
}