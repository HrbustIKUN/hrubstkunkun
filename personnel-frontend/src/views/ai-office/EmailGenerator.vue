<template>
  <div class="email-generator-container">
    <el-row :gutter="20">
      <!-- 左侧：邮件生成表单 -->
      <el-col :span="12">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>智能邮件生成</span>
          </div>
          
          <el-form ref="emailForm" :model="emailForm" label-width="100px">
            <el-form-item label="邮件类型">
              <el-select v-model="emailForm.type" placeholder="请选择邮件类型" @change="handleTypeChange">
                <el-option label="工作汇报" value="work-report" />
                <el-option label="会议邀请" value="meeting-invitation" />
                <el-option label="项目更新" value="project-update" />
                <el-option label="通知公告" value="announcement" />
                <el-option label="感谢信" value="thank-you" />
                <el-option label="道歉信" value="apology" />
                <el-option label="请假申请" value="leave-request" />
                <el-option label="商务合作" value="business-cooperation" />
                <el-option label="自定义" value="custom" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="收件人">
              <el-input v-model="emailForm.recipient" placeholder="请输入收件人（如：张经理、团队成员等）" />
            </el-form-item>
            
            <el-form-item label="邮件主题">
              <el-input v-model="emailForm.subject" placeholder="请输入邮件主题" />
            </el-form-item>
            
            <el-form-item label="语气风格">
              <el-radio-group v-model="emailForm.tone">
                <el-radio label="formal">正式</el-radio>
                <el-radio label="friendly">友好</el-radio>
                <el-radio label="professional">专业</el-radio>
                <el-radio label="casual">随和</el-radio>
              </el-radio-group>
            </el-form-item>
            
            <el-form-item label="紧急程度">
              <el-select v-model="emailForm.urgency" placeholder="请选择紧急程度">
                <el-option label="普通" value="normal" />
                <el-option label="重要" value="important" />
                <el-option label="紧急" value="urgent" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="主要内容">
              <el-input
                v-model="emailForm.content"
                type="textarea"
                :rows="5"
                placeholder="请描述邮件的主要内容和要点"
              />
            </el-form-item>
            
            <el-form-item label="特殊要求">
              <el-input
                v-model="emailForm.requirements"
                type="textarea"
                :rows="3"
                placeholder="可选：任何特殊要求或注意事项"
              />
            </el-form-item>
            
            <el-form-item label="包含附件">
              <el-checkbox v-model="emailForm.hasAttachment">邮件包含附件</el-checkbox>
            </el-form-item>
            
            <el-form-item v-if="emailForm.hasAttachment" label="附件说明">
              <el-input v-model="emailForm.attachmentDesc" placeholder="请描述附件内容" />
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="generateEmail" :loading="loading">生成邮件</el-button>
              <el-button @click="resetForm">重置</el-button>
              <el-button @click="useTemplate">使用模板</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
      
      <!-- 右侧：生成结果 -->
      <el-col :span="12">
        <el-card class="result-card">
          <div slot="header" class="clearfix">
            <span>生成结果</span>
            <div style="float: right;">
              <el-button size="mini" @click="copyEmail" :disabled="!generatedEmail">复制</el-button>
              <el-button size="mini" @click="sendEmail" :disabled="!generatedEmail">发送</el-button>
              <el-button size="mini" @click="saveTemplate" :disabled="!generatedEmail">保存为模板</el-button>
            </div>
          </div>
          
          <div v-if="loading" class="loading-container">
            <el-icon class="is-loading"><i class="el-icon-loading"></i></el-icon>
            <p>AI正在生成邮件，请稍候...</p>
          </div>
          
          <div v-else-if="generatedEmail" class="email-content">
            <div class="email-header">
              <div class="email-field">
                <strong>收件人:</strong> {{ generatedEmail.recipient }}
              </div>
              <div class="email-field">
                <strong>主题:</strong> {{ generatedEmail.subject }}
              </div>
              <div class="email-field" v-if="emailForm.urgency !== 'normal'">
                <strong>优先级:</strong> 
                <el-tag :type="emailForm.urgency === 'urgent' ? 'danger' : 'warning'">
                  {{ emailForm.urgency === 'urgent' ? '紧急' : '重要' }}
                </el-tag>
              </div>
            </div>
            
            <div class="email-body">
              <div v-html="generatedEmail.body"></div>
            </div>
            
            <div v-if="emailForm.hasAttachment" class="email-attachment">
              <el-icon><i class="el-icon-paperclip"></i></el-icon>
              <span>附件: {{ emailForm.attachmentDesc }}</span>
            </div>
          </div>
          
          <div v-else class="empty-state">
            <el-empty description="请填写左侧表单生成邮件"></el-empty>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 邮件历史 -->
    <el-card class="history-card">
      <div slot="header" class="clearfix">
        <span>邮件历史</span>
      </div>
      
      <el-table :data="emailHistory" style="width: 100%">
        <el-table-column prop="subject" label="邮件主题" />
        <el-table-column prop="recipient" label="收件人" />
        <el-table-column prop="type" label="类型">
          <template slot-scope="scope">
            {{ getTypeLabel(scope.row.type) }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 'sent' ? 'success' : 'info'">
              {{ scope.row.status === 'sent' ? '已发送' : '草稿' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" />
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button size="mini" @click="viewEmail(scope.row)">查看</el-button>
            <el-button size="mini" @click="editEmail(scope.row)">编辑</el-button>
            <el-button size="mini" type="danger" @click="deleteEmail(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <!-- 模板选择对话框 -->
    <el-dialog title="选择邮件模板" :visible.sync="templateDialogVisible" width="60%">
      <el-row :gutter="20">
        <el-col :span="8" v-for="template in emailTemplates" :key="template.id">
          <el-card class="template-card" @click.native="selectTemplate(template)">
            <div class="template-info">
              <h4>{{ template.name }}</h4>
              <p>{{ template.description }}</p>
              <div class="template-meta">
                <span>类型: {{ getTypeLabel(template.type) }}</span>
                <span>使用次数: {{ template.usageCount }}</span>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
import { generateEmail, getDocumentTemplates, saveCustomTemplate } from '@/api/ai-office'
import { getUserInfo } from '@/utils/auth'

export default {
  name: 'EmailGenerator',
  data() {
    return {
      loading: false,
      saving: false,
      templateDialogVisible: false,
      saveTemplateDialogVisible: false,
      emailForm: {
        type: '',
        recipient: '',
        subject: '',
        tone: 'professional',
        urgency: 'normal',
        content: '',
        requirements: '',
        hasAttachment: false,
        attachmentDesc: ''
      },
      templateForm: {
        templateName: '',
        description: '',
        roleType: 'all'
      },
      generatedEmail: null,
      emailHistory: [],
      emailTemplates: [],
      typeLabels: {
        'work-report': '工作汇报',
        'meeting-invitation': '会议邀请',
        'project-update': '项目更新',
        'announcement': '通知公告',
        'thank-you': '感谢信',
        'apology': '道歉信',
        'leave-request': '请假申请',
        'business-cooperation': '商务合作',
        'custom': '自定义'
      }
    }
  },
  
  created() {
    this.loadTemplates()
  },
  methods: {
    handleTypeChange() {
      // 根据邮件类型预填充一些默认值
      const typeDefaults = {
        'work-report': {
          subject: '工作汇报',
          tone: 'professional',
          urgency: 'normal'
        },
        'meeting-invitation': {
          subject: '会议邀请',
          tone: 'formal',
          urgency: 'important'
        },
        'leave-request': {
          subject: '请假申请',
          tone: 'formal',
          urgency: 'normal'
        }
      }
      
      const defaults = typeDefaults[this.emailForm.type]
      if (defaults) {
        Object.assign(this.emailForm, defaults)
      }
    },
    async loadTemplates() {
      try {
        const response = await getDocumentTemplates()
        this.emailTemplates = response.data.templates.filter(t => t.templateType.includes('邮件')) || []
      } catch (error) {
        console.error('加载模板失败：', error)
      }
    },

    async generateEmail() {
      if (!this.emailForm.type || !this.emailForm.recipient || !this.emailForm.content) {
        this.$message.warning('请填写邮件类型、收件人和主要内容')
        return
      }
      
      this.loading = true
      try {
        const userInfo = getUserInfo()
        const requestData = {
          emailType: this.emailForm.type,
          recipient: this.emailForm.recipient,
          mainContent: this.emailForm.content,
          tone: this.emailForm.tone,
          urgency: this.emailForm.urgency,
          subject: this.emailForm.subject,
          requirements: this.emailForm.requirements,
          hasAttachment: this.emailForm.hasAttachment,
          attachmentDesc: this.emailForm.attachmentDesc,
          userId: userInfo.id
        }
        
        const response = await generateEmail(requestData)
        this.generatedEmail = {
          recipient: this.emailForm.recipient,
          subject: this.emailForm.subject || response.data.subject,
          body: response.data.emailContent,
          createdAt: new Date().toLocaleString()
        }
        
        this.$message.success('邮件生成成功！')
        
        // 滚动到结果区域
        this.$nextTick(() => {
          const resultCard = this.$el.querySelector('.result-card')
          if (resultCard) {
            resultCard.scrollIntoView({ behavior: 'smooth' })
          }
        })
      } catch (error) {
        this.$message.error('邮件生成失败：' + error.message)
      } finally {
        this.loading = false
      }
    },
    generateDefaultSubject() {
      const typeSubjects = {
        'work-report': '工作汇报',
        'meeting-invitation': '会议邀请',
        'project-update': '项目更新通知',
        'announcement': '重要通知',
        'thank-you': '感谢信',
        'apology': '致歉信',
        'leave-request': '请假申请',
        'business-cooperation': '合作洽谈'
      }
      return typeSubjects[this.emailForm.type] || '邮件主题'
    },
    generateEmailBody() {
      const greeting = this.getGreeting()
      const body = this.getBodyContent()
      const closing = this.getClosing()
      
      return `
        <p>${greeting}</p>
        <br>
        <div>${body}</div>
        <br>
        <p>${closing}</p>
        <br>
        <p>此致<br>敬礼！</p>
        <br>
        <p>[您的姓名]<br>[您的职位]<br>[联系方式]</p>
      `
    },
    getGreeting() {
      const toneGreetings = {
        formal: `尊敬的${this.emailForm.recipient}：`,
        friendly: `亲爱的${this.emailForm.recipient}：`,
        professional: `${this.emailForm.recipient}，您好：`,
        casual: `Hi ${this.emailForm.recipient}：`
      }
      return toneGreetings[this.emailForm.tone] || `${this.emailForm.recipient}，您好：`
    },
    getBodyContent() {
      let content = `<p>${this.emailForm.content}</p>`
      
      if (this.emailForm.requirements) {
        content += `<p>特别说明：${this.emailForm.requirements}</p>`
      }
      
      return content
    },
    getClosing() {
      const toneClosings = {
        formal: '如有任何疑问，请随时与我联系。',
        friendly: '期待您的回复，谢谢！',
        professional: '感谢您的时间和关注。',
        casual: '有什么问题随时找我哦！'
      }
      return toneClosings[this.emailForm.tone] || '感谢您的时间和关注。'
    },
    resetForm() {
      this.$refs.emailForm.resetFields()
      this.generatedEmail = null
    },
    useTemplate() {
      this.templateDialogVisible = true
    },
    selectTemplate(template) {
      this.emailForm.type = template.type
      this.handleTypeChange()
      this.templateDialogVisible = false
      this.$message.success('模板已应用')
    },
    copyEmail() {
      const content = this.generatedEmail.body.replace(/<[^>]*>/g, '')
      const fullEmail = `收件人: ${this.generatedEmail.recipient}\n主题: ${this.generatedEmail.subject}\n\n${content}`
      
      navigator.clipboard.writeText(fullEmail).then(() => {
        this.$message.success('邮件已复制到剪贴板')
      })
    },
    sendEmail() {
      this.$message.success('邮件发送成功')
      // 添加到历史记录
      this.emailHistory.unshift({
        id: Date.now(),
        subject: this.generatedEmail.subject,
        recipient: this.generatedEmail.recipient,
        type: this.emailForm.type,
        status: 'sent',
        createdAt: new Date().toLocaleString()
      })
    },
    saveTemplate() {
      this.$message.success('已保存为模板')
    },
    viewEmail(email) {
      this.$message.info(`查看邮件: ${email.subject}`)
    },
    editEmail(email) {
      this.$message.info(`编辑邮件: ${email.subject}`)
    },
    deleteEmail(id) {
      this.$confirm('确认删除这封邮件?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.emailHistory = this.emailHistory.filter(email => email.id !== id)
        this.$message.success('删除成功')
      })
    },
    getTypeLabel(type) {
      return this.typeLabels[type] || type
    }
  }
}
</script>

<style scoped>
.email-generator-container {
  padding: 20px;
}

.box-card, .result-card, .history-card {
  margin-bottom: 20px;
}

.result-card {
  min-height: 600px;
}

.loading-container {
  text-align: center;
  padding: 50px;
}

.loading-container p {
  margin-top: 20px;
  color: #909399;
}

.email-content {
  padding: 20px;
}

.email-header {
  border-bottom: 1px solid #e4e7ed;
  padding-bottom: 15px;
  margin-bottom: 20px;
}

.email-field {
  margin-bottom: 8px;
  display: flex;
  align-items: center;
}

.email-field strong {
  min-width: 60px;
  margin-right: 10px;
}

.email-body {
  line-height: 1.8;
  color: #606266;
  background: #fafafa;
  padding: 20px;
  border-radius: 4px;
  margin-bottom: 15px;
}

.email-body p {
  margin: 10px 0;
}

.email-attachment {
  display: flex;
  align-items: center;
  padding: 10px;
  background: #f0f9ff;
  border-radius: 4px;
  color: #409EFF;
}

.email-attachment i {
  margin-right: 8px;
}

.empty-state {
  padding: 50px;
}

.template-card {
  cursor: pointer;
  margin-bottom: 15px;
  transition: all 0.3s;
}

.template-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.template-info h4 {
  margin: 0 0 10px 0;
  color: #303133;
}

.template-info p {
  margin: 0 0 10px 0;
  color: #606266;
  font-size: 12px;
}

.template-meta {
  display: flex;
  justify-content: space-between;
  font-size: 11px;
  color: #909399;
}
</style>