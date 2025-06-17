<template>
  <div class="modern-dashboard">
    <!-- 欢迎横幅 -->
    <div class="welcome-banner">
      <div class="banner-content">
        <div class="welcome-text">
          <h1>欢迎回来，{{ name }}</h1>
          <p>今天是 {{ currentDate }}，祝您工作愉快！</p>
        </div>
        <div class="weather-info" v-if="weatherData">
          <div class="weather-icon-wrapper">
            <i :class="getWeatherIcon(weatherData.weather)" class="weather-icon"></i>
          </div>
          <div class="weather-text">
            <span class="temperature">{{ weatherData.temperature }}°C</span>
            <span class="weather-desc">{{ weatherData.weather }}</span>
            <span class="location">{{ weatherData.province }} {{ weatherData.city }}</span>
            <span class="update-time">{{ formatTime(weatherData.reporttime) }}</span>
          </div>
        </div>
        <div class="weather-loading" v-else-if="weatherLoading">
          <i class="el-icon-loading"></i>
          <span>获取天气中...</span>
        </div>
        <div class="weather-info" v-else>
          <div class="weather-icon-wrapper">
            <i class="el-icon-cloudy weather-icon"></i>
          </div>
          <div class="weather-text">
            <span class="temperature">--°C</span>
            <span class="weather-desc">暂无数据</span>
            <span class="location">{{ province }} {{ city }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 数据统计卡片 -->
    <div class="stats-section">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="6" v-for="(stat, index) in filteredStatsData" :key="index">
          <div class="stat-card" :class="stat.class">
            <div class="stat-icon">
              <i :class="stat.icon"></i>
            </div>
            <div class="stat-content">
              <div class="stat-number">{{ stat.value }}</div>
              <div class="stat-label">{{ stat.label }}</div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 主要内容区域 -->
    <el-row :gutter="20" class="main-content">
      <!-- 左侧快捷操作 -->
      <el-col :xs="24" :lg="16">
        <div class="quick-actions">
          <div class="section-header">
            <h3>快捷操作</h3>
          </div>
          <div class="action-grid">
            <div 
              class="action-item" 
              :class="{ 'featured-action': action.featured }"
              v-for="(action, index) in quickActions" 
              :key="index"
              @click="handleQuickAction(action.route)"
            >
              <div class="action-icon" :style="{ backgroundColor: action.color }">
                <i :class="action.icon"></i>
                <div v-if="action.featured" class="featured-badge">
                  <i class="el-icon-star-on"></i>
                </div>
              </div>
              <span class="action-label">{{ action.label }}</span>
              <div v-if="action.featured" class="featured-glow"></div>
            </div>
          </div>
        </div>
      </el-col>

      <!-- 右侧天气查询 -->
      <el-col :xs="24" :lg="8">
        <div class="weather-section">
          <div class="section-header">
            <h3><i class="el-icon-cloudy"></i> 天气信息</h3>
            <el-button 
              type="text" 
              @click="showWeatherQuery = !showWeatherQuery"
              class="toggle-query-btn"
            >
              <i :class="showWeatherQuery ? 'el-icon-arrow-up' : 'el-icon-setting'"></i>
              {{ showWeatherQuery ? '收起查询' : '切换城市' }}
            </el-button>
          </div>
          
          <!-- 天气显示卡片 -->
          <div v-if="weatherData" class="weather-display-card">
            <div class="weather-main-info">
              <div class="weather-left">
                <div class="temperature-large">{{ weatherData.temperature }}°</div>
                <div class="weather-desc-main">{{ weatherData.weather }}</div>
                <div class="location-main">
                  <i class="el-icon-location"></i>
                  {{ weatherData.province }} {{ weatherData.city }}
                </div>
              </div>
              <div class="weather-right">
                <div class="weather-icon-main">
                  <i :class="getWeatherIcon(weatherData.weather)"></i>
                </div>
              </div>
            </div>
            
            <div class="weather-details-grid">
              <div class="detail-item">
                <i class="el-icon-wind-power"></i>
                <div class="detail-content">
                  <div class="detail-label">风向风力</div>
                  <div class="detail-value">{{ weatherData.windDirection }} {{ weatherData.windScale }}级</div>
                </div>
              </div>
              <div class="detail-item">
                <i class="el-icon-heavy-rain"></i>
                <div class="detail-content">
                  <div class="detail-label">湿度</div>
                  <div class="detail-value">{{ weatherData.humidity }}%</div>
                </div>
              </div>
              <div class="detail-item">
                <i class="el-icon-umbrella"></i>
                <div class="detail-content">
                  <div class="detail-label">降水量</div>
                  <div class="detail-value">{{ weatherData.precipitation }}mm</div>
                </div>
              </div>
              <div class="detail-item">
                <i class="el-icon-thermometer"></i>
                <div class="detail-content">
                  <div class="detail-label">气压</div>
                  <div class="detail-value">{{ weatherData.pressure }}hPa</div>
                </div>
              </div>
            </div>
            
            <div class="weather-update-time">
              <i class="el-icon-time"></i>
              更新时间: {{ formatTime(weatherData.reporttime) }}
            </div>
          </div>
          
          <!-- 加载状态 -->
          <div v-else-if="weatherLoading" class="weather-loading-card">
            <el-icon class="is-loading"><loading /></el-icon>
            <span>正在获取天气信息...</span>
          </div>
          
          <!-- 错误状态 -->
          <div v-else-if="weatherError" class="weather-error-card">
            <i class="el-icon-warning"></i>
            <span>{{ weatherError }}</span>
            <el-button type="text" @click="fetchWeather" size="small">重试</el-button>
          </div>

          <!-- 查询功能 -->
          <el-collapse-transition>
            <div v-show="showWeatherQuery" class="weather-query">
              <div class="query-title">
                <i class="el-icon-search"></i>
                切换城市
              </div>
              <div class="search-inputs">
                <el-row :gutter="12">
                  <el-col :span="8">
                    <el-input 
                      v-model="province" 
                      placeholder="请输入省份" 
                      prefix-icon="el-icon-location"
                      clearable
                    ></el-input>
                  </el-col>
                  <el-col :span="8">
                    <el-input 
                      v-model="city" 
                      placeholder="请输入城市" 
                      prefix-icon="el-icon-location-outline"
                      clearable
                      @keyup.enter.native="fetchWeather"
                    ></el-input>
                  </el-col>
                  <el-col :span="8">
                    <el-button 
                      type="primary" 
                      @click="fetchWeather" 
                      :loading="weatherLoading" 
                      icon="el-icon-search"
                      style="width: 100%"
                    >
                      查询天气
                    </el-button>
                  </el-col>
                </el-row>
              </div>
            </div>
          </el-collapse-transition>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import ann from '@/api/announcement'
import axios from 'axios'

export default {
  name: 'ModernDashboard',
  data() {
    return {
      currentDate: '',
      // 天气查询相关数据
       city: '哈尔滨',
       province: '黑龙江',
       weatherData: null,
       weatherLoading: false,
       weatherError: '',
       amapKey: '7d1e58e538a7e3d4d1a59ff1fbad1089',
       showWeatherQuery: false,
      // 统计数据
      statsData: [
        {
          label: '在职员工',
          value: 0,
          icon: 'el-icon-user-solid',
          class: 'stat-primary'
        },
        {
          label: '考勤记录',
          value: 0,
          icon: 'el-icon-time',
          class: 'stat-success'
        },
        {
          label: '奖惩记录',
          value: 0,
          icon: 'el-icon-trophy',
          class: 'stat-warning'
        },
        {
          label: '系统通知',
          value: 0,
          icon: 'el-icon-bell',
          class: 'stat-info'
        }
      ],
      // 管理员快捷操作
      adminQuickActions: [
        { label: '个人资料', icon: 'el-icon-user-solid', color: '#722ED1', route: '/profile', featured: true },
        { label: '员工管理', icon: 'el-icon-user', color: '#409EFF', route: '/clerk' },
        { label: '考勤管理', icon: 'el-icon-time', color: '#67C23A', route: '/attendance' },
        { label: '部门管理', icon: 'el-icon-office-building', color: '#F56C6C', route: '/department' },
        { label: '合同管理', icon: 'el-icon-document', color: '#909399', route: '/contract' },
        { label: '奖惩管理', icon: 'el-icon-trophy', color: '#9C27B0', route: '/rewardsPunishments' }
      ],
      // 超级管理员快捷操作（不包含个人资料）
      superAdminQuickActions: [
        { label: '员工管理', icon: 'el-icon-user', color: '#409EFF', route: '/clerk', featured: true },
        { label: '考勤管理', icon: 'el-icon-time', color: '#67C23A', route: '/attendance' },
        { label: '部门管理', icon: 'el-icon-office-building', color: '#F56C6C', route: '/department' },
        { label: '合同管理', icon: 'el-icon-document', color: '#909399', route: '/contract' },
        { label: '奖惩管理', icon: 'el-icon-trophy', color: '#9C27B0', route: '/rewardsPunishments' },
        { label: '修改密码', icon: 'el-icon-key', color: '#FD7E14', route: '/savePassword' }
      ],
      // 普通员工快捷操作
      employeeQuickActions: [
        { label: '个人资料', icon: 'el-icon-user-solid', color: '#722ED1', route: '/profile', featured: true },
        { label: '我的考勤', icon: 'el-icon-time', color: '#67C23A', route: '/attendanceInfo' },
        { label: '公告通知', icon: 'el-icon-bell', color: '#17A2B8', route: '/inform' },
        { label: '个人设置', icon: 'el-icon-setting', color: '#6C757D', route: '/personalized' },
        { label: '修改密码', icon: 'el-icon-key', color: '#FD7E14', route: '/savePassword' }
      ]
    }
  },
  computed: {
    ...mapGetters(['name', 'roles', 'userId']),
    // 根据用户角色和ID返回对应的快捷操作
    quickActions() {
      // 检查用户是否为超级管理员（用户ID为1）
      const isSuperAdmin = this.userId === '1'
      // 检查用户是否为管理员或人事经理
      const isAdmin = this.roles.some(role => 
        role === 'admin' || role === '管理员' || role === '人事经理' || role === 'super_admin'
      )
      
      if (isSuperAdmin) {
        return this.superAdminQuickActions
      } else if (isAdmin) {
        return this.adminQuickActions
      } else {
        return this.employeeQuickActions
      }
    },
    // 根据用户角色和ID返回对应的统计数据
    filteredStatsData() {
      // 检查用户是否为超级管理员（用户ID为1）
      const isSuperAdmin = this.userId === '1'
      // 检查用户是否为管理员或人事经理
      const isAdmin = this.roles.some(role => 
        role === 'admin' || role === '管理员' || role === '人事经理' || role === 'super_admin'
      )
      
      if (isSuperAdmin || isAdmin) {
        return this.statsData
      } else {
        // 普通员工只显示部分统计信息
        return [
          {
            label: '我的考勤',
            value: this.statsData[1]?.value || 0,
            icon: 'el-icon-time',
            class: 'stat-success'
          },
          {
            label: '系统通知',
            value: this.statsData[3]?.value || 0,
            icon: 'el-icon-bell',
            class: 'stat-info'
          },
          {
            label: '在职天数',
            value: this.calculateWorkDays(),
            icon: 'el-icon-calendar',
            class: 'stat-primary'
          },
          {
            label: '本月薪资',
            value: '待发放',
            icon: 'el-icon-coin',
            class: 'stat-warning'
          }
        ]
      }
    }
  },
  created() {
    this.getCurrentDate()
    this.loadStatsData()
    // 延迟获取天气，避免页面加载时的阻塞
    setTimeout(() => {
      this.fetchWeather()
    }, 1000)
  },
  methods: {
    getCurrentDate() {
      const now = new Date()
      const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
        weekday: 'long'
      }
      this.currentDate = now.toLocaleDateString('zh-CN', options)
    },
    loadStatsData() {
      ann.numInfo().then(response => {
        this.statsData[0].value = response.data.clerkCount
        this.statsData[1].value = response.data.attendanceCount
        this.statsData[2].value = response.data.rewardsPunishmentsCount
        this.statsData[3].value = response.data.annCount
      }).catch(() => {
        // 如果API调用失败，使用模拟数据
        this.statsData[0].value = 156
        this.statsData[1].value = 1248
        this.statsData[2].value = 89
        this.statsData[3].value = 12
      })
    },
    handleQuickAction(route) {
      if (route) {
        this.$router.push(route)
      }
    },
    // 天气查询功能
    fetchWeather() {
      if (!this.city || !this.province) {
        this.weatherError = '请输入省份和城市名称'
        return
      }
      
      this.weatherLoading = true
      this.weatherError = ''
      
      axios({
        url: 'https://restapi.amap.com/v3/weather/weatherInfo',
        method: 'get',
        params: {
          key: this.amapKey,
          city: this.city,
          extensions: 'base',
          output: 'json'
        },
        timeout: 10000
      })
      .then(response => {
        const resData = response.data
        if (resData.status !== '1') {
          throw new Error(resData.info || '获取天气数据失败')
        }
        
        if (resData.lives && resData.lives.length > 0) {
          const liveData = resData.lives[0]
          this.weatherData = {
            city: liveData.city,
            province: this.province,
            temperature: liveData.temperature,
            weather: liveData.weather,
            windDirection: liveData.winddirection,
            windScale: liveData.windpower,
            humidity: liveData.humidity,
            precipitation: liveData.precipitation || '0',
            pressure: liveData.pressure,
            windSpeed: this.getWindSpeed(liveData.windpower),
            reporttime: liveData.reporttime
          }
        } else {
          throw new Error('未获取到天气数据，请检查城市名称')
        }
      })
      .catch(error => {
        this.weatherError = this.handleError(error)
      })
      .finally(() => {
        this.weatherLoading = false
      })
    },
    
    handleError(error) {
      if (error.response && error.response.data) {
        return error.response.data.info || 'API请求失败'
      } else if (error.request) {
        return '网络请求失败，请检查网络连接'
      } else {
        return '请求处理错误: ' + error.message
      }
    },
    
    getWindSpeed(windpower) {
      const windMap = {
        '≤3': '0-5',
        '4': '5-8',
        '5': '8-11',
        '6': '11-14',
        '7': '14-17',
        '8': '17-21'
      }
      return windMap[windpower] || '未知'
    },
    
    getWeatherIcon(weather) {
      const iconMap = {
        '晴': 'el-icon-sunny',
        '多云': 'el-icon-cloudy',
        '阴': 'el-icon-cloudy',
        '小雨': 'el-icon-light-rain',
        '中雨': 'el-icon-moderate-rain',
        '大雨': 'el-icon-heavy-rain',
        '雷阵雨': 'el-icon-lightning',
        '雪': 'el-icon-snow',
        '雾': 'el-icon-fog'
      }
      return iconMap[weather] || 'el-icon-cloudy'
    },
    
    formatTime(timeStr) {
      if (!timeStr) return ''
      try {
        const date = new Date(timeStr)
        const now = new Date()
        const diff = now - date
        const minutes = Math.floor(diff / (1000 * 60))
        
        if (minutes < 1) {
          return '刚刚更新'
        } else if (minutes < 60) {
          return `${minutes}分钟前`
        } else if (minutes < 1440) {
          const hours = Math.floor(minutes / 60)
          return `${hours}小时前`
        } else {
          return timeStr.substring(0, 16) // 显示年月日时分
        }
      } catch (e) {
        return timeStr
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.modern-dashboard {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);

  // 欢迎横幅
  .welcome-banner {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 16px;
    padding: 30px;
    margin-bottom: 24px;
    color: white;
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -20%;
      width: 200px;
      height: 200px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
    }

    .banner-content {
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: relative;
      z-index: 1;

      .welcome-text {
        h1 {
          font-size: 28px;
          font-weight: 600;
          margin: 0 0 8px 0;
        }

        p {
          font-size: 16px;
          opacity: 0.9;
          margin: 0;
        }
      }

      .weather-info {
        display: flex;
        align-items: center;
        gap: 12px;

        .weather-icon-wrapper {
          width: 50px;
          height: 50px;
          border-radius: 12px;
          background: rgba(255, 255, 255, 0.2);
          display: flex;
          align-items: center;
          justify-content: center;
          
          .weather-icon {
            font-size: 28px;
            color: rgba(255, 255, 255, 0.9);
          }
        }

        .weather-text {
          .temperature {
            display: block;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 2px;
          }

          .weather-desc {
            font-size: 14px;
            opacity: 0.8;
            margin-bottom: 2px;
          }

          .location {
            font-size: 12px;
            opacity: 0.7;
            display: block;
          }
          
          .update-time {
            font-size: 11px;
            opacity: 0.6;
            display: block;
            margin-top: 2px;
          }
        }
      }
      
      .weather-loading {
        display: flex;
        align-items: center;
        gap: 8px;
        color: rgba(255, 255, 255, 0.8);
        font-size: 14px;
        
        i {
          font-size: 16px;
        }
      }
    }
  }

  // 统计卡片
  .stats-section {
    margin-bottom: 24px;

    .stat-card {
      background: white;
      border-radius: 12px;
      padding: 24px;
      display: flex;
      align-items: center;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      transition: all 0.3s ease;
      border-left: 4px solid transparent;

      &:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
      }

      &.stat-primary {
        border-left-color: #409EFF;
        .stat-icon {
          background: linear-gradient(135deg, #409EFF, #66b3ff);
        }
      }

      &.stat-success {
        border-left-color: #67C23A;
        .stat-icon {
          background: linear-gradient(135deg, #67C23A, #85ce61);
        }
      }

      &.stat-warning {
        border-left-color: #E6A23C;
        .stat-icon {
          background: linear-gradient(135deg, #E6A23C, #ebb563);
        }
      }

      &.stat-info {
        border-left-color: #909399;
        .stat-icon {
          background: linear-gradient(135deg, #909399, #a6a9ad);
        }
      }

      .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 24px;
        margin-right: 16px;
      }

      .stat-content {
        flex: 1;

        .stat-number {
          font-size: 28px;
          font-weight: 700;
          color: #2c3e50;
          margin-bottom: 4px;
        }

        .stat-label {
          font-size: 14px;
          color: #7f8c8d;
        }
      }
    }
  }

  // 主要内容区域
  .main-content {
    .section-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16px;

      h3 {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
        margin: 0;
      }
    }

    // 快捷操作
    .quick-actions {
      background: white;
      border-radius: 12px;
      padding: 24px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);

      .action-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 16px;
        
        // 让个人资料卡片跨越整行并居中
        .action-item:first-child.featured-action {
          grid-column: 1 / -1;
          max-width: 200px;
          margin: 0 auto 8px auto;
        }

        .action-item {
          display: flex;
          flex-direction: column;
          align-items: center;
          padding: 20px 12px;
          border-radius: 8px;
          cursor: pointer;
          transition: all 0.3s ease;
          border: 1px solid #f0f0f0;
          position: relative;
          overflow: hidden;

          &:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
          }

          &.featured-action {
            background: linear-gradient(135deg, #f8f4ff 0%, #f0e6ff 100%);
            border: 2px solid #722ED1;
            box-shadow: 0 4px 20px rgba(114, 46, 209, 0.15);
            
            &:hover {
              background: linear-gradient(135deg, #f4f0ff 0%, #ede0ff 100%);
              transform: translateY(-4px);
              box-shadow: 0 8px 30px rgba(114, 46, 209, 0.25);
            }
            
            .action-label {
              color: #722ED1;
              font-weight: 600;
            }
          }

          .action-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            margin-bottom: 8px;
            position: relative;
            
            .featured-badge {
              position: absolute;
              top: -6px;
              right: -6px;
              width: 18px;
              height: 18px;
              background: linear-gradient(135deg, #FFD700, #FFA500);
              border-radius: 50%;
              display: flex;
              align-items: center;
              justify-content: center;
              font-size: 10px;
              color: white;
              box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
              animation: pulse 2s infinite;
            }
          }

          .action-label {
            font-size: 12px;
            color: #2c3e50;
            text-align: center;
            transition: all 0.3s ease;
          }
          
          .featured-glow {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(114, 46, 209, 0.1) 50%, transparent 70%);
            transform: translateX(-100%);
            animation: shimmer 3s infinite;
          }
        }
      }
    }

    // 天气查询区域
    .weather-section {
      background: white;
      border-radius: 12px;
      padding: 24px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      
      .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        
        .toggle-query-btn {
          color: #409EFF;
          font-size: 14px;
          
          &:hover {
            color: #66b3ff;
          }
          
          i {
            margin-right: 4px;
          }
        }
      }

      // 天气显示卡片
      .weather-display-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 16px;
        padding: 24px;
        color: white;
        margin-bottom: 16px;
        
        .weather-main-info {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 20px;
          
          .weather-left {
            .temperature-large {
              font-size: 48px;
              font-weight: 300;
              line-height: 1;
              margin-bottom: 8px;
            }
            
            .weather-desc-main {
              font-size: 18px;
              margin-bottom: 8px;
              opacity: 0.9;
            }
            
            .location-main {
              font-size: 14px;
              opacity: 0.8;
              
              i {
                margin-right: 4px;
              }
            }
          }
          
          .weather-right {
            .weather-icon-main {
              width: 80px;
              height: 80px;
              border-radius: 50%;
              background: rgba(255, 255, 255, 0.2);
              display: flex;
              align-items: center;
              justify-content: center;
              
              i {
                font-size: 40px;
                color: rgba(255, 255, 255, 0.9);
              }
            }
          }
        }
        
        .weather-details-grid {
          display: grid;
          grid-template-columns: repeat(2, 1fr);
          gap: 16px;
          margin-bottom: 16px;
          
          .detail-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            
            i {
              font-size: 20px;
              opacity: 0.8;
            }
            
            .detail-content {
              .detail-label {
                font-size: 12px;
                opacity: 0.7;
                margin-bottom: 2px;
              }
              
              .detail-value {
                font-size: 14px;
                font-weight: 500;
              }
            }
          }
        }
        
        .weather-update-time {
          text-align: center;
          font-size: 12px;
          opacity: 0.6;
          
          i {
            margin-right: 4px;
          }
        }
      }
      
      // 加载状态卡片
      .weather-loading-card {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 40px;
        background: #f8f9fa;
        border-radius: 12px;
        color: #606266;
        
        i {
          font-size: 24px;
          margin-bottom: 12px;
          color: #409EFF;
        }
      }
      
      // 错误状态卡片
      .weather-error-card {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        padding: 20px;
        background: #fef0f0;
        border: 1px solid #fbc4c4;
        border-radius: 8px;
        color: #f56c6c;
        
        i {
          font-size: 18px;
        }
      }

      // 查询功能
      .weather-query {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 16px;
        margin-top: 16px;
        
        .query-title {
          font-size: 14px;
          font-weight: 500;
          color: #606266;
          margin-bottom: 12px;
          
          i {
            margin-right: 6px;
            color: #409EFF;
          }
        }
        
        .search-inputs {
          .el-input {
            .el-input__inner {
              border-radius: 6px;
            }
          }
          
          .el-button {
            border-radius: 6px;
          }
        }
      }
    }
  }
  
  // 动画效果
  @keyframes pulse {
    0% {
      transform: scale(1);
      box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
    }
    50% {
      transform: scale(1.1);
      box-shadow: 0 4px 16px rgba(255, 215, 0, 0.6);
    }
    100% {
      transform: scale(1);
      box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
    }
  }
  
  @keyframes shimmer {
    0% {
      transform: translateX(-100%);
    }
    100% {
      transform: translateX(100%);
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .modern-dashboard {
    padding: 12px;

    .welcome-banner {
      padding: 20px;

      .banner-content {
        flex-direction: column;
        text-align: center;
        gap: 16px;

        .weather-info {
          justify-content: center;
        }
      }
    }

    .stats-section {
      .stat-card {
        padding: 16px;
        
        .stat-icon {
          width: 48px;
          height: 48px;
          font-size: 20px;
        }
        
        .stat-content .stat-number {
          font-size: 24px;
        }
      }
    }

    .main-content {
      .quick-actions {
        margin-bottom: 16px;
        
        .action-grid {
          grid-template-columns: repeat(2, 1fr);
          gap: 12px;
          
          // 移动端个人资料卡片样式
          .action-item:first-child.featured-action {
            grid-column: 1 / -1;
            max-width: 180px;
            margin: 0 auto 12px auto;
            padding: 20px 16px;
          }

          .action-item {
            padding: 16px 8px;

            .action-icon {
              width: 40px;
              height: 40px;
              font-size: 18px;
              
              .featured-badge {
                width: 16px;
                height: 16px;
                font-size: 8px;
                top: -4px;
                right: -4px;
              }
            }

            .action-label {
              font-size: 11px;
            }
          }
        }
      }
      
      .weather-section {
        padding: 16px;
        
        .weather-display-card {
          padding: 16px;
          
          .weather-main-info {
            flex-direction: column;
            text-align: center;
            gap: 16px;
            
            .weather-left {
              .temperature-large {
                font-size: 36px;
              }
            }
            
            .weather-right {
              .weather-icon-main {
                width: 60px;
                height: 60px;
                
                i {
                  font-size: 30px;
                }
              }
            }
          }
          
          .weather-details-grid {
            grid-template-columns: repeat(2, 1fr);
          }
        }
        
        .weather-query {
          .search-inputs {
            .el-col {
              margin-bottom: 8px;
            }
          }
        }
      }
    }
  }
}
</style>
