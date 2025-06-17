<template>
  <div class="profile-container">
    <!-- 个人资料头部横幅 -->
    <div class="profile-header">
      <div class="header-background"></div>
      <div class="header-content">
        <div class="avatar-section">
          <div class="avatar-wrapper">
            <img :src="baseApi + user.avatar" :alt="user.name" class="user-avatar" />
            <div class="avatar-badge">
              <i class="el-icon-star-on"></i>
            </div>
          </div>
          <div class="user-info">
            <h1 class="user-name">{{ user.name }}</h1>
            <p class="user-role">{{ user.role }}</p>
            <p class="user-intro">{{ user.introduction || '暂无个人简介' }}</p>
          </div>
        </div>
        <div class="contact-info">
          <div class="contact-item">
            <i class="el-icon-phone"></i>
            <span>{{ user.phoneNumber || userProfile.phoneNumber || '未设置' }}</span>
          </div>
          <div class="contact-item">
            <i class="el-icon-message"></i>
            <span>{{ user.email || userProfile.email || '未设置' }}</span>
          </div>
          <div class="contact-item">
            <i class="el-icon-location"></i>
            <span>{{ user.address || userProfile.address || '未设置' }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="profile-content">
      <el-row :gutter="24">
        <el-col :span="8" :xs="24">
          <user-card 
            :user="user" 
            :userProfile="userProfile"
            :editingProfile="editingProfile"
            @edit-profile="editProfile"
            @save-profile="saveProfile"
            @cancel-edit="cancelEdit"
            @update-profile="updateUserProfile"
          />
          
          <!-- 技能标签卡片 -->
          <el-card class="skills-card" shadow="hover">
            <div slot="header" class="card-header">
              <span><i class="el-icon-medal"></i> 专业技能</span>
              <el-button v-if="!editingSkills" type="text" @click="editSkills">编辑</el-button>
              <div v-if="editingSkills">
                <el-button type="text" @click="addSkill">添加技能</el-button>
                <el-button type="primary" size="mini" @click="saveSkills">保存</el-button>
                <el-button type="default" size="mini" @click="cancelEdit">取消</el-button>
              </div>
            </div>
            <div class="skills-content">
              <template v-if="!editingSkills">
                <el-tag 
                  v-for="skill in skills" 
                  :key="typeof skill === 'string' ? skill : skill.name"
                  type="primary"
                  class="skill-tag"
                  effect="plain"
                >
                  {{ typeof skill === 'string' ? skill : skill.name }}
                </el-tag>
                <el-tag 
                  v-if="!skills.length"
                  type="info"
                  effect="plain"
                >
                  暂无技能标签
                </el-tag>
              </template>
              <template v-else>
                <div v-for="(skill, index) in skills" :key="index" class="skill-edit-item">
                  <el-input
                    v-model="skills[index]"
                    size="small"
                    style="width: 120px; margin-right: 8px;"
                  />
                  <el-button
                    type="danger"
                    size="mini"
                    icon="el-icon-delete"
                    @click="removeSkill(index)"
                  />
                </div>
                <el-button
                  v-if="skills.length === 0"
                  type="dashed"
                  @click="addSkill"
                  style="width: 100%; margin-top: 8px;"
                >
                  + 添加技能
                </el-button>
              </template>
            </div>
          </el-card>
        </el-col>

        <el-col :span="16" :xs="24">
          <el-card class="main-content-card" shadow="hover">
            <el-tabs v-model="activeTab" type="border-card" class="profile-tabs">
              <el-tab-pane label="个人履历" name="timeline">
                <div class="tab-content">
                  <timeline />
                </div>
              </el-tab-pane>
              
              <el-tab-pane label="基本信息" name="basic">
                <div class="tab-content">
                  <basic-info :userProfile="userProfile" @profile-updated="handleProfileUpdate" />
                </div>
              </el-tab-pane>
            </el-tabs>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import UserCard from './components/UserCard'
import Timeline from './components/Timeline'
import BasicInfo from './components/BasicInfo'
import { getClerkProfile, updateClerkSkills, updateClerkProfile } from '@/api/profile'
import clerk from '@/api/clerk'

export default {
  name: 'Profile',
  components: { 
    UserCard, 
    Timeline, 
    BasicInfo
  },
  data() {
    return {
      baseApi: process.env.VUE_APP_BASE_API,
      user: {},
      activeTab: 'timeline',
      skills: [],
      userProfile: {
        id: '',
        name: '',
        sex: '',
        phoneNumber: '',
        email: '',
        photo: '',
        position: '',
        address: '',
        departmentName: ''
      },
      editingSkills: false,
      editingProfile: false
    }
  },
  computed: {
    ...mapGetters([
      'name',
      'avatar',
      'roles',
      'introduction'
    ])
  },
  created() {
    this.getUser()
    this.loadUserProfile()
  },
  // mounted() {
  //   this.loadUserProfile()
  // },
  methods: {
    getUser() {
      // 设置基本的用户信息
      this.user = {
        ...this.user,
        name: this.name,
        role: this.roles.join(' | '),
        avatar: this.avatar,
        introduction: this.introduction
      }
    },
    
    async loadUserProfile() {
      try {
        console.log('开始加载用户profile数据...')
        const response = await getClerkProfile()
        console.log('getClerkProfile响应:', response)
        
        if (response.success && response.data) {
          const profileData = response.data
          this.userProfile = {
            id: profileData.id || '',
            name: profileData.name || '',
            sex: profileData.sex || '',
            phoneNumber: profileData.phoneNumber || '',
            email: profileData.email || '',
            photo: profileData.photo || '',
            position: profileData.position || '',
            address: profileData.address || '',
            departmentName: profileData.departmentName || '',
            departmentId: profileData.departmentId || '',
            idCard: profileData.idCard || ''
          }
          
          // 更新技能数据
          if (profileData.skills) {
            this.skills = Array.isArray(profileData.skills) ? profileData.skills : []
          }
          
          // 同时更新user对象，确保头部显示正确
          this.user = {
            ...this.user,
            phoneNumber: profileData.phoneNumber,
            email: profileData.email,
            address: profileData.address
          }
          
          console.log('用户profile数据加载成功:', this.userProfile)
        } else {
          console.log('API返回数据格式异常:', response)
          this.$message.warning('获取用户信息失败')
        }
      } catch (error) {
        console.error('加载用户profile失败:', error)
        this.$message.error('获取用户信息失败')
      }
    },
    
    async loadBasicUserInfo() {
      // 备用方案：从现有的用户数据中获取基本信息
      try {
        const userId = this.$store.getters.userId || 1
        console.log('尝试获取用户ID:', userId)
        const response = await clerk.getClerkById(userId)
        console.log('getClerkById响应:', response)
        if (response.data) {
          this.userProfile = {
            id: response.data.id || '',
            name: response.data.name || '',
            sex: response.data.sex || '',
            phoneNumber: response.data.phoneNumber || '',
            email: response.data.email || '',
            photo: response.data.photo || '',
            position: response.data.position || '',
            address: response.data.address || '',
            departmentName: response.data.departmentName || ''
          }
          this.user = {
            ...this.user,
            phoneNumber: response.data.phoneNumber,
            email: response.data.email,
            address: response.data.address,
            idCard: response.data.idCard,
            sex: response.data.sex
          }
          console.log('备用方案加载的userProfile:', this.userProfile)
        }
      } catch (error) {
        console.log('获取基本用户信息失败:', error)
      }
    },
    
    editSkills() {
      this.$prompt('请输入技能（多个技能用逗号分隔）', '编辑技能', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputValue: this.skills.map(skill => typeof skill === 'string' ? skill : skill.name).join(', ')
      }).then(({ value }) => {
        if (value) {
          this.skills = value.split(',').map(skill => skill.trim()).filter(skill => skill)
          this.saveSkills()
        }
      }).catch(() => {})
    },
    
    async saveSkills() {
      try {
        // 保存技能到后端
        const response = await updateClerkSkills(this.skills)
        if (response.success) {
          this.$message.success('技能更新成功')
          this.editingSkills = false
        } else {
          this.$message.error(response.message || '技能更新失败')
        }
      } catch (error) {
        console.error('技能更新失败:', error)
        this.$message.error('技能更新失败')
      }
    },
    
    addSkill() {
      // 添加新技能
      const skillName = prompt('请输入技能名称:')
      if (skillName && skillName.trim()) {
        this.skills.push(skillName.trim())
      }
    },
    
    removeSkill(index) {
      // 删除技能
      this.skills.splice(index, 1)
    },
    
    editProfile() {
      // 进入个人信息编辑模式
      this.editingProfile = true
    },
    
    async saveProfile() {
      // 保存个人信息到后端
      try {
        const profileData = {
          email: this.userProfile.email,
          address: this.userProfile.address,
          phoneNumber: this.userProfile.phoneNumber
        }
        const response = await updateClerkProfile(profileData)
        if (response.success) {
          this.$message.success('个人信息更新成功')
          this.editingProfile = false
        } else {
          this.$message.error(response.message || '个人信息更新失败')
        }
      } catch (error) {
        console.error('个人信息更新失败:', error)
        this.$message.error('个人信息更新失败')
      }
    },
    
    cancelEdit() {
      // 取消编辑
      this.editingSkills = false
      this.editingProfile = false
      // 重新加载数据
      this.loadUserProfile()
    },
    
    updateUser(userData) {
       this.user = { ...this.user, ...userData }
     },

     updateUserProfile(profileData) {
       // 更新userProfile数据
       this.userProfile = { ...this.userProfile, ...profileData }
     },

     handleProfileUpdate(updatedProfile) {
       // 处理基本信息更新
       this.userProfile = { ...this.userProfile, ...updatedProfile }
       this.loadUserProfile() // 重新加载用户资料
     }
  }
}
</script>

<style lang="scss" scoped>
.profile-container {
  min-height: 100vh;
  background: white;
  
  .profile-header {
    position: relative;
    padding: 40px 20px;
    margin-bottom: 30px;
    
    .header-background {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.9) 0%, rgba(118, 75, 162, 0.9) 100%);
      backdrop-filter: blur(10px);
    }
    
    .header-content {
      position: relative;
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: white;
      
      .avatar-section {
        display: flex;
        align-items: center;
        gap: 24px;
        
        .avatar-wrapper {
          position: relative;
          
          .user-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            transition: transform 0.3s ease;
            
            &:hover {
              transform: scale(1.05);
            }
          }
          
          .avatar-badge {
            position: absolute;
            bottom: 8px;
            right: 8px;
            width: 32px;
            height: 32px;
            background: linear-gradient(45deg, #ffd700, #ffed4e);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
            font-size: 16px;
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4);
          }
        }
        
        .user-info {
          .user-name {
            font-size: 32px;
            font-weight: 700;
            margin: 0 0 8px 0;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
          }
          
          .user-role {
            font-size: 18px;
            margin: 0 0 12px 0;
            opacity: 0.9;
            font-weight: 500;
          }
          
          .user-intro {
            font-size: 16px;
            margin: 0;
            opacity: 0.8;
            max-width: 400px;
            line-height: 1.5;
          }
        }
      }
      
      .contact-info {
        display: flex;
        gap: 32px;
        
        .contact-item {
          text-align: center;
          
          .contact-value {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 8px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
          }
          
          .contact-label {
            font-size: 14px;
            opacity: 0.8;
            font-weight: 500;
          }
        }
      }
    }
  }
  
  .profile-content {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px 40px;
    
    .skills-card {
      margin-top: 24px;
      border-radius: 12px;
      overflow: hidden;
      
      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 600;
        
        i {
          margin-right: 8px;
          color: #ffd700;
        }
      }
      
      .skills-content {
        .skill-tag {
          margin: 4px 8px 4px 0;
          padding: 8px 16px;
          border-radius: 20px;
          font-weight: 500;
          transition: all 0.3s ease;
          
          &:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
          }
        }
        
        .skill-edit-item {
          display: inline-flex;
          align-items: center;
          margin: 4px 8px 4px 0;
        }
      }
    }
    
    .main-content-card {
      border-radius: 12px;
      overflow: hidden;
      
      .profile-tabs {
        border: none;
        
        ::v-deep .el-tabs__header {
          margin: 0;
          
          .el-tabs__nav {
            border-radius: 8px 8px 0 0;
          }
          
          .el-tabs__item {
            padding: 16px 24px;
            font-weight: 500;
            transition: all 0.3s ease;
            
            &:hover {
              color: #667eea;
            }
            
            &.is-active {
              background: linear-gradient(135deg, #667eea, #764ba2);
              color: white;
            }
          }
        }
        
        .tab-content {
          padding: 24px;
          min-height: 400px;
        }
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .profile-container {
    .profile-header {
      padding: 20px 16px;
      
      .header-content {
        flex-direction: column;
        gap: 24px;
        text-align: center;
        
        .avatar-section {
          flex-direction: column;
          gap: 16px;
          
          .user-info {
            .user-name {
              font-size: 24px;
            }
            
            .user-role {
              font-size: 16px;
            }
            
            .user-intro {
              font-size: 14px;
            }
          }
        }
        
        .quick-stats {
          gap: 20px;
          
          .stat-item {
            .stat-number {
              font-size: 28px;
            }
          }
        }
      }
    }
    
    .profile-content {
      padding: 0 16px 20px;
      
      .el-col {
        margin-bottom: 20px;
      }
    }
  }
}

@media (max-width: 480px) {
  .profile-container {
    .profile-header {
      .header-content {
        .quick-stats {
          flex-direction: column;
          gap: 16px;
        }
      }
    }
  }
}
</style>
