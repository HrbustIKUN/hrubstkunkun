<template>
  <div class="work-statistics">
    <!-- 统计概览卡片 -->
    <el-row :gutter="24" class="stats-overview">
      <el-col :span="6" :xs="12">
        <div class="stat-card attendance">
          <div class="stat-icon">
            <i class="el-icon-time"></i>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ attendanceData.rate }}%</div>
            <div class="stat-label">出勤率</div>
          </div>
        </div>
      </el-col>
      
      <el-col :span="6" :xs="12">
        <div class="stat-card projects">
          <div class="stat-icon">
            <i class="el-icon-folder-opened"></i>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ projectData.completed }}</div>
            <div class="stat-label">完成项目</div>
          </div>
        </div>
      </el-col>
      
      <el-col :span="6" :xs="12">
        <div class="stat-card performance">
          <div class="stat-icon">
            <i class="el-icon-trophy"></i>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ performanceData.score }}</div>
            <div class="stat-label">绩效评分</div>
          </div>
        </div>
      </el-col>
      
      <el-col :span="6" :xs="12">
        <div class="stat-card overtime">
          <div class="stat-icon">
            <i class="el-icon-moon"></i>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ overtimeData.hours }}h</div>
            <div class="stat-label">本月加班</div>
          </div>
        </div>
      </el-col>
    </el-row>
    
    <!-- 图表区域 -->
    <el-row :gutter="24" class="charts-section">
      <el-col :span="12">
        <el-card class="chart-card" shadow="hover">
          <div slot="header" class="card-header">
            <span><i class="el-icon-data-line"></i> 月度出勤趋势</span>
            <el-select v-model="selectedYear" size="small" style="width: 100px">
              <el-option label="2024" value="2024"></el-option>
              <el-option label="2023" value="2023"></el-option>
            </el-select>
          </div>
          <div class="chart-container" ref="attendanceChart"></div>
        </el-card>
      </el-col>
      
      <el-col :span="12">
        <el-card class="chart-card" shadow="hover">
          <div slot="header" class="card-header">
            <span><i class="el-icon-pie-chart"></i> 工作时间分布</span>
          </div>
          <div class="chart-container" ref="workTimeChart"></div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 详细数据表格 -->
    <el-card class="table-card" shadow="hover">
      <div slot="header" class="card-header">
        <span><i class="el-icon-document"></i> 近期工作记录</span>
        <el-button type="text" @click="exportData">
          <i class="el-icon-download"></i>
          导出数据
        </el-button>
      </div>
      
      <el-table :data="workRecords" stripe style="width: 100%">
        <el-table-column prop="date" label="日期" width="120">
          <template slot-scope="scope">
            {{ formatDate(scope.row.date) }}
          </template>
        </el-table-column>
        <el-table-column prop="checkIn" label="签到时间" width="120"></el-table-column>
        <el-table-column prop="checkOut" label="签退时间" width="120"></el-table-column>
        <el-table-column prop="workHours" label="工作时长" width="100">
          <template slot-scope="scope">
            {{ scope.row.workHours }}h
          </template>
        </el-table-column>
        <el-table-column prop="overtime" label="加班时长" width="100">
          <template slot-scope="scope">
            <span :class="{ 'overtime-text': scope.row.overtime > 0 }">
              {{ scope.row.overtime }}h
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)" size="small">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" show-overflow-tooltip></el-table-column>
      </el-table>
      
      <div class="pagination-wrapper">
        <el-pagination
          @current-change="handlePageChange"
          :current-page="currentPage"
          :page-size="pageSize"
          layout="total, prev, pager, next"
          :total="totalRecords"
        >
        </el-pagination>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'WorkStatistics',
  data() {
    return {
      selectedYear: '2024',
      currentPage: 1,
      pageSize: 10,
      totalRecords: 50,
      
      // 统计数据
      attendanceData: {
        rate: 95
      },
      projectData: {
        completed: 12
      },
      performanceData: {
        score: 4.8
      },
      overtimeData: {
        hours: 24
      },
      
      // 工作记录
      workRecords: [
        {
          date: '2024-01-15',
          checkIn: '09:00',
          checkOut: '18:30',
          workHours: 8.5,
          overtime: 0.5,
          status: '正常',
          remark: '完成项目需求分析'
        },
        {
          date: '2024-01-14',
          checkIn: '08:55',
          checkOut: '18:00',
          workHours: 8.0,
          overtime: 0,
          status: '正常',
          remark: '参与团队会议'
        },
        {
          date: '2024-01-13',
          checkIn: '09:10',
          checkOut: '19:00',
          workHours: 8.8,
          overtime: 1.0,
          status: '迟到',
          remark: '处理紧急bug修复'
        },
        {
          date: '2024-01-12',
          checkIn: '09:00',
          checkOut: '18:00',
          workHours: 8.0,
          overtime: 0,
          status: '正常',
          remark: '代码review和优化'
        },
        {
          date: '2024-01-11',
          checkIn: '08:50',
          checkOut: '20:30',
          workHours: 10.7,
          overtime: 2.5,
          status: '正常',
          remark: '项目上线部署'
        }
      ]
    }
  },
  
  mounted() {
    this.initCharts()
  },
  
  methods: {
    initCharts() {
      // 这里可以集成图表库如ECharts
      // 由于没有引入图表库，这里只是占位
      console.log('初始化图表')
    },
    
    formatDate(date) {
      return new Date(date).toLocaleDateString('zh-CN')
    },
    
    getStatusType(status) {
      const statusMap = {
        '正常': 'success',
        '迟到': 'warning',
        '早退': 'warning',
        '缺勤': 'danger'
      }
      return statusMap[status] || 'info'
    },
    
    handlePageChange(page) {
      this.currentPage = page
      // 这里可以调用API获取对应页面的数据
    },
    
    exportData() {
      this.$message.success('数据导出功能开发中...')
    }
  }
}
</script>

<style lang="scss" scoped>
.work-statistics {
  .stats-overview {
    margin-bottom: 24px;
    
    .stat-card {
      background: white;
      border-radius: 12px;
      padding: 24px;
      display: flex;
      align-items: center;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease;
      
      &:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
      }
      
      .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        margin-right: 16px;
      }
      
      .stat-content {
        .stat-number {
          font-size: 28px;
          font-weight: 700;
          margin-bottom: 4px;
        }
        
        .stat-label {
          font-size: 14px;
          color: #666;
          font-weight: 500;
        }
      }
      
      &.attendance {
        .stat-icon {
          background: linear-gradient(135deg, #667eea, #764ba2);
          color: white;
        }
        .stat-number {
          color: #667eea;
        }
      }
      
      &.projects {
        .stat-icon {
          background: linear-gradient(135deg, #f093fb, #f5576c);
          color: white;
        }
        .stat-number {
          color: #f5576c;
        }
      }
      
      &.performance {
        .stat-icon {
          background: linear-gradient(135deg, #4facfe, #00f2fe);
          color: white;
        }
        .stat-number {
          color: #4facfe;
        }
      }
      
      &.overtime {
        .stat-icon {
          background: linear-gradient(135deg, #43e97b, #38f9d7);
          color: white;
        }
        .stat-number {
          color: #43e97b;
        }
      }
    }
  }
  
  .charts-section {
    margin-bottom: 24px;
    
    .chart-card {
      border-radius: 12px;
      overflow: hidden;
      
      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 600;
        
        i {
          margin-right: 8px;
          color: #667eea;
        }
      }
      
      .chart-container {
        height: 300px;
        background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #666;
        font-size: 16px;
        
        &::before {
          content: '图表区域 (可集成ECharts)';
        }
      }
    }
  }
  
  .table-card {
    border-radius: 12px;
    overflow: hidden;
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 600;
      
      i {
        margin-right: 8px;
        color: #667eea;
      }
    }
    
    .overtime-text {
      color: #f56c6c;
      font-weight: 600;
    }
    
    .pagination-wrapper {
      margin-top: 20px;
      text-align: center;
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .work-statistics {
    .stats-overview {
      .stat-card {
        margin-bottom: 16px;
        padding: 16px;
        
        .stat-icon {
          width: 48px;
          height: 48px;
          font-size: 20px;
          margin-right: 12px;
        }
        
        .stat-content {
          .stat-number {
            font-size: 24px;
          }
        }
      }
    }
    
    .charts-section {
      .el-col {
        margin-bottom: 16px;
      }
      
      .chart-container {
        height: 250px;
      }
    }
  }
}
</style>