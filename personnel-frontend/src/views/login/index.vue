<template>
  <div class="modern-login-container">
    <!-- 背景装饰 -->
    <div class="background-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>

    <!-- 登录卡片 -->
    <div class="login-card">
      <!-- 头部 -->
      <div class="login-header">
        <div class="logo-section">
          <img src="../../assets/logo.png" class="logo" alt="Logo">
          <h1 class="system-title">企业人事职工管理系统</h1>
        </div>
        <p class="welcome-text">欢迎回来，请登录您的账户</p>
      </div>

      <!-- 登录表单 -->
      <el-form
        ref="loginForm"
        :model="loginForm"
        :rules="loginRules"
        class="login-form"
        @submit.native.prevent="handleLogin"
      >
        <!-- 用户名/邮箱输入 -->
        <el-form-item prop="username" class="form-item">
          <div class="input-wrapper">
            <i class="el-icon-user input-icon"></i>
            <el-input
              ref="username"
              v-model="loginForm.username"
              placeholder="请输入用户名或邮箱"
              class="modern-input"
              clearable
              @blur="checkEmailFormat"
            />
          </div>
        </el-form-item>

        <!-- 密码输入 -->
        <el-form-item prop="password" class="form-item">
          <div class="input-wrapper">
            <i class="el-icon-lock input-icon"></i>
            <el-input
              ref="password"
              v-model="loginForm.password"
              :type="passwordType"
              placeholder="请输入密码"
              class="modern-input"
              @keyup.enter.native="handleLogin"
            />
            <i 
              :class="passwordType === 'password' ? 'el-icon-view' : 'el-icon-hide'"
              class="password-toggle"
              @click="togglePassword"
            ></i>
          </div>
        </el-form-item>

        <!-- 邮箱验证码 -->
        <el-form-item v-if="isEmailLogin" prop="emailCode" class="form-item">
          <div class="input-wrapper verification-wrapper">
            <i class="el-icon-message input-icon"></i>
            <el-input
              v-model="loginForm.emailCode"
              placeholder="请输入邮箱验证码"
              class="modern-input verification-input"
              maxlength="4"
            />
            <el-button
              :disabled="emailCodeDisabled"
              :loading="sendingEmailCode"
              class="send-code-btn"
              @click="sendEmailCode"
            >
              {{ emailCodeText }}
            </el-button>
          </div>
        </el-form-item>

        <!-- 滑动验证码 -->
        <el-form-item prop="captcha" class="form-item">
          <div class="slider-captcha-wrapper">
            <div class="slider-captcha" ref="sliderTrack">
              <div class="slider-track">
                <div class="slider-bg" :style="{ width: sliderProgress + '%' }"></div>
                <div class="slider-text" :class="{ verified: captchaVerified }">
                  {{ captchaVerified ? '验证成功' : '请拖动滑块完成验证' }}
                </div>
                <div 
                  class="slider-btn" 
                  :class="{ verified: captchaVerified }"
                  :style="{ left: sliderProgress + '%' }"
                  @mousedown="startDrag"
                  @touchstart="startDrag"
                >
                  <i :class="captchaVerified ? 'el-icon-check' : 'el-icon-right'"></i>
                </div>
              </div>
            </div>
            <div class="captcha-refresh" @click="resetCaptcha">
              <i class="el-icon-refresh"></i>
            </div>
          </div>
        </el-form-item>

        <!-- 记住我 -->
        <div class="form-options">
          <el-checkbox v-model="rememberMe" class="remember-checkbox">
            记住我
          </el-checkbox>
        </div>

        <!-- 登录按钮 -->
        <el-button
          :loading="loading"
          type="primary"
          class="login-btn"
          @click="handleLogin"
        >
          <span v-if="!loading">登录</span>
          <span v-else>登录中...</span>
        </el-button>
      </el-form>


    </div>
  </div>
</template>

<script>
import { validUsername } from "@/utils/validate";

export default {
  name: "Login",
  data() {
    // 用户名验证
    const validateUsername = (rule, value, callback) => {
      if (!value) {
        callback(new Error("请输入用户名或邮箱"));
      } else {
        callback();
      }
    };
    
    // 密码验证
    const validatePassword = (rule, value, callback) => {
      if (!value) {
        callback(new Error("请输入密码"));
      } else {
        callback();
      }
    };
    
    // 邮箱验证码验证
    const validateEmailCode = (rule, value, callback) => {
      if (this.isEmailLogin && !value) {
        callback(new Error("请输入邮箱验证码"));
      } else if (this.isEmailLogin && value.length !== 4) {
        callback(new Error("验证码必须为4位"));
      } else {
        callback();
      }
    };
    
    // 滑动验证码验证
    const validateCaptcha = (rule, value, callback) => {
      if (!this.captchaVerified) {
        callback(new Error("请完成滑动验证"));
      } else {
        callback();
      }
    };
    

    
    return {
      loginForm: {
        username: "",
        password: "",
        emailCode: "",
        captcha: ""
      },
      loginRules: {
        username: [{ required: true, trigger: 'blur', validator: validateUsername }],
        password: [{ required: true, trigger: 'blur', validator: validatePassword }],
        emailCode: [{ validator: validateEmailCode, trigger: 'blur' }],
        captcha: [{ required: true, validator: validateCaptcha, trigger: 'change' }]
      },
      passwordType: "password",
      loading: false,
      redirect: undefined,
      otherQuery: {},
      
      // 邮箱相关
      isEmailLogin: false,
      sendingEmailCode: false,
      emailCodeDisabled: false,
      emailCodeCountdown: 0,
      emailCodeText: "发送验证码",
      
      // 滑动验证码相关
      captchaVerified: false,
      sliderProgress: 0,
      isDragging: false,
      startX: 0,
      

      
      // 其他
      rememberMe: false
    };
  },
  watch: {
    $route: {
      handler: function (route) {
        const query = route.query;
        if (query) {
          this.redirect = query.redirect;
          this.otherQuery = this.getOtherQuery(query);
        }
      },
      immediate: true,
    },
  },
  created() {
    // 初始化
  },
  mounted() {
    if (this.loginForm.username === "") {
      this.$refs.username.focus();
    }
  },
  methods: {
    // 检查邮箱格式
    checkEmailFormat() {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      this.isEmailLogin = emailRegex.test(this.loginForm.username);
    },
    
    // 切换密码显示
    togglePassword() {
      this.passwordType = this.passwordType === "password" ? "text" : "password";
    },
    
    // 滑动验证码相关方法
    startDrag(e) {
      if (this.captchaVerified) return;
      
      this.isDragging = true;
      this.startX = e.type === 'mousedown' ? e.clientX : e.touches[0].clientX;
      
      document.addEventListener('mousemove', this.onDrag);
      document.addEventListener('mouseup', this.endDrag);
      document.addEventListener('touchmove', this.onDrag);
      document.addEventListener('touchend', this.endDrag);
    },
    
    onDrag(e) {
      if (!this.isDragging) return;
      
      e.preventDefault();
      const currentX = e.type === 'mousemove' ? e.clientX : e.touches[0].clientX;
      const deltaX = currentX - this.startX;
      const trackWidth = this.$refs.sliderTrack.offsetWidth - 40; // 减去按钮宽度
      
      let progress = (deltaX / trackWidth) * 100;
      progress = Math.max(0, Math.min(100, progress));
      
      this.sliderProgress = progress;
    },
    
    endDrag() {
      if (!this.isDragging) return;
      
      this.isDragging = false;
      
      document.removeEventListener('mousemove', this.onDrag);
      document.removeEventListener('mouseup', this.endDrag);
      document.removeEventListener('touchmove', this.onDrag);
      document.removeEventListener('touchend', this.endDrag);
      
      if (this.sliderProgress >= 90) {
        this.sliderProgress = 100;
        this.captchaVerified = true;
        this.loginForm.captcha = 'verified';
        this.$message.success('验证成功');
      } else {
        this.sliderProgress = 0;
        this.captchaVerified = false;
        this.loginForm.captcha = '';
      }
    },
    
    // 重置滑动验证码
    resetCaptcha() {
      this.sliderProgress = 0;
      this.captchaVerified = false;
      this.loginForm.captcha = '';
      this.isDragging = false;
    },
    
    // 发送邮箱验证码
    async sendEmailCode() {
      if (!this.isEmailLogin) {
        this.$message.warning('请输入正确的邮箱地址');
        return;
      }
      
      this.sendingEmailCode = true;
      
      try {
        // 模拟发送邮箱验证码的API调用
        // 实际项目中应该调用真实的API
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        this.$message.success('验证码已发送到您的邮箱');
        this.startEmailCodeCountdown();
      } catch (error) {
        this.$message.error('验证码发送失败，请重试');
      } finally {
        this.sendingEmailCode = false;
      }
    },
    
    // 开始邮箱验证码倒计时
    startEmailCodeCountdown() {
      this.emailCodeDisabled = true;
      this.emailCodeCountdown = 60;
      
      const timer = setInterval(() => {
        this.emailCodeCountdown--;
        this.emailCodeText = `${this.emailCodeCountdown}s后重发`;
        
        if (this.emailCodeCountdown <= 0) {
          clearInterval(timer);
          this.emailCodeDisabled = false;
          this.emailCodeText = '发送验证码';
        }
      }, 1000);
    },
    
    // 处理登录
    handleLogin() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          this.loading = true;
          
          // 构建登录数据
          const loginData = {
            username: this.loginForm.username,
            password: this.loginForm.password,
            captcha: this.loginForm.captcha,
            rememberMe: this.rememberMe
          };
          
          // 如果是邮箱登录，添加邮箱验证码
          if (this.isEmailLogin) {
            loginData.emailCode = this.loginForm.emailCode;
          }
          
          this.$store
            .dispatch("user/login", loginData)
            .then(() => {
              this.$message.success('登录成功');
              this.$router.push({
                path: this.redirect || "/",
                query: this.otherQuery,
              });
            })
            .catch((error) => {
              this.$message.error(error.message || '登录失败');
              this.refreshCaptcha(); // 登录失败后刷新验证码
            })
            .finally(() => {
              this.loading = false;
            });
        }
      });
    },
    

    
    // 获取其他查询参数
    getOtherQuery(query) {
      return Object.keys(query).reduce((acc, cur) => {
        if (cur !== "redirect") {
          acc[cur] = query[cur];
        }
        return acc;
      }, {});
    },
    

  },
};
</script>

<style lang="scss" scoped>
// 现代登录界面样式
.modern-login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  overflow: hidden;
  
  // 背景装饰
  .background-decoration {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    
    .circle {
      position: absolute;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.1);
      animation: float 6s ease-in-out infinite;
      
      &.circle-1 {
        width: 200px;
        height: 200px;
        top: 10%;
        left: 10%;
        animation-delay: 0s;
      }
      
      &.circle-2 {
        width: 150px;
        height: 150px;
        top: 60%;
        right: 10%;
        animation-delay: 2s;
      }
      
      &.circle-3 {
        width: 100px;
        height: 100px;
        bottom: 20%;
        left: 20%;
        animation-delay: 4s;
      }
    }
  }
  
  // 登录卡片
  .login-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 20px;
    padding: 40px;
    width: 100%;
    max-width: 450px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    animation: slideUp 0.8s ease-out;
    
    // 头部
    .login-header {
      text-align: center;
      margin-bottom: 30px;
      
      .logo-section {
        margin-bottom: 20px;
        
        .logo {
          width: 60px;
          height: 60px;
          margin-bottom: 15px;
          border-radius: 12px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .system-title {
          font-size: 24px;
          font-weight: 600;
          color: #2c3e50;
          margin: 0;
          background: linear-gradient(135deg, #667eea, #764ba2);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }
      }
      
      .welcome-text {
        color: #7f8c8d;
        font-size: 16px;
        margin: 0;
      }
    }
    
    // 表单样式
    .login-form {
      .form-item {
        margin-bottom: 20px;
        
        .input-wrapper {
          position: relative;
          display: flex;
          align-items: center;
          background: #f8f9fa;
          border-radius: 12px;
          padding: 0 15px;
          transition: all 0.3s ease;
          border: 2px solid transparent;
          
          &:focus-within {
            background: #fff;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
          }
          
          .input-icon {
            color: #95a5a6;
            font-size: 18px;
            margin-right: 12px;
            transition: color 0.3s ease;
          }
          
          &:focus-within .input-icon {
            color: #667eea;
          }
          
          .modern-input {
            flex: 1;
            border: none;
            background: transparent;
            
            ::v-deep .el-input__inner {
              border: none;
              background: transparent;
              padding: 15px 0;
              font-size: 16px;
              color: #2c3e50;
              
              &::placeholder {
                color: #bdc3c7;
              }
              
              &:focus {
                box-shadow: none;
              }
            }
          }
          
          .password-toggle {
            color: #95a5a6;
            font-size: 18px;
            cursor: pointer;
            transition: color 0.3s ease;
            
            &:hover {
              color: #667eea;
            }
          }
          
          // 验证码相关样式
          &.verification-wrapper {
            .verification-input {
              flex: 1;
              margin-right: 10px;
            }
            
            .send-code-btn {
              background: linear-gradient(135deg, #667eea, #764ba2);
              border: none;
              color: white;
              padding: 8px 16px;
              border-radius: 8px;
              font-size: 14px;
              white-space: nowrap;
              transition: all 0.3s ease;
              
              &:hover:not(:disabled) {
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
              }
              
              &:disabled {
                background: #bdc3c7;
                cursor: not-allowed;
              }
            }
            
            .captcha-container {
              background: linear-gradient(135deg, #667eea, #764ba2);
              color: white;
              padding: 8px 16px;
              border-radius: 8px;
              cursor: pointer;
              display: flex;
              align-items: center;
              gap: 8px;
              font-weight: 600;
              letter-spacing: 2px;
              transition: all 0.3s ease;
              user-select: none;
              
              &:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
              }
              
              .captcha-text {
                font-size: 16px;
              }
              
              .refresh-icon {
                font-size: 14px;
                transition: transform 0.3s ease;
              }
              
              &:hover .refresh-icon {
                transform: rotate(180deg);
              }
            }
          }
        }
      }
      
      // 表单选项
      .form-options {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-bottom: 25px;
        
        .remember-checkbox {
          ::v-deep .el-checkbox__label {
            color: #7f8c8d;
            font-size: 14px;
          }
          
          ::v-deep .el-checkbox__input.is-checked .el-checkbox__inner {
            background-color: #667eea;
            border-color: #667eea;
          }
        }
        

      }
      
      // 登录按钮
      .login-btn {
        width: 100%;
        background: linear-gradient(135deg, #667eea, #764ba2);
        border: none;
        padding: 15px;
        border-radius: 12px;
        font-size: 16px;
        font-weight: 600;
        color: white;
        transition: all 0.3s ease;
        
        &:hover:not(:disabled) {
          transform: translateY(-2px);
          box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        &:active {
          transform: translateY(0);
        }
        
        &.is-loading {
          background: #bdc3c7;
        }
      }
    }
    
    // 底部
    .login-footer {
      text-align: center;
      margin-top: 25px;
      
      .register-link {
        color: #7f8c8d;
        font-size: 14px;
        margin: 0;
        
        a {
          color: #667eea;
          text-decoration: none;
          font-weight: 600;
          transition: color 0.3s ease;
          
          &:hover {
            color: #764ba2;
            text-decoration: underline;
          }
        }
      }
    }
  }
}

// 动画效果
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-20px);
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

// 滑动验证码样式
.slider-captcha-wrapper {
  display: flex;
  align-items: center;
  gap: 10px;
  
  .slider-captcha {
    flex: 1;
    
    .slider-track {
      position: relative;
      width: 100%;
      height: 40px;
      background: #f5f7fa;
      border-radius: 20px;
      border: 1px solid #e4e7ed;
      overflow: hidden;
      
      .slider-bg {
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        background: linear-gradient(135deg, #667eea, #764ba2);
        transition: width 0.3s ease;
        border-radius: 20px;
      }
      
      .slider-text {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        color: #909399;
        font-size: 14px;
        user-select: none;
        z-index: 1;
        
        &.verified {
          color: white;
        }
      }
      
      .slider-btn {
        position: absolute;
        top: 2px;
        left: 0;
        width: 36px;
        height: 36px;
        background: white;
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        transition: all 0.3s ease;
        z-index: 2;
        
        &:hover {
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        
        &.verified {
          background: #67c23a;
          color: white;
        }
        
        i {
          font-size: 14px;
          color: #909399;
        }
        
        &.verified i {
          color: white;
        }
      }
    }
  }
  
  .captcha-refresh {
    width: 40px;
    height: 40px;
    background: #f5f7fa;
    border: 1px solid #e4e7ed;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
    
    &:hover {
      background: #667eea;
      border-color: #667eea;
      color: white;
    }
    
    i {
      font-size: 16px;
      transition: transform 0.3s ease;
    }
    
    &:hover i {
      transform: rotate(180deg);
    }
  }
}



// 响应式设计
@media (max-width: 768px) {
  .modern-login-container {
    padding: 20px;
    
    .login-card {
      padding: 30px 20px;
      margin: 0 10px;
      
      .login-header {
        .logo-section {
          .system-title {
            font-size: 20px;
          }
        }
        
        .welcome-text {
          font-size: 14px;
        }
      }
    }
  }
  
  ::v-deep .el-dialog {
    width: 90% !important;
    margin: 5vh auto;
    
    .el-dialog__body {
      padding: 20px;
    }
  }
}

@media (max-width: 480px) {
  .modern-login-container {
    .login-card {
      .login-form {
        .form-item {
          .input-wrapper {
            &.verification-wrapper {
              flex-direction: column;
              gap: 10px;
              
              .verification-input {
                margin-right: 0;
              }
              
              .send-code-btn {
                width: 100%;
                justify-content: center;
              }
            }
          }
        }
        
        .form-options {
          flex-direction: column;
          gap: 15px;
          align-items: flex-start;
        }
      }
    }
  }
  
  .slider-captcha-wrapper {
    flex-direction: column;
    gap: 15px;
    
    .captcha-refresh {
      align-self: center;
    }
  }
}
</style>
