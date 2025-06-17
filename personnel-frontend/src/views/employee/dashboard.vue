<template>
  <div class="employee-dashboard">
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

    <!-- 快捷功能区域 -->
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

    <!-- 主要内容区域 -->
    <el-row :gutter="20" class="main-content">
      <!-- 左侧个人信息 -->
      <el-col :xs="24" :lg="16">
        <el-card class="info-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-user"></i> 个人信息概览</span>
          </div>
          <div class="info-content">
            <div class="info-item">
              <span class="info-label">姓名：</span>
              <span class="info-value">{{ name }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">用户ID：</span>
              <span class="info-value">{{ userId }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">角色：</span>
              <span class="info-value">{{ roles.join(', ') }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">登录时间：</span>
              <span class="info-value">{{ loginTime }}</span>
            </div>
            
          </div>
        </el-card>
      </el-col>

      <!-- 右侧天气信息 -->
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
            </div>
            
            <div class="weather-update-time">
              <i class="el-icon-time"></i>
              更新时间: {{ formatTime(weatherData.reporttime) }}
            </div>
          </div>
          
          <!-- 加载状态 -->
          <div v-else-if="weatherLoading" class="weather-loading-card">
            <i class="el-icon-loading"></i>
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
import axios from 'axios'

export default {
  name: 'EmployeeDashboard',
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
      // 员工快捷操作
      quickActions: [
          { label: '个人资料', icon: 'el-icon-user-solid', color: '#722ED1', route: '/profile', featured: true },
          { label: '我的考勤', icon: 'el-icon-time', color: '#67C23A', route: '/showAttendance/showAttendance' },
          { label: '请假申请', icon: 'el-icon-edit-outline', color: '#F56C6C', route: '/employee/leaveApplication' },
          { label: '公告通知', icon: 'el-icon-bell', color: '#17A2B8', route: '/inform' },
          { label: '个人设置', icon: 'el-icon-setting', color: '#6C757D', route: '/personalized' },
          { label: '修改密码', icon: 'el-icon-key', color: '#FD7E14', route: '/savePassword' },
          { label: '我的合同', icon: 'el-icon-document', color: '#909399', route: '/contractInfo/showContract' }
        ]
    }
  },
  computed: {
    ...mapGetters([
      'name',
      'avatar',
      'roles',
      'userId'
    ]),
    loginTime() {
      return new Date().toLocaleString('zh-CN')
    }
  },
  created() {
    this.getCurrentDate()
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
.employee-dashboard {
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

  // 快捷操作
  .quick-actions {
    background: white;
    border-radius: 12px;
    padding: 24px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    margin-bottom: 24px;

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

  // 主要内容区域
  .main-content {
    .info-card {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      
      .card-header {
        font-size: 16px;
        font-weight: 600;
        color: #2c3e50;
        
        i {
          margin-right: 8px;
          color: #409EFF;
        }
      }
      
      .info-content {
        .info-item {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 12px 0;
          border-bottom: 1px solid #f0f0f0;
          
          &:last-child {
            border-bottom: none;
          }
          
          .info-label {
            font-size: 14px;
            color: #606266;
            font-weight: 500;
          }
          
          .info-value {
            font-size: 14px;
            color: #2c3e50;
            font-weight: 600;
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
        
        h3 {
          font-size: 18px;
          font-weight: 600;
          color: #2c3e50;
          margin: 0;
        }
        
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
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        margin-bottom: 16px;
        
        .weather-main-info {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 20px;
          
          .weather-left {
            .temperature-large {
              font-size: 48px;
              font-weight: 600;
              color: #2c3e50;
              line-height: 1;
            }
            
            .weather-desc-main {
              font-size: 16px;
              color: #606266;
              margin: 8px 0;
            }
            
            .location-main {
              font-size: 14px;
              color: #909399;
              
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
  .employee-dashboard {
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
    
    .main-content {
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
    
    .user-avatar {
      border: 3px solid rgba(255, 255, 255, 0.3);
      border-radius: 50%;
      padding: 5px;
    }
  }

.quick-actions {
  margin-bottom: 20px;
}

.action-card {
  cursor: pointer;
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  }
  
  .action-content {
    display: flex;
    align-items: center;
    padding: 10px;
    
    .action-icon {
      font-size: 32px;
      color: #409EFF;
      margin-right: 15px;
    }
    
    .action-text {
      h3 {
        margin: 0 0 5px 0;
        font-size: 16px;
        color: #303133;
      }
      
      p {
        margin: 0;
        font-size: 12px;
        color: #909399;
      }
    }
  }
}

.info-section {
  .info-card {
    height: 300px;
    
    .card-header {
      font-weight: 600;
      color: #303133;
    }
    
    .info-content {
      .info-item {
        display: flex;
        margin-bottom: 15px;
        
        .info-label {
          width: 80px;
          color: #606266;
          font-weight: 500;
        }
        
        .info-value {
          color: #303133;
          flex: 1;
        }
      }
    }
    
    .announcement-content {
      .announcement-item {
        .announcement-title {
          font-weight: 600;
          color: #303133;
          margin-bottom: 5px;
        }
        
        .announcement-date {
          font-size: 12px;
          color: #909399;
          margin-bottom: 10px;
        }
        
        .announcement-text {
          color: #606266;
          line-height: 1.6;
        }
      }
    }
  }
}

::v-deep .el-card__body {
  padding: 20px;
}

::v-deep .welcome-card .el-card__body {
  background: transparent;
}
</style>