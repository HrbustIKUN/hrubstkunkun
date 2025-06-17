<template>
  <div class="document-generator-container">
    <el-row :gutter="20">
      <!-- 左侧：文档生成表单 -->
      <el-col :span="12">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>智能文档生成</span>
          </div>
          
          <el-form ref="documentForm" :model="documentForm" label-width="100px">
            <el-form-item label="文档类型">
              <el-select v-model="documentForm.type" placeholder="请选择文档类型" @change="handleTypeChange">
                <el-option label="工作报告" value="work-report" />
                <el-option label="项目计划" value="project-plan" />
                <el-option label="会议纪要" value="meeting-minutes" />
                <el-option label="培训材料" value="training-material" />
                <el-option label="政策文档" value="policy-document" />
                <el-option label="技术文档" value="technical-document" />
                <el-option label="自定义" value="custom" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="文档标题">
              <el-input v-model="documentForm.title" placeholder="请输入文档标题" />
            </el-form-item>
            
            <el-form-item label="目标受众">
              <el-select v-model="documentForm.audience" placeholder="请选择目标受众">
                <el-option label="管理层" value="management" />
                <el-option label="员工" value="employees" />
                <el-option label="客户" value="clients" />
                <el-option label="合作伙伴" value="partners" />
                <el-option label="公众" value="public" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="文档长度">
              <el-radio-group v-model="documentForm.length">
                <el-radio label="short">简短 (500字以内)</el-radio>
                <el-radio label="medium">中等 (500-1500字)</el-radio>
                <el-radio label="long">详细 (1500字以上)</el-radio>
              </el-radio-group>
            </el-form-item>
            
            <el-form-item label="写作风格">
              <el-select v-model="documentForm.style" placeholder="请选择写作风格">
                <el-option label="正式" value="formal" />
                <el-option label="友好" value="friendly" />
                <el-option label="技术性" value="technical" />
                <el-option label="简洁" value="concise" />
                <el-option label="详细" value="detailed" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="关键信息">
              <el-input
                v-model="documentForm.keyPoints"
                type="textarea"
                :rows="4"
                placeholder="请输入文档的关键信息、要点或大纲"
              />
            </el-form-item>
            
            <el-form-item label="参考资料">
              <el-input
                v-model="documentForm.references"
                type="textarea"
                :rows="3"
                placeholder="可选：提供相关的参考资料或背景信息"
              />
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="generateDocument" :loading="loading">生成文档</el-button>
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
              <el-button size="mini" @click="copyDocument" :disabled="!generatedDocument">复制</el-button>
              <el-button size="mini" @click="downloadDocument" :disabled="!generatedDocument">下载</el-button>
              <el-button size="mini" @click="saveTemplate" :disabled="!generatedDocument">保存为模板</el-button>
            </div>
          </div>
          
          <div v-if="loading" class="loading-container">
            <el-icon class="is-loading"><i class="el-icon-loading"></i></el-icon>
            <p>AI正在生成文档，请稍候...</p>
          </div>
          
          <div v-else-if="generatedDocument" class="document-content">
            <div class="document-header">
              <h2>{{ generatedDocument.title }}</h2>
              <div class="document-meta">
                <span>类型: {{ getTypeLabel(generatedDocument.type) }}</span>
                <span>生成时间: {{ generatedDocument.createdAt }}</span>
                <span>字数: {{ generatedDocument.wordCount }}</span>
              </div>
            </div>
            
            <div class="document-body" v-html="generatedDocument.content"></div>
          </div>
          
          <div v-else class="empty-state">
            <el-empty description="请填写左侧表单生成文档"></el-empty>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 历史文档 -->
    <el-card class="history-card">
      <div slot="header" class="clearfix">
        <span>历史文档</span>
      </div>
      
      <el-table :data="historyDocuments" style="width: 100%">
        <el-table-column prop="title" label="文档标题" />
        <el-table-column prop="type" label="类型">
          <template slot-scope="scope">
            {{ getTypeLabel(scope.row.type) }}
          </template>
        </el-table-column>
        <el-table-column prop="wordCount" label="字数" />
        <el-table-column prop="createdAt" label="创建时间" />
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button size="mini" @click="viewDocument(scope.row)">查看</el-button>
            <el-button size="mini" @click="editDocument(scope.row)">编辑</el-button>
            <el-button size="mini" type="danger" @click="deleteDocument(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <!-- 模板选择对话框 -->
    <el-dialog title="选择模板" :visible.sync="templateDialogVisible" width="60%">
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
export default {
  name: 'DocumentGenerator',
  data() {
    return {
      loading: false,
      templateDialogVisible: false,
      documentForm: {
        type: '',
        title: '',
        audience: '',
        length: 'medium',
        style: 'formal',
        keyPoints: '',
        references: ''
      },
      generatedDocument: null,
      historyDocuments: [
        {
          id: 1,
          title: '2024年第一季度工作报告',
          type: 'work-report',
          wordCount: 1200,
          createdAt: '2024-01-15 14:30:00'
        },
        {
          id: 2,
          title: '新员工培训计划',
          type: 'training-material',
          wordCount: 800,
          createdAt: '2024-01-14 09:15:00'
        }
      ],
      templates: [
        {
          id: 1,
          name: '工作报告模板',
          type: 'work-report',
          description: '标准的工作报告格式，包含工作总结、成果展示和下期计划',
          usageCount: 25
        },
        {
          id: 2,
          name: '项目计划模板',
          type: 'project-plan',
          description: '完整的项目计划文档，包含目标、时间线、资源分配等',
          usageCount: 18
        }
      ],
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
    generateDocument() {
      if (!this.documentForm.type || !this.documentForm.title) {
        this.$message.warning('请选择文档类型并输入标题')
        return
      }
      
      this.loading = true
      
      // 模拟AI生成过程
      setTimeout(() => {
        this.generatedDocument = {
          title: this.documentForm.title,
          type: this.documentForm.type,
          content: this.generateSampleContent(),
          wordCount: 1200,
          createdAt: new Date().toLocaleString()
        }
        
        this.loading = false
        this.$message.success('文档生成成功')
      }, 3000)
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
    getTypeLabel(type) {
      return this.typeLabels[type] || type
    }
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