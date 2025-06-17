<template>
  <div class="personal-settings">
    <!-- 账户安全设置 -->
    <div class="settings-section">
      <h3 class="section-title">
        <i class="el-icon-lock"></i>
        账户安全
      </h3>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">登录密码</div>
          <div class="setting-desc">定期更换密码可以提高账户安全性</div>
        </div>
        <div class="setting-action">
          <el-button type="primary" size="small" @click="showPasswordDialog = true">
            修改密码
          </el-button>
        </div>
      </div>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">两步验证</div>
          <div class="setting-desc">开启后登录需要手机验证码确认</div>
        </div>
        <div class="setting-action">
          <el-switch
            v-model="settings.twoFactorAuth"
            @change="handleTwoFactorChange"
          >
          </el-switch>
        </div>
      </div>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">登录通知</div>
          <div class="setting-desc">新设备登录时发送邮件通知</div>
        </div>
        <div class="setting-action">
          <el-switch
            v-model="settings.loginNotification"
            @change="handleSettingChange"
          >
          </el-switch>
        </div>
      </div>
    </div>
    
    <!-- 通知设置 -->
    <div class="settings-section">
      <h3 class="section-title">
        <i class="el-icon-bell"></i>
        通知设置
      </h3>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">邮件通知</div>
          <div class="setting-desc">接收系统重要消息的邮件通知</div>
        </div>
        <div class="setting-action">
          <el-switch
            v-model="settings.emailNotification"
            @change="handleSettingChange"
          >
          </el-switch>
        </div>
      </div>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">短信通知</div>
          <div class="setting-desc">接收考勤、审批等重要事项的短信提醒</div>
        </div>
        <div class="setting-action">
          <el-switch
            v-model="settings.smsNotification"
            @change="handleSettingChange"
          >
          </el-switch>
        </div>
      </div>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">浏览器通知</div>
          <div class="setting-desc">在浏览器中显示实时消息通知</div>
        </div>
        <div class="setting-action">
          <el-switch
            v-model="settings.browserNotification"
            @change="handleBrowserNotificationChange"
          >
          </el-switch>
        </div>
      </div>
    </div>
    
    <!-- 界面设置 -->
    <div class="settings-section">
      <h3 class="section-title">
        <i class="el-icon-setting"></i>
        界面设置
      </h3>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">主题模式</div>
          <div class="setting-desc">选择您喜欢的界面主题</div>
        </div>
        <div class="setting-action">
          <el-select v-model="settings.theme" @change="handleThemeChange" style="width: 120px">
            <el-option label="浅色" value="light"></el-option>
            <el-option label="深色" value="dark"></el-option>
            <el-option label="自动" value="auto"></el-option>
          </el-select>
        </div>
      </div>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">语言设置</div>
          <div class="setting-desc">选择系统显示语言</div>
        </div>
        <div class="setting-action">
          <el-select v-model="settings.language" @change="handleLanguageChange" style="width: 120px">
            <el-option label="简体中文" value="zh-CN"></el-option>
            <el-option label="English" value="en-US"></el-option>
          </el-select>
        </div>
      </div>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">侧边栏折叠</div>
          <div class="setting-desc">默认折叠左侧导航栏</div>
        </div>
        <div class="setting-action">
          <el-switch
            v-model="settings.sidebarCollapsed"
            @change="handleSettingChange"
          >
          </el-switch>
        </div>
      </div>
    </div>
    
    <!-- 隐私设置 -->
    <div class="settings-section">
      <h3 class="section-title">
        <i class="el-icon-view"></i>
        隐私设置
      </h3>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">个人资料可见性</div>
          <div class="setting-desc">控制其他同事查看您的个人信息</div>
        </div>
        <div class="setting-action">
          <el-select v-model="settings.profileVisibility" @change="handleSettingChange" style="width: 120px">
            <el-option label="公开" value="public"></el-option>
            <el-option label="同部门" value="department"></el-option>
            <el-option label="私密" value="private"></el-option>
          </el-select>
        </div>
      </div>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">在线状态显示</div>
          <div class="setting-desc">显示您的在线状态给其他用户</div>
        </div>
        <div class="setting-action">
          <el-switch
            v-model="settings.showOnlineStatus"
            @change="handleSettingChange"
          >
          </el-switch>
        </div>
      </div>
    </div>
    
    <!-- 数据管理 -->
    <div class="settings-section">
      <h3 class="section-title">
        <i class="el-icon-document-copy"></i>
        数据管理
      </h3>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">导出个人数据</div>
          <div class="setting-desc">下载您在系统中的所有个人数据</div>
        </div>
        <div class="setting-action">
          <el-button size="small" @click="exportPersonalData">
            导出数据
          </el-button>
        </div>
      </div>
      
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-label">清除缓存</div>
          <div class="setting-desc">清除浏览器中的应用缓存数据</div>
        </div>
        <div class="setting-action">
          <el-button size="small" @click="clearCache">
            清除缓存
          </el-button>
        </div>
      </div>
    </div>
    
    <!-- 修改密码对话框 -->
    <el-dialog
      title="修改密码"
      :visible.sync="showPasswordDialog"
      width="400px"
      :close-on-click-modal="false"
    >
      <el-form :model="passwordForm" :rules="passwordRules" ref="passwordForm" label-width="100px">
        <el-form-item label="当前密码" prop="currentPassword">
          <el-input
            v-model="passwordForm.currentPassword"
            type="password"
            placeholder="请输入当前密码"
            show-password
          ></el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="passwordForm.newPassword"
            type="password"
            placeholder="请输入新密码"
            show-password
          ></el-input>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="passwordForm.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            show-password
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="showPasswordDialog = false">取消</el-button>
        <el-button type="primary" @click="changePassword">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'PersonalSettings',
  data() {
    return {
      showPasswordDialog: false,
      settings: {
        twoFactorAuth: false,
        loginNotification: true,
        emailNotification: true,
        smsNotification: false,
        browserNotification: true,
        theme: 'light',
        language: 'zh-CN',
        sidebarCollapsed: false,
        profileVisibility: 'department',
        showOnlineStatus: true
      },
      passwordForm: {
        currentPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      passwordRules: {
        currentPassword: [
          { required: true, message: '请输入当前密码', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认新密码', trigger: 'blur' },
          { validator: this.validateConfirmPassword, trigger: 'blur' }
        ]
      }
    }
  },
  
  created() {
    this.loadSettings()
  },
  
  methods: {
    loadSettings() {
      // 从本地存储或API加载用户设置
      const savedSettings = localStorage.getItem('userSettings')
      if (savedSettings) {
        this.settings = { ...this.settings, ...JSON.parse(savedSettings) }
      }
    },
    
    saveSettings() {
      // 保存设置到本地存储或API
      localStorage.setItem('userSettings', JSON.stringify(this.settings))
      this.$message.success('设置已保存')
    },
    
    handleSettingChange() {
      this.saveSettings()
    },
    
    handleTwoFactorChange(value) {
      if (value) {
        this.$confirm('开启两步验证需要绑定手机号，是否继续？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.saveSettings()
          this.$message.success('两步验证已开启')
        }).catch(() => {
          this.settings.twoFactorAuth = false
        })
      } else {
        this.saveSettings()
      }
    },
    
    handleBrowserNotificationChange(value) {
      if (value && 'Notification' in window) {
        if (Notification.permission === 'default') {
          Notification.requestPermission().then(permission => {
            if (permission === 'granted') {
              this.saveSettings()
            } else {
              this.settings.browserNotification = false
              this.$message.warning('浏览器通知权限被拒绝')
            }
          })
        } else if (Notification.permission === 'denied') {
          this.settings.browserNotification = false
          this.$message.warning('请在浏览器设置中允许通知权限')
        } else {
          this.saveSettings()
        }
      } else {
        this.saveSettings()
      }
    },
    
    handleThemeChange(theme) {
      // 这里可以实现主题切换逻辑
      document.documentElement.setAttribute('data-theme', theme)
      this.saveSettings()
      this.$message.success(`已切换到${theme === 'light' ? '浅色' : theme === 'dark' ? '深色' : '自动'}主题`)
    },
    
    handleLanguageChange(language) {
      // 这里可以实现语言切换逻辑
      this.saveSettings()
      this.$message.success('语言设置已更新，刷新页面后生效')
    },
    
    validateConfirmPassword(rule, value, callback) {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    },
    
    changePassword() {
      this.$refs.passwordForm.validate((valid) => {
        if (valid) {
          // 这里调用修改密码的API
          this.$message.success('密码修改成功')
          this.showPasswordDialog = false
          this.passwordForm = {
            currentPassword: '',
            newPassword: '',
            confirmPassword: ''
          }
        }
      })
    },
    
    exportPersonalData() {
      this.$message.info('个人数据导出功能开发中...')
    },
    
    clearCache() {
      // 清除缓存
      localStorage.clear()
      sessionStorage.clear()
      this.$message.success('缓存已清除')
    }
  }
}
</script>

<style lang="scss" scoped>
.personal-settings {
  .settings-section {
    margin-bottom: 32px;
    
    .section-title {
      font-size: 18px;
      font-weight: 600;
      color: #333;
      margin-bottom: 20px;
      padding-bottom: 12px;
      border-bottom: 2px solid #f0f0f0;
      
      i {
        margin-right: 8px;
        color: #667eea;
      }
    }
    
    .setting-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20px 0;
      border-bottom: 1px solid #f5f5f5;
      
      &:last-child {
        border-bottom: none;
      }
      
      .setting-info {
        flex: 1;
        
        .setting-label {
          font-size: 16px;
          font-weight: 500;
          color: #333;
          margin-bottom: 4px;
        }
        
        .setting-desc {
          font-size: 14px;
          color: #666;
          line-height: 1.4;
        }
      }
      
      .setting-action {
        margin-left: 20px;
      }
    }
  }
  
  ::v-deep .el-switch {
    .el-switch__core {
      border-color: #dcdfe6;
      
      &:after {
        background-color: #fff;
      }
    }
    
    &.is-checked .el-switch__core {
      border-color: #667eea;
      background-color: #667eea;
    }
  }
  
  ::v-deep .el-select {
    .el-input__inner {
      border-radius: 6px;
      
      &:focus {
        border-color: #667eea;
      }
    }
  }
  
  ::v-deep .el-button {
    border-radius: 6px;
    font-weight: 500;
    
    &--primary {
      background-color: #667eea;
      border-color: #667eea;
      
      &:hover {
        background-color: #5a6fd8;
        border-color: #5a6fd8;
      }
    }
  }
  
  ::v-deep .el-dialog {
    border-radius: 12px;
    
    .el-dialog__header {
      padding: 20px 20px 10px;
      
      .el-dialog__title {
        font-weight: 600;
        color: #333;
      }
    }
    
    .el-dialog__body {
      padding: 10px 20px 20px;
    }
    
    .el-form-item {
      margin-bottom: 20px;
      
      .el-form-item__label {
        font-weight: 500;
        color: #666;
      }
      
      .el-input__inner {
        border-radius: 6px;
        
        &:focus {
          border-color: #667eea;
          box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .personal-settings {
    .settings-section {
      .setting-item {
        flex-direction: column;
        align-items: flex-start;
        
        .setting-action {
          margin-left: 0;
          margin-top: 12px;
          width: 100%;
          
          .el-select {
            width: 100% !important;
          }
        }
      }
    }
  }
}
</style>