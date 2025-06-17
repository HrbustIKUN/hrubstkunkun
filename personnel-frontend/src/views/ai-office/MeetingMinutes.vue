<template>
  <div class="meeting-minutes-container">
    <el-row :gutter="20">
      <!-- 左侧：会议信息输入 -->
      <el-col :span="12">
        <el-card class="input-card">
          <div slot="header" class="clearfix">
            <span>会议信息录入</span>
          </div>
          
          <el-form ref="meetingForm" :model="meetingForm" label-width="100px">
            <el-form-item label="会议主题">
              <el-input v-model="meetingForm.title" placeholder="请输入会议主题" />
            </el-form-item>
            
            <el-form-item label="会议时间">
              <el-date-picker
                v-model="meetingForm.datetime"
                type="datetime"
                placeholder="选择会议时间"
                style="width: 100%;"
              />
            </el-form-item>
            
            <el-form-item label="会议地点">
              <el-input v-model="meetingForm.location" placeholder="请输入会议地点" />
            </el-form-item>
            
            <el-form-item label="主持人">
              <el-input v-model="meetingForm.host" placeholder="请输入主持人姓名" />
            </el-form-item>
            
            <el-form-item label="参会人员">
              <el-input
                v-model="meetingForm.attendees"
                type="textarea"
                :rows="3"
                placeholder="请输入参会人员，用逗号分隔"
              />
            </el-form-item>
            
            <el-form-item label="会议类型">
              <el-select v-model="meetingForm.type" placeholder="请选择会议类型">
                <el-option label="工作例会" value="regular" />
                <el-option label="项目会议" value="project" />
                <el-option label="决策会议" value="decision" />
                <el-option label="培训会议" value="training" />
                <el-option label="其他" value="other" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="会议内容">
              <el-input
                v-model="meetingForm.content"
                type="textarea"
                :rows="8"
                placeholder="请输入会议的主要内容、讨论要点、决议事项等"
              />
            </el-form-item>
            
            <el-form-item label="录音文件">
              <el-upload
                class="upload-demo"
                drag
                action="#"
                :auto-upload="false"
                :on-change="handleFileChange"
                accept=".mp3,.wav,.m4a"
              >
                <i class="el-icon-upload"></i>
                <div class="el-upload__text">将录音文件拖到此处，或<em>点击上传</em></div>
                <div class="el-upload__tip" slot="tip">只能上传mp3/wav/m4a文件，且不超过50MB</div>
              </el-upload>
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="generateMinutes" :loading="loading">生成会议纪要</el-button>
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
            <span>会议纪要</span>
            <div style="float: right;">
              <el-button size="mini" @click="exportMinutes" :disabled="!generatedMinutes">导出</el-button>
              <el-button size="mini" @click="shareMinutes" :disabled="!generatedMinutes">分享</el-button>
              <el-button size="mini" @click="saveTemplate" :disabled="!generatedMinutes">保存模板</el-button>
            </div>
          </div>
          
          <div v-if="loading" class="loading-container">
            <el-icon class="is-loading"><i class="el-icon-loading"></i></el-icon>
            <p>AI正在分析会议内容并生成纪要，请稍候...</p>
          </div>
          
          <div v-else-if="generatedMinutes" class="minutes-content">
            <div class="minutes-header">
              <h2>{{ generatedMinutes.title }}</h2>
              <div class="minutes-meta">
                <p><strong>时间：</strong>{{ generatedMinutes.datetime }}</p>
                <p><strong>地点：</strong>{{ generatedMinutes.location }}</p>
                <p><strong>主持人：</strong>{{ generatedMinutes.host }}</p>
                <p><strong>参会人员：</strong>{{ generatedMinutes.attendees }}</p>
              </div>
            </div>
            
            <div class="minutes-body">
              <div class="section">
                <h3>会议议程</h3>
                <ol>
                  <li v-for="agenda in generatedMinutes.agenda" :key="agenda">{{ agenda }}</li>
                </ol>
              </div>
              
              <div class="section">
                <h3>讨论内容</h3>
                <div v-for="(discussion, index) in generatedMinutes.discussions" :key="index" class="discussion-item">
                  <h4>{{ discussion.topic }}</h4>
                  <p>{{ discussion.content }}</p>
                  <ul v-if="discussion.points">
                    <li v-for="point in discussion.points" :key="point">{{ point }}</li>
                  </ul>
                </div>
              </div>
              
              <div class="section">
                <h3>决议事项</h3>
                <div v-for="(decision, index) in generatedMinutes.decisions" :key="index" class="decision-item">
                  <div class="decision-header">
                    <span class="decision-title">{{ decision.title }}</span>
                    <el-tag :type="decision.priority === 'high' ? 'danger' : decision.priority === 'medium' ? 'warning' : 'info'">
                      {{ decision.priority === 'high' ? '高优先级' : decision.priority === 'medium' ? '中优先级' : '低优先级' }}
                    </el-tag>
                  </div>
                  <p>{{ decision.description }}</p>
                  <p><strong>负责人：</strong>{{ decision.assignee }}</p>
                  <p><strong>截止时间：</strong>{{ decision.deadline }}</p>
                </div>
              </div>
              
              <div class="section">
                <h3>行动计划</h3>
                <el-table :data="generatedMinutes.actionItems" style="width: 100%">
                  <el-table-column prop="task" label="任务" />
                  <el-table-column prop="assignee" label="负责人" />
                  <el-table-column prop="deadline" label="截止时间" />
                  <el-table-column prop="status" label="状态">
                    <template slot-scope="scope">
                      <el-tag :type="scope.row.status === 'pending' ? 'warning' : 'success'">
                        {{ scope.row.status === 'pending' ? '待处理' : '已完成' }}
                      </el-tag>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
              
              <div class="section">
                <h3>下次会议</h3>
                <p v-if="generatedMinutes.nextMeeting">
                  <strong>时间：</strong>{{ generatedMinutes.nextMeeting.time }}<br>
                  <strong>议题：</strong>{{ generatedMinutes.nextMeeting.agenda }}
                </p>
                <p v-else>待定</p>
              </div>
            </div>
          </div>
          
          <div v-else class="empty-state">
            <el-empty description="请填写左侧表单生成会议纪要"></el-empty>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 历史会议纪要 -->
    <el-card class="history-card">
      <div slot="header" class="clearfix">
        <span>历史会议纪要</span>
      </div>
      
      <el-table :data="historyMinutes" style="width: 100%">
        <el-table-column prop="title" label="会议主题" />
        <el-table-column prop="type" label="会议类型">
          <template slot-scope="scope">
            {{ getTypeLabel(scope.row.type) }}
          </template>
        </el-table-column>
        <el-table-column prop="datetime" label="会议时间" />
        <el-table-column prop="host" label="主持人" />
        <el-table-column prop="attendeeCount" label="参会人数" />
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button size="mini" @click="viewMinutes(scope.row)">查看</el-button>
            <el-button size="mini" @click="editMinutes(scope.row)">编辑</el-button>
            <el-button size="mini" type="danger" @click="deleteMinutes(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <!-- 模板选择对话框 -->
    <el-dialog title="选择会议纪要模板" :visible.sync="templateDialogVisible" width="60%">
      <el-row :gutter="20">
        <el-col :span="8" v-for="template in templates" :key="template.id">
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
import { generateDocument, getDocumentTemplates, saveCustomTemplate } from '@/api/ai-office'
import { getUserInfo } from '@/utils/auth'

export default {
  name: 'MeetingMinutes',
  data() {
    return {
      loading: false,
      saving: false,
      templateDialogVisible: false,
      saveTemplateDialogVisible: false,
      meetingForm: {
        title: '',
        datetime: '',
        location: '',
        host: '',
        attendees: '',
        type: '',
        content: '',
        audioFile: null
      },
      templateForm: {
        templateName: '',
        description: '',
        roleType: 'all'
      },
      generatedMinutes: null,
      historyMinutes: [],
      templates: [],
      typeLabels: {
        'regular': '工作例会',
        'project': '项目会议',
        'decision': '决策会议',
        'training': '培训会议',
        'other': '其他'
      }
    }
  },
  methods: {
    handleFileChange(file) {
      this.meetingForm.audioFile = file.raw
      this.$message.success('录音文件上传成功')
    },
    async loadTemplates() {
      try {
        const response = await getDocumentTemplates()
        this.templates = response.data.templates.filter(t => t.templateType.includes('会议纪要')) || []
      } catch (error) {
        console.error('加载模板失败：', error)
      }
    },

    async generateMinutes() {
      if (!this.meetingForm.title || !this.meetingForm.content) {
        this.$message.warning('请填写会议主题和内容')
        return
      }
      
      this.loading = true
      try {
        const userInfo = getUserInfo()
        
        // 构建会议信息内容
        const meetingInfo = `
会议主题：${this.meetingForm.title}
会议时间：${this.meetingForm.datetime ? new Date(this.meetingForm.datetime).toLocaleString() : '未指定'}
会议地点：${this.meetingForm.location || '未指定'}
主持人：${this.meetingForm.host || '未指定'}
参会人员：${this.meetingForm.attendees || '未指定'}
会议类型：${this.typeLabels[this.meetingForm.type] || '未指定'}

会议内容：
${this.meetingForm.content}
        `.trim()
        
        const requestData = {
          documentType: '会议纪要',
          title: this.meetingForm.title,
          content: meetingInfo,
          department: userInfo.department || '未指定',
          userId: userInfo.id
        }
        
        const response = await generateDocument(requestData)
        
        // 解析生成的会议纪要
        this.generatedMinutes = {
          title: this.meetingForm.title,
          datetime: this.meetingForm.datetime ? new Date(this.meetingForm.datetime).toLocaleString() : '未指定',
          location: this.meetingForm.location || '未指定',
          host: this.meetingForm.host || '未指定',
          attendees: this.meetingForm.attendees || '未指定',
          content: response.data.document,
          createdAt: new Date().toLocaleString()
        }
        
        this.$message.success('会议纪要生成成功！')
        
        // 滚动到结果区域
        this.$nextTick(() => {
          const resultCard = this.$el.querySelector('.result-card')
          if (resultCard) {
            resultCard.scrollIntoView({ behavior: 'smooth' })
          }
        })
      } catch (error) {
        this.$message.error('会议纪要生成失败：' + error.message)
      } finally {
        this.loading = false
      }
    },

    async saveAsTemplate() {
      if (!this.generatedMinutes) {
        this.$message.warning('请先生成会议纪要')
        return
      }
      this.templateForm.templateName = this.meetingForm.title + ' - 会议纪要模板'
      this.saveTemplateDialogVisible = true
    },

    async confirmSaveTemplate() {
      if (!this.templateForm.templateName) {
        this.$message.warning('请输入模板名称')
        return
      }
      
      this.saving = true
      try {
        const userInfo = getUserInfo()
        const templateData = {
          templateName: this.templateForm.templateName,
          templateType: '会议纪要',
          templateContent: this.generatedMinutes.content,
          description: this.templateForm.description,
          roleType: this.templateForm.roleType,
          creatorId: userInfo.id
        }
        
        await saveCustomTemplate(templateData)
        this.$message.success('模板保存成功')
        this.saveTemplateDialogVisible = false
        this.loadTemplates() // 重新加载模板列表
      } catch (error) {
        this.$message.error('模板保存失败：' + error.message)
      } finally {
        this.saving = false
      }
    },

    exportMinutes() {
      if (!this.generatedMinutes) return
      
      const content = `
会议纪要

会议主题：${this.generatedMinutes.title}
会议时间：${this.generatedMinutes.datetime}
会议地点：${this.generatedMinutes.location}
主持人：${this.generatedMinutes.host}
参会人员：${this.generatedMinutes.attendees}

${this.generatedMinutes.content}
      `.trim()
      
      const blob = new Blob([content], { type: 'text/plain;charset=utf-8' })
      const url = window.URL.createObjectURL(blob)
      const link = document.createElement('a')
      link.href = url
      link.download = `${this.generatedMinutes.title}_会议纪要.txt`
      link.click()
      window.URL.revokeObjectURL(url)
      this.$message.success('会议纪要导出成功')
    },

    shareMinutes() {
      if (!this.generatedMinutes) return
      
      if (navigator.share) {
        navigator.share({
          title: this.generatedMinutes.title + ' - 会议纪要',
          text: this.generatedMinutes.content
        })
      } else {
        // 复制到剪贴板作为备选方案
        if (navigator.clipboard) {
          navigator.clipboard.writeText(this.generatedMinutes.content)
          this.$message.success('会议纪要已复制到剪贴板')
        }
      }
    },

    useTemplate() {
      this.templateDialogVisible = true
    },

    selectTemplate(template) {
      this.meetingForm.type = template.templateType
      this.templateDialogVisible = false
      this.$message.success('已选择模板：' + template.templateName)
    },

    resetForm() {
      this.$refs.meetingForm.resetFields()
      this.generatedMinutes = null
      this.meetingForm.audioFile = null
    },
    useTemplate() {
      this.templateDialogVisible = true
    },
    selectTemplate(template) {
      this.meetingForm.type = template.type
      this.templateDialogVisible = false
      this.$message.success('模板已应用')
    },
    exportMinutes() {
      this.$message.success('会议纪要导出成功')
    },
    shareMinutes() {
      this.$message.success('会议纪要分享成功')
    },
    saveTemplate() {
      this.$message.success('已保存为模板')
    },
    viewMinutes(minutes) {
      this.$message.info(`查看会议纪要: ${minutes.title}`)
    },
    editMinutes(minutes) {
      this.$message.info(`编辑会议纪要: ${minutes.title}`)
    },
    deleteMinutes(id) {
      this.$confirm('确认删除这份会议纪要?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.historyMinutes = this.historyMinutes.filter(minutes => minutes.id !== id)
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
.meeting-minutes-container {
  padding: 20px;
}

.input-card, .result-card, .history-card {
  margin-bottom: 20px;
}

.result-card {
  min-height: 700px;
}

.loading-container {
  text-align: center;
  padding: 50px;
}

.loading-container p {
  margin-top: 20px;
  color: #909399;
}

.minutes-content {
  padding: 20px;
}

.minutes-header {
  border-bottom: 2px solid #409EFF;
  padding-bottom: 20px;
  margin-bottom: 30px;
}

.minutes-header h2 {
  margin: 0 0 15px 0;
  color: #303133;
  text-align: center;
}

.minutes-meta p {
  margin: 5px 0;
  color: #606266;
}

.minutes-body {
  line-height: 1.8;
}

.section {
  margin-bottom: 30px;
}

.section h3 {
  color: #303133;
  margin-bottom: 15px;
  border-bottom: 1px solid #e4e7ed;
  padding-bottom: 8px;
}

.discussion-item, .decision-item {
  margin-bottom: 20px;
  padding: 15px;
  background: #f9f9f9;
  border-radius: 4px;
}

.discussion-item h4 {
  color: #409EFF;
  margin-bottom: 10px;
}

.decision-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.decision-title {
  font-weight: bold;
  color: #303133;
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

.upload-demo {
  width: 100%;
}
</style>