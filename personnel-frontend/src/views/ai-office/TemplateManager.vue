<template>
  <div class="template-manager-container">
    <!-- 操作栏 -->
    <div class="action-bar">
      <el-button type="primary" @click="createTemplate">新建模板</el-button>
      <el-button @click="importTemplate">导入模板</el-button>
      <el-button @click="exportTemplates">批量导出</el-button>
      
      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索模板"
          prefix-icon="el-icon-search"
          @input="handleSearch"
          style="width: 300px;"
        />
        <el-select v-model="selectedCategory" placeholder="选择分类" @change="handleFilter" style="width: 150px; margin-left: 10px;">
          <el-option label="全部" value="" />
          <el-option label="文档模板" value="document" />
          <el-option label="邮件模板" value="email" />
          <el-option label="会议模板" value="meeting" />
          <el-option label="报告模板" value="report" />
        </el-select>
      </div>
    </div>
    
    <!-- 模板列表 -->
    <el-row :gutter="20">
      <el-col :span="6" v-for="template in filteredTemplates" :key="template.id">
        <el-card class="template-card" @click.native="viewTemplate(template)">
          <div class="template-header">
            <div class="template-icon">
              <i :class="getTemplateIcon(template.category)"></i>
            </div>
            <div class="template-actions">
              <el-dropdown @command="handleCommand" trigger="click">
                <span class="el-dropdown-link">
                  <i class="el-icon-more"></i>
                </span>
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item :command="{action: 'edit', template}">编辑</el-dropdown-item>
                  <el-dropdown-item :command="{action: 'copy', template}">复制</el-dropdown-item>
                  <el-dropdown-item :command="{action: 'export', template}">导出</el-dropdown-item>
                  <el-dropdown-item :command="{action: 'delete', template}" divided>删除</el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
            </div>
          </div>
          
          <div class="template-content">
            <h4 class="template-title">{{ template.name }}</h4>
            <p class="template-description">{{ template.description }}</p>
            
            <div class="template-meta">
              <el-tag size="mini" :type="getCategoryType(template.category)">{{ getCategoryLabel(template.category) }}</el-tag>
              <span class="template-usage">使用 {{ template.usageCount }} 次</span>
            </div>
            
            <div class="template-info">
              <span class="template-creator">创建者: {{ template.creator }}</span>
              <span class="template-date">{{ template.createdAt }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 分页 -->
    <div class="pagination-section">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-sizes="[12, 24, 48]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
      />
    </div>
    
    <!-- 模板详情对话框 -->
    <el-dialog title="模板详情" :visible.sync="detailDialogVisible" width="70%">
      <div v-if="selectedTemplate">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="模板名称">{{ selectedTemplate.name }}</el-descriptions-item>
          <el-descriptions-item label="分类">{{ getCategoryLabel(selectedTemplate.category) }}</el-descriptions-item>
          <el-descriptions-item label="创建者">{{ selectedTemplate.creator }}</el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ selectedTemplate.createdAt }}</el-descriptions-item>
          <el-descriptions-item label="使用次数">{{ selectedTemplate.usageCount }}</el-descriptions-item>
          <el-descriptions-item label="最后使用">{{ selectedTemplate.lastUsed }}</el-descriptions-item>
        </el-descriptions>
        
        <div class="template-detail-content">
          <h4>模板描述</h4>
          <p>{{ selectedTemplate.description }}</p>
          
          <h4>模板内容</h4>
          <div class="template-preview" v-html="selectedTemplate.content"></div>
        </div>
        
        <div class="dialog-actions">
          <el-button @click="useTemplate(selectedTemplate)">使用模板</el-button>
          <el-button @click="editTemplate(selectedTemplate)">编辑模板</el-button>
          <el-button @click="copyTemplate(selectedTemplate)">复制模板</el-button>
        </div>
      </div>
    </el-dialog>
    
    <!-- 创建/编辑模板对话框 -->
    <el-dialog :title="editMode ? '编辑模板' : '创建模板'" :visible.sync="editDialogVisible" width="60%">
      <el-form ref="templateForm" :model="templateForm" :rules="templateRules" label-width="100px">
        <el-form-item label="模板名称" prop="name">
          <el-input v-model="templateForm.name" placeholder="请输入模板名称" />
        </el-form-item>
        
        <el-form-item label="模板分类" prop="category">
          <el-select v-model="templateForm.category" placeholder="请选择分类">
            <el-option label="文档模板" value="document" />
            <el-option label="邮件模板" value="email" />
            <el-option label="会议模板" value="meeting" />
            <el-option label="报告模板" value="report" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="模板描述" prop="description">
          <el-input
            v-model="templateForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入模板描述"
          />
        </el-form-item>
        
        <el-form-item label="模板内容" prop="content">
          <el-input
            v-model="templateForm.content"
            type="textarea"
            :rows="10"
            placeholder="请输入模板内容"
          />
        </el-form-item>
        
        <el-form-item label="标签">
          <el-tag
            v-for="tag in templateForm.tags"
            :key="tag"
            closable
            @close="removeTag(tag)"
            style="margin-right: 10px;"
          >
            {{ tag }}
          </el-tag>
          <el-input
            v-if="inputVisible"
            v-model="inputValue"
            ref="saveTagInput"
            size="small"
            @keyup.enter.native="handleInputConfirm"
            @blur="handleInputConfirm"
            style="width: 90px;"
          />
          <el-button v-else size="small" @click="showInput">+ 新标签</el-button>
        </el-form-item>
        
        <el-form-item label="权限设置">
          <el-radio-group v-model="templateForm.permission">
            <el-radio label="private">私有</el-radio>
            <el-radio label="department">部门共享</el-radio>
            <el-radio label="public">公开</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveTemplate">保存</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'TemplateManager',
  data() {
    return {
      searchKeyword: '',
      selectedCategory: '',
      currentPage: 1,
      pageSize: 12,
      total: 0,
      detailDialogVisible: false,
      editDialogVisible: false,
      editMode: false,
      selectedTemplate: null,
      inputVisible: false,
      inputValue: '',
      templates: [
        {
          id: 1,
          name: '工作报告模板',
          category: 'document',
          description: '标准的工作报告格式，包含工作总结、成果展示和下期计划',
          content: '<h3>工作总结</h3><p>本期工作内容...</p><h3>主要成果</h3><p>取得的成果...</p><h3>下期计划</h3><p>下期工作安排...</p>',
          creator: '张三',
          createdAt: '2024-01-10',
          lastUsed: '2024-01-15',
          usageCount: 25,
          tags: ['工作', '报告', '总结'],
          permission: 'department'
        },
        {
          id: 2,
          name: '项目计划模板',
          category: 'document',
          description: '完整的项目计划文档，包含目标、时间线、资源分配等',
          content: '<h3>项目概述</h3><p>项目背景和目标...</p><h3>项目计划</h3><p>详细计划...</p>',
          creator: '李四',
          createdAt: '2024-01-08',
          lastUsed: '2024-01-14',
          usageCount: 18,
          tags: ['项目', '计划'],
          permission: 'public'
        },
        {
          id: 3,
          name: '会议邀请邮件模板',
          category: 'email',
          description: '正式的会议邀请邮件格式',
          content: '尊敬的{收件人}：<br>您好！<br>兹定于{时间}在{地点}召开{会议主题}...',
          creator: '王五',
          createdAt: '2024-01-05',
          lastUsed: '2024-01-13',
          usageCount: 32,
          tags: ['邮件', '会议', '邀请'],
          permission: 'public'
        },
        {
          id: 4,
          name: '周例会纪要模板',
          category: 'meeting',
          description: '标准的周例会会议纪要格式',
          content: '<h3>会议基本信息</h3><p>时间：{时间}<br>地点：{地点}<br>主持人：{主持人}</p>',
          creator: '赵六',
          createdAt: '2024-01-03',
          lastUsed: '2024-01-12',
          usageCount: 45,
          tags: ['会议', '纪要', '例会'],
          permission: 'department'
        }
      ],
      filteredTemplates: [],
      templateForm: {
        name: '',
        category: '',
        description: '',
        content: '',
        tags: [],
        permission: 'private'
      },
      templateRules: {
        name: [{ required: true, message: '请输入模板名称', trigger: 'blur' }],
        category: [{ required: true, message: '请选择模板分类', trigger: 'change' }],
        description: [{ required: true, message: '请输入模板描述', trigger: 'blur' }],
        content: [{ required: true, message: '请输入模板内容', trigger: 'blur' }]
      },
      categoryLabels: {
        'document': '文档模板',
        'email': '邮件模板',
        'meeting': '会议模板',
        'report': '报告模板'
      },
      categoryIcons: {
        'document': 'el-icon-document',
        'email': 'el-icon-message',
        'meeting': 'el-icon-notebook-1',
        'report': 'el-icon-data-analysis'
      }
    }
  },
  mounted() {
    this.loadTemplates()
  },
  methods: {
    loadTemplates() {
      this.filteredTemplates = [...this.templates]
      this.total = this.templates.length
    },
    handleSearch() {
      this.filterTemplates()
    },
    handleFilter() {
      this.filterTemplates()
    },
    filterTemplates() {
      let filtered = [...this.templates]
      
      if (this.searchKeyword) {
        filtered = filtered.filter(template => 
          template.name.includes(this.searchKeyword) || 
          template.description.includes(this.searchKeyword) ||
          template.tags.some(tag => tag.includes(this.searchKeyword))
        )
      }
      
      if (this.selectedCategory) {
        filtered = filtered.filter(template => template.category === this.selectedCategory)
      }
      
      this.filteredTemplates = filtered
      this.total = filtered.length
    },
    createTemplate() {
      this.editMode = false
      this.templateForm = {
        name: '',
        category: '',
        description: '',
        content: '',
        tags: [],
        permission: 'private'
      }
      this.editDialogVisible = true
    },
    editTemplate(template) {
      this.editMode = true
      this.templateForm = { ...template }
      this.editDialogVisible = true
    },
    saveTemplate() {
      this.$refs.templateForm.validate((valid) => {
        if (valid) {
          if (this.editMode) {
            // 更新模板
            const index = this.templates.findIndex(t => t.id === this.templateForm.id)
            if (index !== -1) {
              this.templates[index] = { ...this.templateForm }
            }
            this.$message.success('模板更新成功')
          } else {
            // 创建新模板
            const newTemplate = {
              ...this.templateForm,
              id: Date.now(),
              creator: '当前用户',
              createdAt: new Date().toLocaleDateString(),
              lastUsed: '-',
              usageCount: 0
            }
            this.templates.unshift(newTemplate)
            this.$message.success('模板创建成功')
          }
          
          this.editDialogVisible = false
          this.loadTemplates()
        }
      })
    },
    viewTemplate(template) {
      this.selectedTemplate = template
      this.detailDialogVisible = true
    },
    useTemplate(template) {
      this.$message.success(`使用模板: ${template.name}`)
      // 增加使用次数
      template.usageCount++
      template.lastUsed = new Date().toLocaleDateString()
      this.detailDialogVisible = false
    },
    copyTemplate(template) {
      const newTemplate = {
        ...template,
        id: Date.now(),
        name: template.name + ' (副本)',
        creator: '当前用户',
        createdAt: new Date().toLocaleDateString(),
        usageCount: 0,
        lastUsed: '-'
      }
      this.templates.unshift(newTemplate)
      this.$message.success('模板复制成功')
      this.loadTemplates()
    },
    deleteTemplate(template) {
      this.$confirm(`确认删除模板 "${template.name}"?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.templates = this.templates.filter(t => t.id !== template.id)
        this.$message.success('删除成功')
        this.loadTemplates()
      })
    },
    handleCommand(command) {
      const { action, template } = command
      switch (action) {
        case 'edit':
          this.editTemplate(template)
          break
        case 'copy':
          this.copyTemplate(template)
          break
        case 'export':
          this.exportTemplate(template)
          break
        case 'delete':
          this.deleteTemplate(template)
          break
      }
    },
    exportTemplate(template) {
      this.$message.success(`导出模板: ${template.name}`)
    },
    exportTemplates() {
      this.$message.success('批量导出成功')
    },
    importTemplate() {
      this.$message.success('导入模板成功')
    },
    removeTag(tag) {
      this.templateForm.tags.splice(this.templateForm.tags.indexOf(tag), 1)
    },
    showInput() {
      this.inputVisible = true
      this.$nextTick(() => {
        this.$refs.saveTagInput.$refs.input.focus()
      })
    },
    handleInputConfirm() {
      const inputValue = this.inputValue
      if (inputValue && !this.templateForm.tags.includes(inputValue)) {
        this.templateForm.tags.push(inputValue)
      }
      this.inputVisible = false
      this.inputValue = ''
    },
    getCategoryLabel(category) {
      return this.categoryLabels[category] || category
    },
    getCategoryType(category) {
      const types = {
        'document': 'primary',
        'email': 'success',
        'meeting': 'warning',
        'report': 'info'
      }
      return types[category] || 'info'
    },
    getTemplateIcon(category) {
      return this.categoryIcons[category] || 'el-icon-document'
    },
    handleSizeChange(val) {
      this.pageSize = val
      this.loadTemplates()
    },
    handleCurrentChange(val) {
      this.currentPage = val
      this.loadTemplates()
    }
  }
}
</script>

<style scoped>
.template-manager-container {
  padding: 20px;
}

.action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 15px;
  background: white;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.search-bar {
  display: flex;
  align-items: center;
}

.template-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
  height: 200px;
}

.template-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.template-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.template-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #409EFF;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 18px;
}

.template-actions {
  cursor: pointer;
}

.el-dropdown-link {
  cursor: pointer;
  color: #909399;
}

.template-content {
  height: 130px;
  display: flex;
  flex-direction: column;
}

.template-title {
  margin: 0 0 8px 0;
  color: #303133;
  font-size: 16px;
  font-weight: bold;
}

.template-description {
  margin: 0 0 15px 0;
  color: #606266;
  font-size: 12px;
  line-height: 1.4;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.template-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.template-usage {
  font-size: 11px;
  color: #909399;
}

.template-info {
  display: flex;
  justify-content: space-between;
  font-size: 11px;
  color: #C0C4CC;
}

.pagination-section {
  text-align: center;
  margin-top: 30px;
}

.template-detail-content {
  margin: 20px 0;
}

.template-detail-content h4 {
  margin: 20px 0 10px 0;
  color: #303133;
}

.template-preview {
  background: #f5f5f5;
  padding: 15px;
  border-radius: 4px;
  border: 1px solid #e4e7ed;
  max-height: 300px;
  overflow-y: auto;
}

.dialog-actions {
  text-align: center;
  margin-top: 20px;
}

.dialog-footer {
  text-align: right;
}
</style>