<template>
  <div class="work-plan-container">
    <!-- 操作栏 -->
    <div class="action-bar">
      <el-button type="primary" @click="createPlan">新建计划</el-button>
      <el-button @click="importPlan">导入计划</el-button>
      <el-button @click="exportPlans">批量导出</el-button>
      
      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索计划"
          prefix-icon="el-icon-search"
          @input="handleSearch"
          style="width: 300px;"
        />
        <el-select v-model="selectedStatus" placeholder="状态筛选" @change="handleFilter" style="width: 120px; margin-left: 10px;">
          <el-option label="全部" value="" />
          <el-option label="进行中" value="ongoing" />
          <el-option label="已完成" value="completed" />
          <el-option label="已延期" value="overdue" />
          <el-option label="未开始" value="pending" />
        </el-select>
      </div>
    </div>
    
    <!-- 计划生成表单 -->
    <el-card v-if="showCreateForm" style="margin-bottom: 20px;">
      <div slot="header">
        <span>AI 工作计划生成</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="showCreateForm = false">收起</el-button>
      </div>
      
      <el-form ref="planForm" :model="planForm" :rules="planRules" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="计划标题" prop="title">
              <el-input v-model="planForm.title" placeholder="请输入计划标题" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="计划类型" prop="type">
              <el-select v-model="planForm.type" placeholder="选择计划类型">
                <el-option label="日计划" value="daily" />
                <el-option label="周计划" value="weekly" />
                <el-option label="月计划" value="monthly" />
                <el-option label="项目计划" value="project" />
                <el-option label="年度计划" value="yearly" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="开始时间" prop="startDate">
              <el-date-picker
                v-model="planForm.startDate"
                type="date"
                placeholder="选择开始时间"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束时间" prop="endDate">
              <el-date-picker
                v-model="planForm.endDate"
                type="date"
                placeholder="选择结束时间"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="计划目标" prop="objectives">
          <el-input
            v-model="planForm.objectives"
            type="textarea"
            :rows="3"
            placeholder="请描述计划的主要目标和期望成果"
          />
        </el-form-item>
        
        <el-form-item label="工作重点">
          <el-input
            v-model="planForm.priorities"
            type="textarea"
            :rows="2"
            placeholder="请列出工作重点和关键任务"
          />
        </el-form-item>
        
        <el-form-item label="资源需求">
          <el-input
            v-model="planForm.resources"
            type="textarea"
            :rows="2"
            placeholder="请描述所需的人力、物力、财力等资源"
          />
        </el-form-item>
        
        <el-form-item label="风险预估">
          <el-input
            v-model="planForm.risks"
            type="textarea"
            :rows="2"
            placeholder="请列出可能遇到的风险和挑战"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="generatePlan" :loading="generating">AI 生成计划</el-button>
          <el-button @click="resetForm">重置</el-button>
          <el-button @click="showCreateForm = false">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    
    <!-- 生成结果 -->
    <el-card v-if="generatedPlan" style="margin-bottom: 20px;">
      <div slot="header">
        <span>AI 生成的工作计划</span>
        <div style="float: right;">
          <el-button size="small" @click="editGeneratedPlan">编辑</el-button>
          <el-button size="small" type="primary" @click="savePlan">保存计划</el-button>
          <el-button size="small" @click="regeneratePlan">重新生成</el-button>
        </div>
      </div>
      
      <div class="generated-content">
        <div v-html="generatedPlan"></div>
      </div>
    </el-card>
    
    <!-- 计划列表 -->
    <el-card>
      <div slot="header">
        <span>我的工作计划</span>
      </div>
      
      <el-table :data="filteredPlans" stripe style="width: 100%">
        <el-table-column prop="title" label="计划标题" min-width="200">
          <template slot-scope="scope">
            <el-link @click="viewPlan(scope.row)" :underline="false">
              {{ scope.row.title }}
            </el-link>
          </template>
        </el-table-column>
        
        <el-table-column prop="type" label="类型" width="100">
          <template slot-scope="scope">
            <el-tag :type="getTypeColor(scope.row.type)" size="small">
              {{ getTypeLabel(scope.row.type) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="startDate" label="开始时间" width="120" />
        <el-table-column prop="endDate" label="结束时间" width="120" />
        
        <el-table-column prop="progress" label="进度" width="120">
          <template slot-scope="scope">
            <el-progress :percentage="scope.row.progress" :stroke-width="6" />
          </template>
        </el-table-column>
        
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusColor(scope.row.status)" size="small">
              {{ getStatusLabel(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="priority" label="优先级" width="100">
          <template slot-scope="scope">
            <el-tag :type="getPriorityColor(scope.row.priority)" size="small">
              {{ getPriorityLabel(scope.row.priority) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="200">
          <template slot-scope="scope">
            <el-button size="mini" @click="viewPlan(scope.row)">查看</el-button>
            <el-button size="mini" @click="editPlan(scope.row)">编辑</el-button>
            <el-button size="mini" @click="updateProgress(scope.row)">更新进度</el-button>
            <el-dropdown @command="handleCommand" trigger="click">
              <el-button size="mini">
                更多<i class="el-icon-arrow-down el-icon--right"></i>
              </el-button>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item :command="{action: 'copy', plan: scope.row}">复制</el-dropdown-item>
                <el-dropdown-item :command="{action: 'export', plan: scope.row}">导出</el-dropdown-item>
                <el-dropdown-item :command="{action: 'archive', plan: scope.row}" divided>归档</el-dropdown-item>
                <el-dropdown-item :command="{action: 'delete', plan: scope.row}">删除</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination-section">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[10, 20, 50]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
        />
      </div>
    </el-card>
    
    <!-- 计划详情对话框 -->
    <el-dialog title="计划详情" :visible.sync="detailDialogVisible" width="70%">
      <div v-if="selectedPlan">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="计划标题">{{ selectedPlan.title }}</el-descriptions-item>
          <el-descriptions-item label="计划类型">{{ getTypeLabel(selectedPlan.type) }}</el-descriptions-item>
          <el-descriptions-item label="开始时间">{{ selectedPlan.startDate }}</el-descriptions-item>
          <el-descriptions-item label="结束时间">{{ selectedPlan.endDate }}</el-descriptions-item>
          <el-descriptions-item label="当前进度">{{ selectedPlan.progress }}%</el-descriptions-item>
          <el-descriptions-item label="计划状态">{{ getStatusLabel(selectedPlan.status) }}</el-descriptions-item>
          <el-descriptions-item label="优先级">{{ getPriorityLabel(selectedPlan.priority) }}</el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ selectedPlan.createdAt }}</el-descriptions-item>
        </el-descriptions>
        
        <div class="plan-detail-content">
          <h4>计划目标</h4>
          <p>{{ selectedPlan.objectives }}</p>
          
          <h4>详细内容</h4>
          <div class="plan-content" v-html="selectedPlan.content"></div>
          
          <h4>执行记录</h4>
          <el-timeline>
            <el-timeline-item
              v-for="(record, index) in selectedPlan.records"
              :key="index"
              :timestamp="record.date"
              :type="record.type"
            >
              {{ record.content }}
            </el-timeline-item>
          </el-timeline>
        </div>
      </div>
    </el-dialog>
    
    <!-- 进度更新对话框 -->
    <el-dialog title="更新进度" :visible.sync="progressDialogVisible" width="40%">
      <el-form :model="progressForm" label-width="100px">
        <el-form-item label="当前进度">
          <el-slider v-model="progressForm.progress" :max="100" show-input />
        </el-form-item>
        
        <el-form-item label="进度说明">
          <el-input
            v-model="progressForm.description"
            type="textarea"
            :rows="3"
            placeholder="请描述当前进度和完成情况"
          />
        </el-form-item>
        
        <el-form-item label="遇到问题">
          <el-input
            v-model="progressForm.issues"
            type="textarea"
            :rows="2"
            placeholder="请描述遇到的问题和困难"
          />
        </el-form-item>
        
        <el-form-item label="下步计划">
          <el-input
            v-model="progressForm.nextSteps"
            type="textarea"
            :rows="2"
            placeholder="请描述下一步的工作计划"
          />
        </el-form-item>
      </el-form>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="progressDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveProgress">保存</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WorkPlan',
  data() {
    return {
      showCreateForm: false,
      generating: false,
      searchKeyword: '',
      selectedStatus: '',
      currentPage: 1,
      pageSize: 10,
      total: 0,
      detailDialogVisible: false,
      progressDialogVisible: false,
      selectedPlan: null,
      generatedPlan: '',
      planForm: {
        title: '',
        type: '',
        startDate: '',
        endDate: '',
        objectives: '',
        priorities: '',
        resources: '',
        risks: ''
      },
      planRules: {
        title: [{ required: true, message: '请输入计划标题', trigger: 'blur' }],
        type: [{ required: true, message: '请选择计划类型', trigger: 'change' }],
        startDate: [{ required: true, message: '请选择开始时间', trigger: 'change' }],
        endDate: [{ required: true, message: '请选择结束时间', trigger: 'change' }],
        objectives: [{ required: true, message: '请输入计划目标', trigger: 'blur' }]
      },
      progressForm: {
        progress: 0,
        description: '',
        issues: '',
        nextSteps: ''
      },
      plans: [
        {
          id: 1,
          title: 'Q1季度产品开发计划',
          type: 'project',
          startDate: '2024-01-01',
          endDate: '2024-03-31',
          progress: 65,
          status: 'ongoing',
          priority: 'high',
          objectives: '完成新产品功能开发，提升用户体验',
          content: '<h3>主要任务</h3><ul><li>需求分析</li><li>原型设计</li><li>开发实现</li><li>测试验收</li></ul>',
          createdAt: '2024-01-01',
          records: [
            { date: '2024-01-15', type: 'primary', content: '完成需求分析和原型设计' },
            { date: '2024-02-01', type: 'success', content: '开发进度达到50%' },
            { date: '2024-02-15', type: 'warning', content: '遇到技术难题，进度略有延迟' }
          ]
        },
        {
          id: 2,
          title: '本周工作计划',
          type: 'weekly',
          startDate: '2024-01-15',
          endDate: '2024-01-21',
          progress: 80,
          status: 'ongoing',
          priority: 'medium',
          objectives: '完成本周既定工作任务',
          content: '<h3>本周任务</h3><ul><li>代码审查</li><li>文档编写</li><li>会议参与</li></ul>',
          createdAt: '2024-01-15',
          records: [
            { date: '2024-01-16', type: 'success', content: '完成代码审查任务' },
            { date: '2024-01-18', type: 'primary', content: '参加项目评审会议' }
          ]
        },
        {
          id: 3,
          title: '年度培训计划',
          type: 'yearly',
          startDate: '2024-01-01',
          endDate: '2024-12-31',
          progress: 25,
          status: 'ongoing',
          priority: 'low',
          objectives: '提升团队技能水平',
          content: '<h3>培训内容</h3><ul><li>技术培训</li><li>管理培训</li><li>外部培训</li></ul>',
          createdAt: '2024-01-01',
          records: [
            { date: '2024-01-10', type: 'success', content: '完成第一季度培训计划制定' }
          ]
        }
      ],
      filteredPlans: []
    }
  },
  mounted() {
    this.loadPlans()
  },
  methods: {
    loadPlans() {
      this.filteredPlans = [...this.plans]
      this.total = this.plans.length
    },
    createPlan() {
      this.showCreateForm = true
    },
    generatePlan() {
      this.$refs.planForm.validate((valid) => {
        if (valid) {
          this.generating = true
          // 模拟AI生成过程
          setTimeout(() => {
            this.generatedPlan = this.mockGeneratePlan()
            this.generating = false
            this.$message.success('计划生成成功')
          }, 2000)
        }
      })
    },
    mockGeneratePlan() {
      return `
        <h3>${this.planForm.title}</h3>
        <h4>一、计划概述</h4>
        <p><strong>计划类型：</strong>${this.getTypeLabel(this.planForm.type)}</p>
        <p><strong>执行时间：</strong>${this.planForm.startDate} 至 ${this.planForm.endDate}</p>
        <p><strong>主要目标：</strong>${this.planForm.objectives}</p>
        
        <h4>二、具体任务安排</h4>
        <ol>
          <li><strong>第一阶段：</strong>前期准备和资源配置</li>
          <li><strong>第二阶段：</strong>核心任务执行</li>
          <li><strong>第三阶段：</strong>总结评估和优化改进</li>
        </ol>
        
        <h4>三、资源配置</h4>
        <p>${this.planForm.resources || '根据实际需求配置相应资源'}</p>
        
        <h4>四、风险控制</h4>
        <p>${this.planForm.risks || '识别潜在风险并制定应对措施'}</p>
        
        <h4>五、成功指标</h4>
        <ul>
          <li>按时完成率达到90%以上</li>
          <li>质量标准符合预期要求</li>
          <li>资源利用率达到最优</li>
        </ul>
      `
    },
    savePlan() {
      const newPlan = {
        id: Date.now(),
        title: this.planForm.title,
        type: this.planForm.type,
        startDate: this.planForm.startDate,
        endDate: this.planForm.endDate,
        progress: 0,
        status: 'pending',
        priority: 'medium',
        objectives: this.planForm.objectives,
        content: this.generatedPlan,
        createdAt: new Date().toLocaleDateString(),
        records: []
      }
      
      this.plans.unshift(newPlan)
      this.loadPlans()
      this.resetForm()
      this.generatedPlan = ''
      this.showCreateForm = false
      this.$message.success('计划保存成功')
    },
    resetForm() {
      this.$refs.planForm.resetFields()
      this.generatedPlan = ''
    },
    editGeneratedPlan() {
      this.$message.info('编辑功能开发中')
    },
    regeneratePlan() {
      this.generatePlan()
    },
    viewPlan(plan) {
      this.selectedPlan = plan
      this.detailDialogVisible = true
    },
    editPlan(plan) {
      this.$message.info(`编辑计划: ${plan.title}`)
    },
    updateProgress(plan) {
      this.selectedPlan = plan
      this.progressForm.progress = plan.progress
      this.progressDialogVisible = true
    },
    saveProgress() {
      if (this.selectedPlan) {
        this.selectedPlan.progress = this.progressForm.progress
        
        // 更新状态
        if (this.progressForm.progress === 100) {
          this.selectedPlan.status = 'completed'
        } else if (this.progressForm.progress > 0) {
          this.selectedPlan.status = 'ongoing'
        }
        
        // 添加记录
        this.selectedPlan.records.push({
          date: new Date().toLocaleDateString(),
          type: 'primary',
          content: `进度更新至${this.progressForm.progress}%：${this.progressForm.description}`
        })
        
        this.progressDialogVisible = false
        this.$message.success('进度更新成功')
      }
    },
    handleCommand(command) {
      const { action, plan } = command
      switch (action) {
        case 'copy':
          this.copyPlan(plan)
          break
        case 'export':
          this.exportPlan(plan)
          break
        case 'archive':
          this.archivePlan(plan)
          break
        case 'delete':
          this.deletePlan(plan)
          break
      }
    },
    copyPlan(plan) {
      const newPlan = {
        ...plan,
        id: Date.now(),
        title: plan.title + ' (副本)',
        progress: 0,
        status: 'pending',
        createdAt: new Date().toLocaleDateString(),
        records: []
      }
      this.plans.unshift(newPlan)
      this.loadPlans()
      this.$message.success('计划复制成功')
    },
    exportPlan(plan) {
      this.$message.success(`导出计划: ${plan.title}`)
    },
    archivePlan(plan) {
      this.$message.success(`归档计划: ${plan.title}`)
    },
    deletePlan(plan) {
      this.$confirm(`确认删除计划 "${plan.title}"?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.plans = this.plans.filter(p => p.id !== plan.id)
        this.loadPlans()
        this.$message.success('删除成功')
      })
    },
    importPlan() {
      this.$message.success('导入计划成功')
    },
    exportPlans() {
      this.$message.success('批量导出成功')
    },
    handleSearch() {
      this.filterPlans()
    },
    handleFilter() {
      this.filterPlans()
    },
    filterPlans() {
      let filtered = [...this.plans]
      
      if (this.searchKeyword) {
        filtered = filtered.filter(plan => 
          plan.title.includes(this.searchKeyword) || 
          plan.objectives.includes(this.searchKeyword)
        )
      }
      
      if (this.selectedStatus) {
        filtered = filtered.filter(plan => plan.status === this.selectedStatus)
      }
      
      this.filteredPlans = filtered
      this.total = filtered.length
    },
    handleSizeChange(val) {
      this.pageSize = val
      this.loadPlans()
    },
    handleCurrentChange(val) {
      this.currentPage = val
      this.loadPlans()
    },
    getTypeLabel(type) {
      const labels = {
        'daily': '日计划',
        'weekly': '周计划',
        'monthly': '月计划',
        'project': '项目计划',
        'yearly': '年度计划'
      }
      return labels[type] || type
    },
    getTypeColor(type) {
      const colors = {
        'daily': 'success',
        'weekly': 'primary',
        'monthly': 'warning',
        'project': 'danger',
        'yearly': 'info'
      }
      return colors[type] || 'info'
    },
    getStatusLabel(status) {
      const labels = {
        'pending': '未开始',
        'ongoing': '进行中',
        'completed': '已完成',
        'overdue': '已延期'
      }
      return labels[status] || status
    },
    getStatusColor(status) {
      const colors = {
        'pending': 'info',
        'ongoing': 'primary',
        'completed': 'success',
        'overdue': 'danger'
      }
      return colors[status] || 'info'
    },
    getPriorityLabel(priority) {
      const labels = {
        'low': '低',
        'medium': '中',
        'high': '高'
      }
      return labels[priority] || priority
    },
    getPriorityColor(priority) {
      const colors = {
        'low': 'info',
        'medium': 'warning',
        'high': 'danger'
      }
      return colors[priority] || 'info'
    }
  }
}
</script>

<style scoped>
.work-plan-container {
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

.generated-content {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 4px;
  border: 1px solid #e4e7ed;
}

.pagination-section {
  text-align: center;
  margin-top: 20px;
}

.plan-detail-content {
  margin: 20px 0;
}

.plan-detail-content h4 {
  margin: 20px 0 10px 0;
  color: #303133;
}

.plan-content {
  background: #f5f5f5;
  padding: 15px;
  border-radius: 4px;
  border: 1px solid #e4e7ed;
}

.dialog-footer {
  text-align: right;
}
</style>