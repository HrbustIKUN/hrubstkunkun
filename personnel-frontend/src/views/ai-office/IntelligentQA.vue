<template>
  <div class="intelligent-qa-container">
    <el-row :gutter="20">
      <!-- 左侧：问答界面 -->
      <el-col :span="16">
        <el-card class="chat-card">
          <div slot="header" class="clearfix">
            <span>AI智能问答</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="clearChat">清空对话</el-button>
          </div>
          
          <!-- 聊天消息区域 -->
          <div class="chat-messages" ref="chatMessages">
            <div v-for="message in messages" :key="message.id" class="message-item">
              <div :class="['message', message.type]">
                <div class="message-avatar">
                  <el-avatar :size="32">
                    <i :class="message.type === 'user' ? 'el-icon-user' : 'el-icon-cpu'"></i>
                  </el-avatar>
                </div>
                <div class="message-content">
                  <div class="message-header">
                    <span class="message-sender">{{ message.type === 'user' ? '您' : 'AI助手' }}</span>
                    <span class="message-time">{{ message.timestamp }}</span>
                  </div>
                  <div class="message-text" v-html="message.content"></div>
                  <div v-if="message.type === 'ai' && message.sources" class="message-sources">
                    <el-tag v-for="source in message.sources" :key="source" size="mini">{{ source }}</el-tag>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- 加载状态 -->
            <div v-if="loading" class="message-item">
              <div class="message ai">
                <div class="message-avatar">
                  <el-avatar :size="32">
                    <i class="el-icon-cpu"></i>
                  </el-avatar>
                </div>
                <div class="message-content">
                  <div class="typing-indicator">
                    <span></span>
                    <span></span>
                    <span></span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- 输入区域 -->
          <div class="chat-input">
            <el-input
              v-model="currentMessage"
              type="textarea"
              :rows="3"
              placeholder="请输入您的问题..."
              @keydown.ctrl.enter="sendMessage"
            />
            <div class="input-actions">
              <div class="input-tips">
                <span>Ctrl + Enter 发送</span>
              </div>
              <el-button type="primary" @click="sendMessage" :loading="loading">发送</el-button>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <!-- 右侧：功能面板 -->
      <el-col :span="8">
        <!-- 快速问题 -->
        <el-card class="quick-questions-card">
          <div slot="header">
            <span>快速问题</span>
          </div>
          <div class="quick-questions">
            <el-tag
              v-for="question in quickQuestions"
              :key="question"
              class="quick-question"
              @click="askQuickQuestion(question)"
            >
              {{ question }}
            </el-tag>
          </div>
        </el-card>
        
        <!-- 知识库设置 -->
        <el-card class="knowledge-card">
          <div slot="header">
            <span>知识库设置</span>
          </div>
          <el-form label-width="80px">
            <el-form-item label="数据源">
              <el-checkbox-group v-model="selectedKnowledge">
                <el-checkbox label="employee">员工手册</el-checkbox>
                <el-checkbox label="policy">公司政策</el-checkbox>
                <el-checkbox label="process">工作流程</el-checkbox>
                <el-checkbox label="faq">常见问题</el-checkbox>
                <el-checkbox label="technical">技术文档</el-checkbox>
              </el-checkbox-group>
            </el-form-item>
            <el-form-item label="回答模式">
              <el-radio-group v-model="answerMode">
                <el-radio label="detailed">详细</el-radio>
                <el-radio label="concise">简洁</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-form>
        </el-card>
        
        <!-- 对话历史 -->
        <el-card class="history-card">
          <div slot="header">
            <span>最近对话</span>
          </div>
          <div class="conversation-history">
            <div
              v-for="conversation in conversationHistory"
              :key="conversation.id"
              class="history-item"
              @click="loadConversation(conversation)"
            >
              <div class="history-title">{{ conversation.title }}</div>
              <div class="history-time">{{ conversation.time }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'IntelligentQA',
  data() {
    return {
      loading: false,
      currentMessage: '',
      messages: [
        {
          id: 1,
          type: 'ai',
          content: '您好！我是AI智能助手，可以帮您解答关于公司政策、工作流程、技术问题等各种疑问。请问有什么可以帮助您的吗？',
          timestamp: new Date().toLocaleTimeString(),
          sources: ['系统提示']
        }
      ],
      quickQuestions: [
        '如何申请年假？',
        '公司的加班政策是什么？',
        '如何报销差旅费？',
        '新员工入职流程',
        '绩效考核标准',
        '薪资发放时间',
        '如何申请调岗？',
        '公司培训计划'
      ],
      selectedKnowledge: ['employee', 'policy', 'process', 'faq'],
      answerMode: 'detailed',
      conversationHistory: [
        {
          id: 1,
          title: '关于年假申请的问题',
          time: '2024-01-15 14:30'
        },
        {
          id: 2,
          title: '绩效考核相关咨询',
          time: '2024-01-14 09:15'
        },
        {
          id: 3,
          title: '报销流程询问',
          time: '2024-01-13 16:45'
        }
      ]
    }
  },
  mounted() {
    this.scrollToBottom()
  },
  methods: {
    sendMessage() {
      if (!this.currentMessage.trim()) {
        this.$message.warning('请输入问题内容')
        return
      }
      
      // 添加用户消息
      const userMessage = {
        id: Date.now(),
        type: 'user',
        content: this.currentMessage,
        timestamp: new Date().toLocaleTimeString()
      }
      this.messages.push(userMessage)
      
      const question = this.currentMessage
      this.currentMessage = ''
      this.loading = true
      
      this.$nextTick(() => {
        this.scrollToBottom()
      })
      
      // 模拟AI回复
      setTimeout(() => {
        const aiResponse = this.generateAIResponse(question)
        this.messages.push(aiResponse)
        this.loading = false
        
        this.$nextTick(() => {
          this.scrollToBottom()
        })
      }, 2000)
    },
    generateAIResponse(question) {
      // 简单的问题匹配逻辑
      let response = ''
      let sources = []
      
      if (question.includes('年假') || question.includes('假期')) {
        response = `
          <p>关于年假申请，根据公司政策：</p>
          <ul>
            <li>员工入职满一年后可享受年假</li>
            <li>年假天数根据工作年限确定：1-10年为5天，10-20年为10天，20年以上为15天</li>
            <li>年假需提前一周申请，通过OA系统提交申请单</li>
            <li>年假原则上应在当年使用完毕，特殊情况可延至次年3月底</li>
          </ul>
          <p>如需申请年假，请登录OA系统 → 人事管理 → 假期申请 → 选择年假类型填写申请。</p>
        `
        sources = ['员工手册', '人事政策']
      } else if (question.includes('加班')) {
        response = `
          <p>公司加班政策如下：</p>
          <ul>
            <li>加班需事先申请，经直属领导批准</li>
            <li>工作日加班：前2小时按1.5倍工资计算，超过2小时按2倍计算</li>
            <li>周末加班：按2倍工资计算</li>
            <li>法定节假日加班：按3倍工资计算</li>
            <li>加班时间每月不得超过36小时</li>
          </ul>
          <p>加班申请请通过OA系统提交，并在月底前完成加班时长确认。</p>
        `
        sources = ['劳动合同', '薪酬制度']
      } else if (question.includes('报销')) {
        response = `
          <p>差旅费报销流程：</p>
          <ol>
            <li>出差前填写《出差申请单》，经领导审批</li>
            <li>出差期间保留所有发票和凭证</li>
            <li>出差结束后7个工作日内提交报销申请</li>
            <li>填写《差旅费报销单》，附上相关票据</li>
            <li>经部门领导和财务审核后，15个工作日内到账</li>
          </ol>
          <p>报销标准：住宿费每天不超过300元，餐费每天不超过100元，交通费按实际发生额报销。</p>
        `
        sources = ['财务制度', '报销指南']
      } else {
        response = `
          <p>感谢您的提问。根据您的问题，我建议您：</p>
          <ul>
            <li>查阅相关的公司政策文档</li>
            <li>咨询您的直属领导或HR部门</li>
            <li>通过OA系统查找相关流程指引</li>
          </ul>
          <p>如果您需要更具体的帮助，请提供更详细的问题描述，我会尽力为您解答。</p>
        `
        sources = ['通用回复']
      }
      
      return {
        id: Date.now(),
        type: 'ai',
        content: response,
        timestamp: new Date().toLocaleTimeString(),
        sources: sources
      }
    },
    askQuickQuestion(question) {
      this.currentMessage = question
      this.sendMessage()
    },
    clearChat() {
      this.$confirm('确认清空当前对话?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.messages = [
          {
            id: 1,
            type: 'ai',
            content: '对话已清空。请问有什么可以帮助您的吗？',
            timestamp: new Date().toLocaleTimeString(),
            sources: ['系统提示']
          }
        ]
        this.$message.success('对话已清空')
      })
    },
    loadConversation(conversation) {
      this.$message.info(`加载对话: ${conversation.title}`)
    },
    scrollToBottom() {
      this.$nextTick(() => {
        const chatMessages = this.$refs.chatMessages
        if (chatMessages) {
          chatMessages.scrollTop = chatMessages.scrollHeight
        }
      })
    }
  }
}
</script>

<style scoped>
.intelligent-qa-container {
  padding: 20px;
}

.chat-card {
  height: 700px;
  display: flex;
  flex-direction: column;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: #f8f9fa;
}

.message-item {
  margin-bottom: 20px;
}

.message {
  display: flex;
  align-items: flex-start;
}

.message.user {
  flex-direction: row-reverse;
}

.message-avatar {
  margin: 0 10px;
}

.message-content {
  max-width: 70%;
  background: white;
  border-radius: 8px;
  padding: 12px 16px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.message.user .message-content {
  background: #409EFF;
  color: white;
}

.message-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  font-size: 12px;
}

.message-sender {
  font-weight: bold;
}

.message-time {
  color: #909399;
}

.message.user .message-time {
  color: rgba(255, 255, 255, 0.8);
}

.message-text {
  line-height: 1.6;
}

.message-text ul, .message-text ol {
  margin: 10px 0;
  padding-left: 20px;
}

.message-text li {
  margin: 5px 0;
}

.message-sources {
  margin-top: 10px;
}

.message-sources .el-tag {
  margin-right: 5px;
}

.typing-indicator {
  display: flex;
  align-items: center;
  gap: 4px;
}

.typing-indicator span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #409EFF;
  animation: typing 1.4s infinite;
}

.typing-indicator span:nth-child(2) {
  animation-delay: 0.2s;
}

.typing-indicator span:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes typing {
  0%, 60%, 100% {
    transform: translateY(0);
  }
  30% {
    transform: translateY(-10px);
  }
}

.chat-input {
  padding: 20px;
  border-top: 1px solid #e4e7ed;
}

.input-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 10px;
}

.input-tips {
  font-size: 12px;
  color: #909399;
}

.quick-questions-card, .knowledge-card, .history-card {
  margin-bottom: 20px;
}

.quick-questions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.quick-question {
  cursor: pointer;
  transition: all 0.3s;
}

.quick-question:hover {
  background: #409EFF;
  color: white;
}

.conversation-history {
  max-height: 200px;
  overflow-y: auto;
}

.history-item {
  padding: 10px;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background 0.3s;
}

.history-item:hover {
  background: #f5f7fa;
}

.history-title {
  font-size: 14px;
  color: #303133;
  margin-bottom: 4px;
}

.history-time {
  font-size: 12px;
  color: #909399;
}
</style>