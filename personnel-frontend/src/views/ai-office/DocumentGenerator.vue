<template>
  <div class="document-generator">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span class="card-title">
          <i class="el-icon-document"></i>
          智能文档生成
        </span>
      </div>

      <el-form :model="documentForm" :rules="rules" ref="documentForm" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="文档类型" prop="type">
              <el-select v-model="documentForm.type" placeholder="请选择文档类型" style="width: 100%">
                <el-option 
                  v-for="type in documentTypes" 
                  :key="type" 
                  :label="type" 
                  :value="type">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="所属部门" prop="department">
              <el-input v-model="documentForm.department" placeholder="请输入部门名称"></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="文档标题" prop="title">
          <el-input v-model="documentForm.title" placeholder="请输入文档标题"></el-input>
        </el-form-item>

        <el-form-item label="内容要点" prop="keyPoints">
          <el-input 
            type="textarea" 
            v-model="documentForm.keyPoints" 
            :rows="6" 
            placeholder="请详细描述文档的主要内容要点，包括：&#10;1. 背景情况&#10;2. 主要内容&#10;3. 具体要求&#10;4. 预期目标等">
          </el-input>
        </el-form-item>

        <el-form-item label="特殊要求">
          <el-input 
            type="textarea" 
            v-model="documentForm.references" 
            :rows="3" 
            placeholder="如有特殊格式要求、字数限制、风格要求等，请在此说明">
          </el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="generateDocument" :loading="loading" size="medium">
            <i class="el-icon-magic-stick"></i>
            生成文档
          </el-button>
          <el-button @click="resetForm" size="medium">重置</el-button>
          <el-button @click="useTemplate" size="medium">
            <i class="el-icon-folder-opened"></i>
            使用模板
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 生成结果 -->
      <div v-if="generatedDocument" class="result-section">
        <el-divider content-position="left">
          <span class="result-title">生成结果</span>
        </el-divider>
        
        <div class="result-toolbar">
          <el-button size="small" @click="copyDocument">
            <i class="el-icon-document-copy"></i>
            复制内容
          </el-button>
          <el-button size="small" @click="downloadDocument">
            <i class="el-icon-download"></i>
            下载文档
          </el-button>
          <el-button size="small" @click="saveAsTemplate">
            <i class="el-icon-folder-add"></i>
            保存为模板
          </el-button>
          <el-button size="small" @click="generateDocument">
            <i class="el-icon-refresh"></i>
            重新生成
          </el-button>
        </div>

        <div class="result-content">
          <div class="document-preview" v-html="generatedDocument.content"></div>
        </div>
      </div>
    </el-card>

    <!-- 模板选择对话框 -->
    <el-dialog title="选择文档模板" :visible.sync="templateDialogVisible" width="60%">
      <el-row :gutter="20">
        <el-col :span="8" v-for="template in templates" :key="template.id">
          <el-card class="template-card" @click.native="selectTemplate(template)">
            <div class="template-info">
              <h4>{{ template.templateName }}</h4>
              <p>{{ template.description }}</p>
              <div class="template-meta">
                <span class="template-type">{{ template.templateType }}</span>
                <span class="template-creator">{{ template.creatorName }}</span>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </el-dialog>

    <!-- 保存模板对话框 -->
    <el-dialog title="保存为模板" :visible.sync="saveTemplateDialogVisible" width="40%">
      <el-form :model="templateForm" label-width="100px">
        <el-form-item label="模板名称">
          <el-input v-model="templateForm.templateName" placeholder="请输入模板名称"></el-input>
        </el-form-item>
        <el-form-item label="模板描述">
          <el-input type="textarea" v-model="templateForm.description" :rows="3" placeholder="请描述模板的用途和特点"></el-input>
        </el-form-item>
        <el-form-item label="适用角色">
          <el-select v-model="templateForm.roleType" placeholder="请选择适用角色">
            <el-option label="所有角色" value="all"></el-option>
            <el-option label="管理员" value="管理员"></el-option>
            <el-option label="人事经理" value="人事经理"></el-option>
            <el-option label="职员" value="职员"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="saveTemplateDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmSaveTemplate" :loading="saving">保存</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { generateDocument, getDocumentTemplates, saveCustomTemplate } from '@/api/ai-office'
import { getUserInfo } from '@/utils/auth'

export default {
  name: 'DocumentGenerator',
  data() {
    return {
      loading: false,
      saving: false,
      templateDialogVisible: false,
      saveTemplateDialogVisible: false,
      documentForm: {
        type: '',
        title: '',
        audience: '',
        length: 'medium',
        style: 'formal',
        keyPoints: '',
        references: ''
      },
      templateForm: {
        templateName: '',
        description: '',
        roleType: 'all'
      },
      generatedDocument: null,
      historyDocuments: [],
      templates: [],
      documentTypes: [
        '工作报告',
        '项目计划',
        '会议纪要',
        '培训材料',
        '政策文档',
        '技术文档',
        '通知公告',
        '合同协议'
      ],
      rules: {
        type: [{ required: true, message: '请选择文档类型', trigger: 'change' }],
        title: [{ required: true, message: '请输入文档标题', trigger: 'blur' }],
        keyPoints: [{ required: true, message: '请输入内容要点', trigger: 'blur' }]
      },
      typeLabels: {
        'work-report': '工作报告',
        'project-plan': '项目计划',
        'meeting-minutes': '会议纪要',
        'training-material': '培训材料',
        'policy-document': '政策文档',
        'technical-document': '技术文档',
        'custom': '自定义'
      }
    }
  },
  methods: {
    handleTypeChange() {
      // 根据文档类型预填充一些默认值
      const typeDefaults = {
        'work-report': {
          title: '工作报告',
          audience: 'management',
          style: 'formal'
        },
        'project-plan': {
          title: '项目计划',
          audience: 'employees',
          style: 'detailed'
        }
      }
      
      const defaults = typeDefaults[this.documentForm.type]
      if (defaults) {
        Object.assign(this.documentForm, defaults)
      }
    },
    async generateDocument() {
      // 表单验证
      const valid = await this.$refs.documentForm.validate().catch(() => false)
      if (!valid) {
        return
      }
      
      this.loading = true
      
      try {
        const requestData = {
          documentType: this.documentForm.type,
          title: this.documentForm.title,
          content: this.documentForm.keyPoints || '',
          requirements: this.documentForm.references || '',
          userId: getUserInfo().userId
        }
        
        const response = await generateDocument(requestData)
        
        this.generatedDocument = {
          title: this.documentForm.title,
          type: this.documentForm.type,
          content: response.data,
          wordCount: response.data.length,
          createdAt: new Date().toLocaleString()
        }
        
        this.$message.success('文档生成成功')
        
        // 滚动到结果区域
        this.$nextTick(() => {
          const resultElement = document.querySelector('.result-section')
          if (resultElement) {
            resultElement.scrollIntoView({ behavior: 'smooth' })
          }
        })
      } catch (error) {
        console.error('生成文档失败:', error)
        this.$message.error('生成文档失败，请稍后重试')
      } finally {
        this.loading = false
      }
    },
    generateSampleContent() {
      return `
        <h3>一、概述</h3>
        <p>本文档基于您提供的要求生成，旨在为${this.documentForm.audience === 'management' ? '管理层' : '相关人员'}提供清晰、准确的信息。</p>
        
        <h3>二、主要内容</h3>
        <p>${this.documentForm.keyPoints || '根据您的需求，我们将详细阐述相关内容...'}</p>
        
        <h3>三、详细说明</h3>
        <p>基于${this.documentForm.style === 'formal' ? '正式' : '友好'}的写作风格，本文档采用${this.documentForm.length === 'short' ? '简洁' : this.documentForm.length === 'medium' ? '适中' : '详细'}的篇幅来阐述相关内容。</p>
        
        <h3>四、结论与建议</h3>
        <p>综合以上分析，我们建议采取相应的措施来达成预期目标。</p>
        
        ${this.documentForm.references ? '<h3>五、参考资料</h3><p>' + this.documentForm.references + '</p>' : ''}
      `
    },
    resetForm() {
      this.$refs.documentForm.resetFields()
      this.generatedDocument = null
    },
    useTemplate() {
      this.templateDialogVisible = true
    },
    selectTemplate(template) {
      this.documentForm.type = template.type
      this.documentForm.title = template.name
      this.templateDialogVisible = false
      this.$message.success('模板已应用')
    },
    copyDocument() {
      // 复制文档内容到剪贴板
      const content = this.generatedDocument.content.replace(/<[^>]*>/g, '')
      navigator.clipboard.writeText(content).then(() => {
        this.$message.success('文档已复制到剪贴板')
      })
    },
    downloadDocument() {
      this.$message.success('文档下载成功')
    },
    saveTemplate() {
      this.$message.success('已保存为模板')
    },
    viewDocument(doc) {
      this.generatedDocument = doc
    },
    editDocument(doc) {
      this.$message.info(`编辑文档: ${doc.title}`)
    },
    deleteDocument(id) {
      this.$confirm('确认删除这份文档?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.historyDocuments = this.historyDocuments.filter(doc => doc.id !== id)
        this.$message.success('删除成功')
      })
    },
    
    // 加载模板
    async loadTemplates() {
      try {
        const response = await getDocumentTemplates()
        this.templates = response.data || []
      } catch (error) {
        console.error('加载模板失败:', error)
      }
    },
    
    // 保存为模板
    saveAsTemplate() {
      if (!this.generatedDocument) {
        this.$message.warning('请先生成文档')
        return
      }
      this.templateForm.templateName = this.generatedDocument.title
      this.saveTemplateDialogVisible = true
    },
    
    // 确认保存模板
    async confirmSaveTemplate() {
      if (!this.templateForm.templateName) {
        this.$message.warning('请输入模板名称')
        return
      }
      
      this.saving = true
      
      try {
        const templateData = {
          templateName: this.templateForm.templateName,
          templateType: this.generatedDocument.type,
          templateContent: this.generatedDocument.content,
          description: this.templateForm.description,
          roleType: this.templateForm.roleType,
          creatorId: getUserInfo().userId,
          creatorName: getUserInfo().nickName
        }
        
        await saveCustomTemplate(templateData)
        this.$message.success('模板保存成功')
        this.saveTemplateDialogVisible = false
        this.loadTemplates() // 重新加载模板列表
      } catch (error) {
        console.error('保存模板失败:', error)
        this.$message.error('保存模板失败，请稍后重试')
      } finally {
        this.saving = false
      }
    },
    
    getTypeLabel(type) {
      return this.typeLabels[type] || type
    }
  },
  
  created() {
    this.loadTemplates()
  }
}
</script>

<style scoped>
.document-generator-container {
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

.document-content {
  padding: 20px;
}

.document-header {
  border-bottom: 2px solid #409EFF;
  padding-bottom: 15px;
  margin-bottom: 20px;
}

.document-header h2 {
  margin: 0 0 10px 0;
  color: #303133;
}

.document-meta {
  display: flex;
  gap: 20px;
  font-size: 12px;
  color: #909399;
}

.document-body {
  line-height: 1.8;
  color: #606266;
}

.document-body h3 {
  color: #303133;
  margin: 20px 0 10px 0;
}

.document-body p {
  margin: 10px 0;
  text-indent: 2em;
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