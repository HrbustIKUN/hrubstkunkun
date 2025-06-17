<template>
  <div class="ai-office-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span class="card-title">
          <i class="el-icon-cpu"></i>
          AI智能办公助手
        </span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="showHistory = !showHistory">
          {{ showHistory ? '隐藏历史' : '查看历史' }}
        </el-button>
      </div>

      <el-row :gutter="20">
        <!-- AI功能选择区域 -->
        <el-col :span="showHistory ? 16 : 24">
          <div class="function-grid">
            <el-card 
              v-for="func in aiFunctions" 
              :key="func.id" 
              class="function-card"
              :class="{ active: selectedFunction === func.id }"
              @click.native="selectFunction(func)"
            >
              <div class="function-icon">
                <i :class="func.icon"></i>
              </div>
              <div class="function-info">
                <h4>{{ func.name }}</h4>
                <p>{{ func.description }}</p>
              </div>
            </el-card>
          </div>
          
          <!-- 快速跳转按钮 -->
          <div class="quick-actions" style="margin-top: 20px;">
            <el-button-group>
              <el-button type="primary" @click="goToDocumentGenerator">
                <i class="el-icon-document"></i>
                文档生成器
              </el-button>
              <el-button type="success" @click="goToEmailGenerator">
                <i class="el-icon-message"></i>
                邮件生成器
              </el-button>
              <el-button type="warning" @click="goToMeetingMinutes">
                <i class="el-icon-notebook-1"></i>
                会议纪要
              </el-button>
            </el-button-group>
          </div>

          <!-- 功能操作区域 -->
          <div class="function-operation" v-if="selectedFunction">
            <!-- 智能文档生成 -->
            <div v-if="selectedFunction === 'document'" class="operation-panel">
              <h3>智能文档生成</h3>
              <el-form :model="documentForm" label-width="100px">
                <el-form-item label="文档类型">
                  <el-select v-model="documentForm.documentType" placeholder="请选择文档类型">
                    <el-option 
                      v-for="type in documentTypes" 
                      :key="type" 
                      :label="type" 
                      :value="type">
                    </el-option>
                  </el-select>
                </el-form-item>
                <el-form-item label="部门">
                  <el-input v-model="documentForm.department" placeholder="请输入部门名称"></el-input>
                </el-form-item>
                <el-form-item label="内容要点">
                  <el-input 
                    type="textarea" 
                    v-model="documentForm.content" 
                    :rows="4" 
                    placeholder="请输入文档的主要内容要点">
                  </el-input>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="generateDocument" :loading="loading">
                    生成文档
                  </el-button>
                  <el-button @click="resetForm">重置</el-button>
                </el-form-item>
              </el-form>
            </div>

            <!-- 智能问答 -->
            <div v-if="selectedFunction === 'qa'" class="operation-panel">
              <h3>智能问答助手</h3>
              <div class="chat-container">
                <div class="chat-messages" ref="chatMessages">
                  <div 
                    v-for="(msg, index) in chatMessages" 
                    :key="index" 
                    :class="['message', msg.type]">
                    <div class="message-content">
                      <div class="message-text">{{ msg.content }}</div>
                      <div class="message-time">{{ msg.time }}</div>
                    </div>
                  </div>
                </div>
                <div class="chat-input">
                  <el-input 
                    v-model="questionInput" 
                    placeholder="请输入您的问题..." 
                    @keyup.enter.native="askQuestion"
                    :disabled="loading">
                    <el-button 
                      slot="append" 
                      icon="el-icon-s-promotion" 
                      @click="askQuestion"
                      :loading="loading">
                    </el-button>
                  </el-input>
                </div>
              </div>
            </div>

            <!-- 数据分析 -->
            <div v-if="selectedFunction === 'analysis'" class="operation-panel">
              <h3>数据分析报告</h3>
              <el-form :model="analysisForm" label-width="100px">
                <el-form-item label="分析类型">
                  <el-select v-model="analysisForm.analysisType" placeholder="请选择分析类型">
                    <el-option 
                      v-for="type in analysisTypes" 
                      :key="type" 
                      :label="type" 
                      :value="type">
                    </el-option>
                  </el-select>
                </el-form-item>
                <el-form-item label="数据描述">
                  <el-input 
                    type="textarea" 
                    v-model="analysisForm.dataDescription" 
                    :rows="4" 
                    placeholder="请描述需要分析的数据内容">
                  </el-input>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="generateAnalysis" :loading="loading">
                    生成分析报告
                  </el-button>
                </el-form-item>
              </el-form>
            </div>
          </div>

          <!-- 结果显示区域 -->
          <div class="result-panel" v-if="aiResult">
            <el-card>
              <div slot="header" class="clearfix">
                <span>AI生成结果</span>
                <el-button style="float: right; padding: 3px 0" type="text" @click="copyResult">
                  复制内容
                </el-button>
              </div>
              <div class="result-content">
                <pre>{{ aiResult }}</pre>
              </div>
            </el-card>
          </div>
        </el-col>

        <!-- 历史记录区域 -->
        <el-col :span="8" v-if="showHistory">
          <el-card class="history-card">
            <div slot="header" class="clearfix">
              <span>对话历史</span>
              <el-button style="float: right; padding: 3px 0" type="text" @click="loadHistory">
                刷新
              </el-button>
            </div>
            <div class="history-list">
              <div 
                v-for="(item, index) in conversationHistory" 
                :key="index" 
                class="history-item"
                @click="viewHistoryDetail(item)">
                <div class="history-title">{{ item.functionType | functionTypeFilter }}</div>
                <div class="history-question">{{ item.question | truncate(50) }}</div>
                <div class="history-time">{{ item.createdTime | timeFormat }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import { 
  generateDocument, 
  generateDataAnalysis, 
  intelligentQA,
  getAIFunctions,
  getDocumentTypes,
  getAnalysisTypes,
  getConversationHistory
} from '@/api/ai-office'
import { getUserInfo } from '@/utils/auth'

export default {
  name: 'AIOfficeIndex',
  data() {
    return {
      loading: false,
      showHistory: false,
      selectedFunction: '',
      aiResult: '',
      aiFunctions: [],
      documentTypes: [],
      analysisTypes: [],
      conversationHistory: [],
      
      // 文档生成表单
      documentForm: {
        documentType: '',
        content: '',
        department: ''
      },
      
      // 分析表单
      analysisForm: {
        analysisType: '',
        dataDescription: ''
      },
      
      // 问答相关
      questionInput: '',
      chatMessages: []
    }
  },
  
  created() {
    this.initData()
  },
  
  methods: {
    async initData() {
      try {
        // 加载AI功能列表
        const functionsRes = await getAIFunctions()
        this.aiFunctions = functionsRes.data.functions.map(func => ({
          ...func,
          icon: this.getFunctionIcon(func.id)
        }))
        
        // 加载文档类型
        const docTypesRes = await getDocumentTypes()
        this.documentTypes = docTypesRes.data.types
        
        // 加载分析类型
        const analysisTypesRes = await getAnalysisTypes()
        this.analysisTypes = analysisTypesRes.data.types
        
        // 加载对话历史
        this.loadHistory()
      } catch (error) {
        this.$message.error('初始化数据失败：' + error.message)
      }
    },
    
    getFunctionIcon(functionId) {
      const iconMap = {
        document: 'el-icon-document',
        analysis: 'el-icon-data-analysis',
        qa: 'el-icon-chat-dot-round',
        email: 'el-icon-message',
        meeting: 'el-icon-notebook-1',
        plan: 'el-icon-date'
      }
      return iconMap[functionId] || 'el-icon-cpu'
    },
    
    selectFunction(func) {
      this.selectedFunction = func.id
      this.aiResult = ''
    },
    
    async generateDocument() {
      if (!this.documentForm.documentType || !this.documentForm.content) {
        this.$message.warning('请填写完整信息')
        return
      }
      
      this.loading = true
      try {
        const userInfo = getUserInfo()
        const response = await generateDocument({
          ...this.documentForm,
          userId: userInfo.id
        })
        this.aiResult = response.data.document
        this.$message.success('文档生成成功')
      } catch (error) {
        this.$message.error('文档生成失败：' + error.message)
      } finally {
        this.loading = false
      }
    },
    
    async generateAnalysis() {
      if (!this.analysisForm.analysisType || !this.analysisForm.dataDescription) {
        this.$message.warning('请填写完整信息')
        return
      }
      
      this.loading = true
      try {
        const userInfo = getUserInfo()
        const response = await generateDataAnalysis({
          ...this.analysisForm,
          userId: userInfo.id
        })
        this.aiResult = response.data.analysis
        this.$message.success('分析报告生成成功')
      } catch (error) {
        this.$message.error('分析报告生成失败：' + error.message)
      } finally {
        this.loading = false
      }
    },
    
    async askQuestion() {
      if (!this.questionInput.trim()) {
        return
      }
      
      // 添加用户消息
      this.chatMessages.push({
        type: 'user',
        content: this.questionInput,
        time: this.formatTime(new Date())
      })
      
      const question = this.questionInput
      this.questionInput = ''
      this.loading = true
      
      try {
        const userInfo = getUserInfo()
        const response = await intelligentQA({
          question: question,
          context: '',
          userId: userInfo.id
        })
        
        // 添加AI回复
        this.chatMessages.push({
          type: 'ai',
          content: response.data.answer,
          time: this.formatTime(new Date())
        })
        
        this.$nextTick(() => {
          this.scrollToBottom()
        })
      } catch (error) {
        this.$message.error('问答失败：' + error.message)
      } finally {
        this.loading = false
      }
    },
    
    async loadHistory() {
      try {
        const userInfo = getUserInfo()
        const response = await getConversationHistory(userInfo.id, 20)
        this.conversationHistory = response.data.history
      } catch (error) {
        console.error('加载历史记录失败：', error)
      }
    },
    
    viewHistoryDetail(item) {
      this.aiResult = item.answer
    },
    
    copyResult() {
      if (navigator.clipboard) {
        navigator.clipboard.writeText(this.aiResult)
        this.$message.success('内容已复制到剪贴板')
      } else {
        // 兼容旧浏览器
        const textArea = document.createElement('textarea')
        textArea.value = this.aiResult
        document.body.appendChild(textArea)
        textArea.select()
        document.execCommand('copy')
        document.body.removeChild(textArea)
        this.$message.success('内容已复制到剪贴板')
      }
    },
    
    resetForm() {
      this.documentForm = {
        documentType: '',
        content: '',
        department: ''
      }
      this.analysisForm = {
        analysisType: '',
        dataDescription: ''
      }
      this.aiResult = ''
    },
    
    scrollToBottom() {
      const container = this.$refs.chatMessages
      if (container) {
        container.scrollTop = container.scrollHeight
      }
    },
    
    formatTime(date) {
      return date.toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit'
      })
    },
    
    // 跳转到文档生成器
    goToDocumentGenerator() {
      this.$router.push('/ai-office/document')
    },
    
    // 跳转到邮件生成器
    goToEmailGenerator() {
      this.$router.push('/ai-office/email')
    },
    
    // 跳转到会议纪要
    goToMeetingMinutes() {
      this.$router.push('/ai-office/meeting')
    }
  },
  
  filters: {
    functionTypeFilter(type) {
      const typeMap = {
        document: '文档生成',
        analysis: '数据分析',
        qa: '智能问答',
        email: '邮件生成',
        meeting: '会议纪要',
        plan: '工作计划',
        template: '模板应用'
      }
      return typeMap[type] || type
    },
    
    truncate(text, length) {
      if (text && text.length > length) {
        return text.substring(0, length) + '...'
      }
      return text
    },
    
    timeFormat(time) {
      return new Date(time).toLocaleString('zh-CN')
    }
  }
}
</script>

<style scoped>
.ai-office-container {
  padding: 20px;
}

.card-title {
  font-size: 18px;
  font-weight: bold;
  color: #409EFF;
}

.function-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 16px;
  margin-bottom: 20px;
}

.function-card {
  cursor: pointer;
  transition: all 0.3s;
  border: 2px solid transparent;
}

.function-card:hover {
  border-color: #409EFF;
  transform: translateY(-2px);
}

.function-card.active {
  border-color: #409EFF;
  background-color: #f0f9ff;
}

.function-card .el-card__body {
  display: flex;
  align-items: center;
  padding: 16px;
}

.function-icon {
  font-size: 32px;
  color: #409EFF;
  margin-right: 16px;
}

.function-info h4 {
  margin: 0 0 8px 0;
  color: #303133;
}

.function-info p {
  margin: 0;
  color: #909399;
  font-size: 14px;
}

.operation-panel {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.operation-panel h3 {
  margin-top: 0;
  color: #303133;
}

.result-panel {
  margin-top: 20px;
}

.result-content {
  max-height: 400px;
  overflow-y: auto;
}

.result-content pre {
  white-space: pre-wrap;
  word-wrap: break-word;
  font-family: inherit;
  margin: 0;
  line-height: 1.6;
}

.chat-container {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  height: 400px;
  display: flex;
  flex-direction: column;
}

.chat-messages {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
  background: #fff;
}

.message {
  margin-bottom: 16px;
  display: flex;
}

.message.user {
  justify-content: flex-end;
}

.message.ai {
  justify-content: flex-start;
}

.message-content {
  max-width: 70%;
  padding: 12px 16px;
  border-radius: 12px;
  position: relative;
}

.message.user .message-content {
  background: #409EFF;
  color: white;
}

.message.ai .message-content {
  background: #f0f0f0;
  color: #303133;
}

.message-text {
  margin-bottom: 4px;
  line-height: 1.4;
}

.message-time {
  font-size: 12px;
  opacity: 0.7;
}

.chat-input {
  padding: 16px;
  border-top: 1px solid #dcdfe6;
  background: #fafafa;
}

.history-card {
  height: 600px;
}

.history-list {
  max-height: 500px;
  overflow-y: auto;
}

.history-item {
  padding: 12px;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background-color 0.3s;
}

.history-item:hover {
  background-color: #f8f9fa;
}

.history-title {
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 4px;
}

.history-question {
  color: #606266;
  font-size: 14px;
  margin-bottom: 4px;
}

.history-time {
  color: #909399;
  font-size: 12px;
}
</style>