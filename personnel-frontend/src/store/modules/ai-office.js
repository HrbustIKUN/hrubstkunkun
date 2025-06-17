import {
  getAIFunctions,
  getConversationHistory,
  getUsageQuota,
  checkAIServiceStatus,
  getAIConfig
} from '@/api/ai-office'
import { getUserAILimits, checkUsageLimit } from '@/permission/ai-office'

const state = {
  // AI服务状态
  serviceStatus: {
    available: false,
    models: [],
    currentModel: '',
    lastCheck: null
  },
  
  // AI功能列表
  aiFunctions: [],
  
  // 当前用户的AI配置
  userConfig: {
    role: '',
    limits: {},
    quota: {
      dailyUsed: 0,
      dailyLimit: 0,
      monthlyUsed: 0,
      monthlyLimit: 0
    }
  },
  
  // 对话历史
  conversationHistory: [],
  
  // 当前会话
  currentSession: {
    sessionId: '',
    messages: [],
    context: ''
  },
  
  // AI配置
  aiConfig: {
    enabled: true,
    defaultModel: 'gpt-3.5-turbo',
    temperature: 0.7,
    maxTokens: 2000
  },
  
  // 使用统计
  usageStats: {
    today: 0,
    thisWeek: 0,
    thisMonth: 0,
    total: 0
  },
  
  // 加载状态
  loading: {
    functions: false,
    history: false,
    generating: false,
    status: false
  },
  
  // 错误信息
  error: null
}

const mutations = {
  // 设置AI服务状态
  SET_SERVICE_STATUS(state, status) {
    state.serviceStatus = {
      ...state.serviceStatus,
      ...status,
      lastCheck: new Date()
    }
  },
  
  // 设置AI功能列表
  SET_AI_FUNCTIONS(state, functions) {
    state.aiFunctions = functions
  },
  
  // 设置用户配置
  SET_USER_CONFIG(state, config) {
    state.userConfig = {
      ...state.userConfig,
      ...config
    }
  },
  
  // 设置用户配额
  SET_USER_QUOTA(state, quota) {
    state.userConfig.quota = {
      ...state.userConfig.quota,
      ...quota
    }
  },
  
  // 设置对话历史
  SET_CONVERSATION_HISTORY(state, history) {
    state.conversationHistory = history
  },
  
  // 添加对话记录
  ADD_CONVERSATION(state, conversation) {
    state.conversationHistory.unshift(conversation)
    // 限制历史记录数量
    if (state.conversationHistory.length > 100) {
      state.conversationHistory = state.conversationHistory.slice(0, 100)
    }
  },
  
  // 设置当前会话
  SET_CURRENT_SESSION(state, session) {
    state.currentSession = {
      ...state.currentSession,
      ...session
    }
  },
  
  // 添加会话消息
  ADD_SESSION_MESSAGE(state, message) {
    state.currentSession.messages.push({
      ...message,
      timestamp: new Date(),
      id: Date.now() + Math.random()
    })
  },
  
  // 清空当前会话
  CLEAR_CURRENT_SESSION(state) {
    state.currentSession = {
      sessionId: '',
      messages: [],
      context: ''
    }
  },
  
  // 设置AI配置
  SET_AI_CONFIG(state, config) {
    state.aiConfig = {
      ...state.aiConfig,
      ...config
    }
  },
  
  // 设置使用统计
  SET_USAGE_STATS(state, stats) {
    state.usageStats = {
      ...state.usageStats,
      ...stats
    }
  },
  
  // 增加使用次数
  INCREMENT_USAGE(state, type = 'today') {
    if (state.usageStats[type] !== undefined) {
      state.usageStats[type]++
    }
    state.userConfig.quota.dailyUsed++
  },
  
  // 设置加载状态
  SET_LOADING(state, { type, loading }) {
    state.loading[type] = loading
  },
  
  // 设置错误信息
  SET_ERROR(state, error) {
    state.error = error
  },
  
  // 清除错误信息
  CLEAR_ERROR(state) {
    state.error = null
  }
}

const actions = {
  // 初始化AI办公模块
  async initAIOffice({ commit, dispatch, rootGetters }) {
    try {
      commit('SET_LOADING', { type: 'functions', loading: true })
      
      const userRole = rootGetters.role
      const userLimits = getUserAILimits(userRole)
      
      commit('SET_USER_CONFIG', {
        role: userRole,
        limits: userLimits
      })
      
      // 并行加载数据
      await Promise.all([
        dispatch('loadAIFunctions'),
        dispatch('checkServiceStatus'),
        dispatch('loadUserQuota'),
        dispatch('loadAIConfig')
      ])
      
    } catch (error) {
      commit('SET_ERROR', error.message)
      console.error('AI办公模块初始化失败:', error)
    } finally {
      commit('SET_LOADING', { type: 'functions', loading: false })
    }
  },
  
  // 加载AI功能列表
  async loadAIFunctions({ commit }) {
    try {
      const response = await getAIFunctions()
      commit('SET_AI_FUNCTIONS', response.data.functions)
    } catch (error) {
      console.error('加载AI功能列表失败:', error)
      throw error
    }
  },
  
  // 检查AI服务状态
  async checkServiceStatus({ commit }) {
    try {
      commit('SET_LOADING', { type: 'status', loading: true })
      const response = await checkAIServiceStatus()
      commit('SET_SERVICE_STATUS', response.data)
    } catch (error) {
      commit('SET_SERVICE_STATUS', {
        available: false,
        error: error.message
      })
      console.error('检查AI服务状态失败:', error)
    } finally {
      commit('SET_LOADING', { type: 'status', loading: false })
    }
  },
  
  // 加载用户配额
  async loadUserQuota({ commit, rootGetters }) {
    try {
      const userId = rootGetters.userId
      const response = await getUsageQuota(userId)
      commit('SET_USER_QUOTA', response.data)
    } catch (error) {
      console.error('加载用户配额失败:', error)
    }
  },
  
  // 加载AI配置
  async loadAIConfig({ commit }) {
    try {
      const response = await getAIConfig()
      commit('SET_AI_CONFIG', response.data)
    } catch (error) {
      console.error('加载AI配置失败:', error)
    }
  },
  
  // 加载对话历史
  async loadConversationHistory({ commit, rootGetters }, limit = 20) {
    try {
      commit('SET_LOADING', { type: 'history', loading: true })
      const userId = rootGetters.userId
      const response = await getConversationHistory(userId, limit)
      commit('SET_CONVERSATION_HISTORY', response.data.history)
    } catch (error) {
      console.error('加载对话历史失败:', error)
      commit('SET_ERROR', '加载对话历史失败')
    } finally {
      commit('SET_LOADING', { type: 'history', loading: false })
    }
  },
  
  // 开始新会话
  startNewSession({ commit }) {
    const sessionId = 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9)
    commit('SET_CURRENT_SESSION', {
      sessionId,
      messages: [],
      context: ''
    })
    return sessionId
  },
  
  // 添加用户消息
  addUserMessage({ commit }, message) {
    commit('ADD_SESSION_MESSAGE', {
      type: 'user',
      content: message,
      role: 'user'
    })
  },
  
  // 添加AI回复
  addAIMessage({ commit }, message) {
    commit('ADD_SESSION_MESSAGE', {
      type: 'assistant',
      content: message,
      role: 'assistant'
    })
  },
  
  // 保存对话到历史
  saveConversationToHistory({ commit, state }, { question, answer, functionType }) {
    const conversation = {
      sessionId: state.currentSession.sessionId,
      question,
      answer,
      functionType,
      createdTime: new Date().toISOString()
    }
    commit('ADD_CONVERSATION', conversation)
  },
  
  // 检查使用限制
  checkUsageLimit({ state, rootGetters }, requestTokens = 0) {
    const userRole = rootGetters.role
    const currentUsage = {
      dailyCount: state.userConfig.quota.dailyUsed,
      requestTokens
    }
    return checkUsageLimit(userRole, currentUsage)
  },
  
  // 记录AI使用
  recordAIUsage({ commit, dispatch }, { functionType, tokens = 0 }) {
    commit('INCREMENT_USAGE', 'today')
    commit('INCREMENT_USAGE', 'total')
    
    // 可以在这里添加使用记录到后端的逻辑
    // dispatch('saveUsageRecord', { functionType, tokens })
  },
  
  // 重置错误状态
  clearError({ commit }) {
    commit('CLEAR_ERROR')
  },
  
  // 刷新AI状态
  async refreshAIStatus({ dispatch }) {
    await Promise.all([
      dispatch('checkServiceStatus'),
      dispatch('loadUserQuota')
    ])
  }
}

const getters = {
  // 是否可以使用AI服务
  canUseAI: (state) => {
    return state.serviceStatus.available && state.aiConfig.enabled
  },
  
  // 获取可用的AI功能
  availableFunctions: (state) => {
    return state.aiFunctions.filter(func => func.enabled)
  },
  
  // 获取当前会话消息数量
  currentSessionMessageCount: (state) => {
    return state.currentSession.messages.length
  },
  
  // 获取今日剩余配额
  remainingQuota: (state) => {
    const { dailyUsed, dailyLimit } = state.userConfig.quota
    return dailyLimit === -1 ? -1 : Math.max(0, dailyLimit - dailyUsed)
  },
  
  // 是否接近配额限制
  nearQuotaLimit: (state, getters) => {
    const remaining = getters.remainingQuota
    const limit = state.userConfig.quota.dailyLimit
    return remaining !== -1 && remaining < limit * 0.1 // 剩余不足10%
  },
  
  // 获取最近的对话历史
  recentHistory: (state) => {
    return state.conversationHistory.slice(0, 10)
  },
  
  // 是否正在加载
  isLoading: (state) => {
    return Object.values(state.loading).some(loading => loading)
  },
  
  // 获取AI服务状态文本
  serviceStatusText: (state) => {
    if (!state.serviceStatus.available) {
      return 'AI服务不可用'
    }
    return `AI服务正常 (${state.serviceStatus.currentModel})`
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}