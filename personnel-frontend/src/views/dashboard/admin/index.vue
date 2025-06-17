<template>
  <div class="dashboard-editor-container">
    <!-- 欢迎信息 -->
    <div class="welcome-section">
      <el-card class="welcome-card">
        <div class="welcome-content">
          <div class="welcome-text">
            <h2>欢迎回来，{{ userInfo.name || '管理员' }}！</h2>
            <p>今天是 {{ currentDate }}，祝您工作愉快！</p>
          </div>
          <div class="welcome-avatar">
            <el-avatar :size="60" :src="userInfo.photo" icon="el-icon-user-solid"></el-avatar>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 数据统计面板 -->
    <panel-group @handleSetLineChartData="handleSetLineChartData" />

    <!-- 图表和快捷操作区域 -->
    <el-row :gutter="32" class="chart-section">
      <el-col :xs="24" :sm="24" :md="16" :lg="16" :xl="16">
        <div class="chart-wrapper">
          <line-chart :chart-data="lineChartData" />
        </div>
      </el-col>
      <el-col :xs="24" :sm="24" :md="8" :lg="8" :xl="8">
        <!-- 快捷操作 -->
        <el-card class="quick-actions">
          <div slot="header" class="clearfix">
            <span class="card-title">快捷操作</span>
          </div>
          <div class="action-grid">
            <div class="action-item" @click="navigateTo('/permissions/saveClerk')">
          <i class="el-icon-plus"></i>
          <span>添加员工</span>
        </div>
            <div class="action-item" @click="navigateTo('/clerk')">
              <i class="el-icon-user"></i>
              <span>员工管理</span>
            </div>
            <div class="action-item" @click="navigateTo('/department')">
              <i class="el-icon-office-building"></i>
              <span>部门管理</span>
            </div>
            <div class="action-item" @click="navigateTo('/attendance')">
              <i class="el-icon-time"></i>
              <span>考勤管理</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 最新动态和统计图表 -->
    <el-row :gutter="32" class="bottom-section">
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12">
        <el-card class="recent-activities">
          <div slot="header" class="clearfix">
            <span class="card-title">最新动态</span>
          </div>
          <div class="activity-list">
            <div class="activity-item" v-for="(activity, index) in recentActivities" :key="index">
              <div class="activity-icon">
                <i :class="activity.icon"></i>
              </div>
              <div class="activity-content">
                <div class="activity-title">{{ activity.title }}</div>
                <div class="activity-time">{{ activity.time }}</div>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12">
        <div class="chart-wrapper">
          <pie-chart />
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import GithubCorner from '@/components/GithubCorner'
import PanelGroup from './components/PanelGroup'
import LineChart from './components/LineChart'
import RaddarChart from './components/RaddarChart'
import PieChart from './components/PieChart'
import BarChart from './components/BarChart'
import TodoList from './components/TodoList'
import BoxCard from './components/BoxCard'

const lineChartData = {
  newVisitis: {
    expectedData: [100, 120, 161, 134, 105, 160, 165],
    actualData: [120, 82, 91, 154, 162, 140, 145]
  },
  messages: {
    expectedData: [200, 192, 120, 144, 160, 130, 140],
    actualData: [180, 160, 151, 106, 145, 150, 130]
  },
  purchases: {
    expectedData: [80, 100, 121, 104, 105, 90, 100],
    actualData: [120, 90, 100, 138, 142, 130, 130]
  },
  shoppings: {
    expectedData: [130, 140, 141, 142, 145, 150, 160],
    actualData: [120, 82, 91, 154, 162, 140, 130]
  }
}

export default {
  name: 'DashboardAdmin',
  components: {
    GithubCorner,
    PanelGroup,
    LineChart,
    RaddarChart,
    PieChart,
    BarChart,
    TodoList,
    BoxCard
  },
  data() {
    return {
      lineChartData: lineChartData.newVisitis,
      userInfo: {
        name: '',
        photo: ''
      },
      currentDate: '',
      recentActivities: [
        {
          icon: 'el-icon-user-solid',
          title: '新员工张三入职技术部',
          time: '2小时前'
        },
        {
          icon: 'el-icon-time',
          title: '考勤统计已更新',
          time: '4小时前'
        },
        {
          icon: 'el-icon-document',
          title: '部门会议纪要已发布',
          time: '6小时前'
        },
        {
          icon: 'el-icon-star-on',
          title: '李四获得本月优秀员工',
          time: '1天前'
        },
        {
          icon: 'el-icon-office-building',
          title: '新增市场部门',
          time: '2天前'
        }
      ]
    }
  },
  mounted() {
    this.initUserInfo()
    this.updateCurrentDate()
  },
  methods: {
    handleSetLineChartData(type) {
      this.lineChartData = lineChartData[type]
    },
    
    initUserInfo() {
      // 从localStorage或vuex获取用户信息
      const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
      this.userInfo = {
        name: userInfo.name || '管理员',
        photo: userInfo.photo || ''
      }
    },
    
    updateCurrentDate() {
      const now = new Date()
      const options = {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        weekday: 'long'
      }
      this.currentDate = now.toLocaleDateString('zh-CN', options)
    },
    
    navigateTo(path) {
      this.$router.push(path)
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-editor-container {
  padding: 24px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);
  position: relative;

  .github-corner {
    position: absolute;
    top: 0px;
    border: 0;
    right: 0;
  }

  // 欢迎区域样式
  .welcome-section {
    margin-bottom: 24px;
    
    .welcome-card {
      border-radius: 12px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
      
      .welcome-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 8px 0;
        
        .welcome-text {
          h2 {
            margin: 0 0 8px 0;
            color: #303133;
            font-size: 24px;
            font-weight: 600;
          }
          
          p {
            margin: 0;
            color: #909399;
            font-size: 14px;
          }
        }
        
        .welcome-avatar {
          .el-avatar {
            border: 3px solid #e4e7ed;
          }
        }
      }
    }
  }

  // 图表区域样式
  .chart-section {
    margin-bottom: 24px;
  }

  .chart-wrapper {
    background: #fff;
    padding: 20px;
    margin-bottom: 24px;
    border-radius: 12px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  }

  // 快捷操作样式
  .quick-actions {
    height: 100%;
    border-radius: 12px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
    
    .card-title {
      font-weight: 600;
      color: #303133;
    }
    
    .action-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      
      .action-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 20px 16px;
        background: #f8f9fa;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
        
        &:hover {
          background: #e3f2fd;
          transform: translateY(-2px);
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        i {
          font-size: 24px;
          color: #409eff;
          margin-bottom: 8px;
        }
        
        span {
          font-size: 14px;
          color: #606266;
          font-weight: 500;
        }
      }
    }
  }

  // 底部区域样式
  .bottom-section {
    .recent-activities {
      border-radius: 12px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
      
      .card-title {
        font-weight: 600;
        color: #303133;
      }
      
      .activity-list {
        .activity-item {
          display: flex;
          align-items: center;
          padding: 12px 0;
          border-bottom: 1px solid #f0f0f0;
          
          &:last-child {
            border-bottom: none;
          }
          
          .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e3f2fd;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            
            i {
              color: #409eff;
              font-size: 16px;
            }
          }
          
          .activity-content {
            flex: 1;
            
            .activity-title {
              font-size: 14px;
              color: #303133;
              margin-bottom: 4px;
            }
            
            .activity-time {
              font-size: 12px;
              color: #909399;
            }
          }
        }
      }
    }
  }
}

@media (max-width: 1024px) {
  .dashboard-editor-container {
    padding: 16px;
    
    .chart-wrapper {
      padding: 16px;
    }
    
    .welcome-section .welcome-card .welcome-content {
      flex-direction: column;
      text-align: center;
      
      .welcome-text {
        margin-bottom: 16px;
      }
    }
    
    .quick-actions .action-grid {
      grid-template-columns: 1fr;
    }
  }
}

@media (max-width: 768px) {
  .dashboard-editor-container {
    padding: 12px;
    
    .chart-section,
    .bottom-section {
      .el-col {
        margin-bottom: 16px;
      }
    }
  }
}
</style>
