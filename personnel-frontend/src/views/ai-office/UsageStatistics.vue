<template>
  <div class="usage-statistics-container">
    <!-- 统计概览 -->
    <div class="overview-section">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon total">
                <i class="el-icon-data-analysis"></i>
              </div>
              <div class="stat-info">
                <div class="stat-number">{{ totalUsage }}</div>
                <div class="stat-label">总使用次数</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon today">
                <i class="el-icon-calendar-today"></i>
              </div>
              <div class="stat-info">
                <div class="stat-number">{{ todayUsage }}</div>
                <div class="stat-label">今日使用</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon users">
                <i class="el-icon-user"></i>
              </div>
              <div class="stat-info">
                <div class="stat-number">{{ activeUsers }}</div>
                <div class="stat-label">活跃用户</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon popular">
                <i class="el-icon-star-on"></i>
              </div>
              <div class="stat-info">
                <div class="stat-number">{{ popularFunction }}</div>
                <div class="stat-label">热门功能</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
    
    <!-- 筛选条件 -->
    <div class="filter-section">
      <el-card>
        <div class="filter-content">
          <el-form :inline="true" :model="filterForm">
            <el-form-item label="时间范围">
              <el-date-picker
                v-model="filterForm.dateRange"
                type="daterange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                @change="handleDateChange"
              />
            </el-form-item>
            
            <el-form-item label="功能类型">
              <el-select v-model="filterForm.functionType" placeholder="选择功能" @change="handleFilterChange">
                <el-option label="全部" value="" />
                <el-option label="文档生成" value="document" />
                <el-option label="邮件生成" value="email" />
                <el-option label="数据分析" value="analysis" />
                <el-option label="智能问答" value="qa" />
                <el-option label="会议纪要" value="meeting" />
                <el-option label="工作计划" value="plan" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="部门">
              <el-select v-model="filterForm.department" placeholder="选择部门" @change="handleFilterChange">
                <el-option label="全部" value="" />
                <el-option label="技术部" value="tech" />
                <el-option label="市场部" value="marketing" />
                <el-option label="人事部" value="hr" />
                <el-option label="财务部" value="finance" />
              </el-select>
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="refreshData">刷新数据</el-button>
              <el-button @click="exportReport">导出报告</el-button>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
    </div>
    
    <!-- 图表展示 -->
    <el-row :gutter="20">
      <!-- 使用趋势图 -->
      <el-col :span="12">
        <el-card>
          <div slot="header">
            <span>使用趋势</span>
          </div>
          <div id="usageTrendChart" style="height: 300px;"></div>
        </el-card>
      </el-col>
      
      <!-- 功能分布图 -->
      <el-col :span="12">
        <el-card>
          <div slot="header">
            <span>功能使用分布</span>
          </div>
          <div id="functionDistributionChart" style="height: 300px;"></div>
        </el-card>
      </el-col>
    </el-row>
    
    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 部门使用统计 -->
      <el-col :span="12">
        <el-card>
          <div slot="header">
            <span>部门使用统计</span>
          </div>
          <div id="departmentUsageChart" style="height: 300px;"></div>
        </el-card>
      </el-col>
      
      <!-- 用户活跃度 -->
      <el-col :span="12">
        <el-card>
          <div slot="header">
            <span>用户活跃度</span>
          </div>
          <div id="userActivityChart" style="height: 300px;"></div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 详细数据表格 -->
    <el-card style="margin-top: 20px;">
      <div slot="header">
        <span>详细使用记录</span>
      </div>
      
      <el-table :data="usageRecords" stripe style="width: 100%">
        <el-table-column prop="date" label="日期" width="120" />
        <el-table-column prop="user" label="用户" width="120" />
        <el-table-column prop="department" label="部门" width="100" />
        <el-table-column prop="function" label="功能" width="120" />
        <el-table-column prop="count" label="使用次数" width="100" />
        <el-table-column prop="duration" label="使用时长" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === '成功' ? 'success' : 'danger'">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template slot-scope="scope">
            <el-button size="mini" @click="viewDetail(scope.row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination-section">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
        />
      </div>
    </el-card>
    
    <!-- 排行榜 -->
    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="8">
        <el-card>
          <div slot="header">
            <span>功能使用排行</span>
          </div>
          <div class="ranking-list">
            <div v-for="(item, index) in functionRanking" :key="index" class="ranking-item">
              <div class="ranking-number" :class="getRankingClass(index)">{{ index + 1 }}</div>
              <div class="ranking-content">
                <div class="ranking-name">{{ item.name }}</div>
                <div class="ranking-count">{{ item.count }} 次</div>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="8">
        <el-card>
          <div slot="header">
            <span>用户使用排行</span>
          </div>
          <div class="ranking-list">
            <div v-for="(item, index) in userRanking" :key="index" class="ranking-item">
              <div class="ranking-number" :class="getRankingClass(index)">{{ index + 1 }}</div>
              <div class="ranking-content">
                <div class="ranking-name">{{ item.name }}</div>
                <div class="ranking-count">{{ item.count }} 次</div>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="8">
        <el-card>
          <div slot="header">
            <span>部门使用排行</span>
          </div>
          <div class="ranking-list">
            <div v-for="(item, index) in departmentRanking" :key="index" class="ranking-item">
              <div class="ranking-number" :class="getRankingClass(index)">{{ index + 1 }}</div>
              <div class="ranking-content">
                <div class="ranking-name">{{ item.name }}</div>
                <div class="ranking-count">{{ item.count }} 次</div>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'UsageStatistics',
  data() {
    return {
      totalUsage: 1256,
      todayUsage: 89,
      activeUsers: 45,
      popularFunction: '文档生成',
      currentPage: 1,
      pageSize: 10,
      total: 0,
      filterForm: {
        dateRange: [],
        functionType: '',
        department: ''
      },
      usageRecords: [
        {
          date: '2024-01-15',
          user: '张三',
          department: '技术部',
          function: '文档生成',
          count: 5,
          duration: '25分钟',
          status: '成功'
        },
        {
          date: '2024-01-15',
          user: '李四',
          department: '市场部',
          function: '邮件生成',
          count: 3,
          duration: '15分钟',
          status: '成功'
        },
        {
          date: '2024-01-15',
          user: '王五',
          department: '人事部',
          function: '数据分析',
          count: 2,
          duration: '30分钟',
          status: '失败'
        },
        {
          date: '2024-01-14',
          user: '赵六',
          department: '财务部',
          function: '智能问答',
          count: 8,
          duration: '45分钟',
          status: '成功'
        },
        {
          date: '2024-01-14',
          user: '钱七',
          department: '技术部',
          function: '会议纪要',
          count: 4,
          duration: '20分钟',
          status: '成功'
        }
      ],
      functionRanking: [
        { name: '文档生成', count: 456 },
        { name: '智能问答', count: 389 },
        { name: '邮件生成', count: 234 },
        { name: '数据分析', count: 178 },
        { name: '会议纪要', count: 123 }
      ],
      userRanking: [
        { name: '张三', count: 89 },
        { name: '李四', count: 76 },
        { name: '王五', count: 65 },
        { name: '赵六', count: 54 },
        { name: '钱七', count: 43 }
      ],
      departmentRanking: [
        { name: '技术部', count: 345 },
        { name: '市场部', count: 289 },
        { name: '人事部', count: 234 },
        { name: '财务部', count: 178 }
      ]
    }
  },
  mounted() {
    this.loadData()
    this.initCharts()
  },
  methods: {
    loadData() {
      this.total = this.usageRecords.length
    },
    initCharts() {
      // 这里应该使用 ECharts 或其他图表库来初始化图表
      // 由于没有引入图表库，这里只是占位
      console.log('初始化图表')
    },
    handleDateChange() {
      this.refreshData()
    },
    handleFilterChange() {
      this.refreshData()
    },
    refreshData() {
      // 根据筛选条件刷新数据
      this.$message.success('数据已刷新')
    },
    exportReport() {
      this.$message.success('报告导出成功')
    },
    viewDetail(row) {
      this.$message.info(`查看 ${row.user} 的详细记录`)
    },
    handleSizeChange(val) {
      this.pageSize = val
      this.loadData()
    },
    handleCurrentChange(val) {
      this.currentPage = val
      this.loadData()
    },
    getRankingClass(index) {
      if (index === 0) return 'first'
      if (index === 1) return 'second'
      if (index === 2) return 'third'
      return ''
    }
  }
}
</script>

<style scoped>
.usage-statistics-container {
  padding: 20px;
}

.overview-section {
  margin-bottom: 20px;
}

.stat-card {
  height: 120px;
}

.stat-content {
  display: flex;
  align-items: center;
  height: 100%;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  margin-right: 20px;
}

.stat-icon.total {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.stat-icon.today {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stat-icon.users {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-icon.popular {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stat-info {
  flex: 1;
}

.stat-number {
  font-size: 32px;
  font-weight: bold;
  color: #303133;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 5px;
}

.filter-section {
  margin-bottom: 20px;
}

.filter-content {
  padding: 10px 0;
}

.pagination-section {
  text-align: center;
  margin-top: 20px;
}

.ranking-list {
  max-height: 300px;
  overflow-y: auto;
}

.ranking-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.ranking-item:last-child {
  border-bottom: none;
}

.ranking-number {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  margin-right: 15px;
  background: #f5f5f5;
  color: #666;
}

.ranking-number.first {
  background: #ffd700;
  color: white;
}

.ranking-number.second {
  background: #c0c0c0;
  color: white;
}

.ranking-number.third {
  background: #cd7f32;
  color: white;
}

.ranking-content {
  flex: 1;
}

.ranking-name {
  font-size: 14px;
  color: #303133;
  margin-bottom: 2px;
}

.ranking-count {
  font-size: 12px;
  color: #909399;
}
</style>