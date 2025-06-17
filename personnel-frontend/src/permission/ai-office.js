// AI办公功能权限配置

// AI功能权限映射
export const AI_PERMISSIONS = {
  // 基础AI功能 - 所有角色都可以使用
  BASIC_AI: {
    roles: ['管理员', '人事经理', '职员'],
    functions: [
      'intelligent-qa',        // 智能问答
      'document-generation',   // 文档生成
      'email-generation',      // 邮件生成
      'text-translation',      // 文本翻译
      'text-summary'          // 文本摘要
    ]
  },
  
  // 高级AI功能 - 管理员和人事经理可以使用
  ADVANCED_AI: {
    roles: ['管理员', '人事经理'],
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
    roles: ['管理员'],
    functions: [
      'ai-configuration',      // AI配置
      'model-management',      // 模型管理
      'usage-statistics',      // 使用统计
      'user-quota-management', // 用户配额管理
      'system-monitoring'      // 系统监控
    ]
  }
}

// AI使用限制配置
export const AI_LIMITS = {
  '管理员': {
    dailyQuota: 1000,        // 每日配额
    monthlyQuota: 30000,     // 每月配额
    maxTokensPerRequest: 4000, // 单次请求最大token数
    concurrentRequests: 10,   // 并发请求数
    advancedFeatures: true    // 是否可使用高级功能
  },
  '人事经理': {
    dailyQuota: 500,
    monthlyQuota: 15000,
    maxTokensPerRequest: 3000,
    concurrentRequests: 5,
    advancedFeatures: true
  },
  '职员': {
    dailyQuota: 200,
    monthlyQuota: 6000,
    maxTokensPerRequest: 2000,
    concurrentRequests: 3,
    advancedFeatures: false
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
  return AI_LIMITS[userRole] || AI_LIMITS['职员']
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
  '管理员': [
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
  
  '人事经理': [
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
  
  '职员': [
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
  return AI_MENU_CONFIG[userRole] || AI_MENU_CONFIG['职员']
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