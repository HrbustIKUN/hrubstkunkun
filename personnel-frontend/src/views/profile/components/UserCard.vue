<template>
  <div class="user-card">
    <el-card>
      <!-- 用户基本信息 -->
      <div class="user-profile">
        <div class="user-info">
          <h3>{{ userProfile.name || '未设置姓名' }}</h3>
          <p class="position">{{ userProfile.position || '未设置职位' }}</p>
          <p class="department">{{ userProfile.departmentName || '未分配部门' }}</p>
        </div>
      </div>



    <div class="user-bio">
      <div class="bio-section">
        <div class="section-header">
          <i class="el-icon-document"></i>
          <span>个人简介</span>
        </div>
        <div class="section-content">
          <p class="bio-text">{{ user.introduction || '这个人很懒，什么都没有留下...' }}</p>
        </div>
      </div>



      <div class="bio-section">
        <div class="section-header">
          <i class="el-icon-phone"></i>
          <span>联系方式</span>
        </div>
        <div class="section-content">
          <div class="contact-item">
            <i class="el-icon-message"></i>
            <span>{{ user.email || 'user@company.com' }}</span>
          </div>
          <div class="contact-item">
            <i class="el-icon-mobile-phone"></i>
            <span>{{ user.phoneNumber || userProfile.phoneNumber || '138****8888' }}</span>
          </div>
        </div>
      </div>
    </div>
  </el-card>
</div>
</template>

<script>
export default {
  name: 'UserCard',
  props: {
    user: {
      type: Object,
      default: () => ({})
    },
    userProfile: {
      type: Object,
      default: () => ({})
    },
    editingProfile: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      defaultAvatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
      editableProfile: {
        phoneNumber: '',
        email: '',
        address: ''
      }
    }
  },
  // 移除watch监听器避免无限循环
}
</script>

<style lang="scss" scoped>
.user-card {
  border-radius: 12px;
  overflow: hidden;
  
  .user-profile {
    margin-bottom: 20px;
    
    .user-info {
      
      h3 {
        font-size: 18px;
        font-weight: 600;
        color: #303133;
        margin: 0 0 8px 0;
      }
      
      .position {
        color: #909399;
        margin: 0 0 4px 0;
        font-size: 14px;
      }
      
      .department {
        color: #909399;
        margin: 0;
        font-size: 14px;
      }
    }
  }
  
  .user-stats {
    display: flex;
    justify-content: space-around;
    padding: 16px 0;
    margin-bottom: 20px;
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    border-radius: 8px;
    
    .stat-item {
      text-align: center;
      
      .stat-number {
        font-size: 20px;
        font-weight: 700;
        color: #333;
        margin-bottom: 4px;
      }
      
      .stat-label {
        font-size: 12px;
        color: #666;
        font-weight: 500;
      }
    }
  }
  
  .user-bio {
    .bio-section {
      margin-bottom: 24px;
      
      &:last-child {
        margin-bottom: 0;
      }
      
      .section-header {
        display: flex;
        align-items: center;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 12px;
        
        i {
          margin-right: 6px;
          color: #667eea;
          font-size: 16px;
        }
      }
      
      .section-content {
        .bio-text {
          font-size: 14px;
          color: #666;
          line-height: 1.6;
          margin: 0;
          padding: 12px;
          background: #f8f9fa;
          border-radius: 6px;
          border-left: 3px solid #667eea;
        }
        
        .skill-item {
          margin-bottom: 16px;
          
          &:last-child {
            margin-bottom: 0;
          }
          
          .skill-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
            
            .skill-name {
              font-size: 14px;
              font-weight: 500;
              color: #333;
            }
            
            .skill-level {
              font-size: 12px;
              color: #666;
              font-weight: 600;
            }
          }
        }
        
        .contact-item {
          display: flex;
          align-items: center;
          margin-bottom: 8px;
          font-size: 14px;
          color: #666;
          
          &:last-child {
            margin-bottom: 0;
          }
          
          i {
            margin-right: 8px;
            color: #667eea;
            width: 16px;
          }
        }
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .user-card {
    .user-profile {
      .avatar-section {
        flex-direction: column;
        text-align: center;
        
        .avatar-wrapper {
          margin-right: 0;
          margin-bottom: 12px;
        }
      }
    }
    
    .user-stats {
      .stat-item {
        .stat-number {
          font-size: 18px;
        }
        
        .stat-label {
          font-size: 11px;
        }
      }
    }
  }
}
</style>
