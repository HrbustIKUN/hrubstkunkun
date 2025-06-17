# 前端AI办公功能集成指南

## 概述

本指南详细说明如何在现有的Vue.js前端项目中集成AI办公功能，包括组件集成、路由配置、权限管理和状态管理等。

## 1. 文件结构

```
personnel-frontend/
├── src/
│   ├── views/ai-office/
│   │   └── AIOfficeIndex.vue          # AI办公主页面
│   ├── api/
│   │   └── ai-office.js               # AI办公API接口
│   ├── router/
│   │   └── ai-office.js               # AI办公路由配置
│   ├── permission/
│   │   └── ai-office.js               # AI办公权限配置
│   └── store/modules/
│       └── ai-office.js               # AI办公状态管理
```

## 2. 集成步骤

### 2.1 路由集成

在主路由文件中引入AI办公路由：

```javascript
// src/router/index.js
import aiOfficeRoutes from './ai-office'

const routes = [
  // 现有路由...
  ...aiOfficeRoutes
]
```

### 2.2 状态管理集成

在Vuex store中注册AI办公模块：

```javascript
// src/store/index.js
import aiOffice from './modules/ai-office'

const store = new Vuex.Store({
  modules: {
    // 现有模块...
    aiOffice
  }
})
```

### 2.3 权限中间件集成

在路由守卫中添加AI权限检查：

```javascript
// src/permission.js
import { hasAIPermission } from '@/permission/ai-office'

router.beforeEach(async (to, from, next) => {
  // 现有权限检查...
  
  // AI功能权限检查
  if (to.meta.aiPermission) {
    const userRole = store.getters.role
    if (!hasAIPermission(userRole, to.meta.aiPermission)) {
      next({ path: '/401' })
      return
    }
  }
  
  next()
})
```

### 2.4 菜单集成

在侧边栏菜单中添加AI办公入口：

```javascript
// src/layout/components/Sidebar/index.vue
<template>
  <div class="sidebar-container">
    <!-- 现有菜单项... -->
    
    <!-- AI办公菜单 -->
    <el-submenu index="ai-office" v-if="showAIOffice">
      <template slot="title">
        <i class="el-icon-cpu"></i>
        <span>AI智能办公</span>
      </template>
      <el-menu-item index="/ai-office/index">
        <i class="el-icon-chat-dot-round"></i>
        <span>AI办公助手</span>
      </el-menu-item>
      <!-- 更多AI功能菜单项... -->
    </el-submenu>
  </div>
</template>

<script>
import { getUserAIMenu } from '@/permission/ai-office'

export default {
  computed: {
    showAIOffice() {
      const userRole = this.$store.getters.role
      const aiMenu = getUserAIMenu(userRole)
      return aiMenu && aiMenu.length > 0
    }
  }
}
</script>
```

## 3. 环境配置

### 3.1 API基础URL配置

```javascript
// src/utils/request.js
const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API, // 确保指向后端API地址
  timeout: 30000 // AI请求可能需要更长时间
})
```

### 3.2 环境变量配置

```bash
# .env.development
VUE_APP_BASE_API = 'http://localhost:8080'
VUE_APP_AI_ENABLED = true
VUE_APP_AI_DEBUG = true

# .env.production
VUE_APP_BASE_API = 'https://your-api-domain.com'
VUE_APP_AI_ENABLED = true
VUE_APP_AI_DEBUG = false
```

## 4. 依赖安装

确保安装必要的依赖：

```bash
npm install axios vue-router vuex element-ui

# 如果需要Markdown渲染
npm install marked highlight.js

# 如果需要文件下载功能
npm install file-saver

# 如果需要复制到剪贴板功能
npm install clipboard
```

## 5. 用户认证集成

### 5.1 获取用户信息

确保在`src/utils/auth.js`中有获取用户信息的方法：

```javascript
// src/utils/auth.js
export function getUserInfo() {
  const userInfo = localStorage.getItem('userInfo')
  return userInfo ? JSON.parse(userInfo) : null
}

export function getUserRole() {
  const userInfo = getUserInfo()
  return userInfo ? userInfo.role : 'employee'
}

export function getUserId() {
  const userInfo = getUserInfo()
  return userInfo ? userInfo.id : null
}
```

### 5.2 Token管理

确保API请求包含认证token：

```javascript
// src/utils/request.js
service.interceptors.request.use(
  config => {
    const token = getToken()
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)
```

## 6. 样式和主题

### 6.1 AI办公主题样式

```css
/* src/styles/ai-office.scss */
.ai-office-container {
  .function-card {
    transition: all 0.3s ease;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(64, 158, 255, 0.15);
    }
    
    &.active {
      border-color: #409EFF;
      background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
    }
  }
  
  .chat-container {
    .message {
      &.user .message-content {
        background: linear-gradient(135deg, #409EFF 0%, #1890ff 100%);
      }
      
      &.ai .message-content {
        background: #f8f9fa;
        border: 1px solid #e9ecef;
      }
    }
  }
}
```

### 6.2 响应式设计

```css
/* 移动端适配 */
@media (max-width: 768px) {
  .ai-office-container {
    .function-grid {
      grid-template-columns: 1fr;
    }
    
    .el-col {
      margin-bottom: 20px;
    }
  }
}
```

## 7. 错误处理

### 7.1 全局错误处理

```javascript
// src/utils/error-handler.js
export function handleAIError(error) {
  console.error('AI功能错误:', error)
  
  if (error.response) {
    const { status, data } = error.response
    
    switch (status) {
      case 429:
        return '请求过于频繁，请稍后再试'
      case 503:
        return 'AI服务暂时不可用，请稍后再试'
      case 400:
        return data.message || '请求参数错误'
      default:
        return data.message || '服务器错误'
    }
  }
  
  return '网络连接错误，请检查网络设置'
}
```

### 7.2 组件错误边界

```javascript
// src/components/AIErrorBoundary.vue
<template>
  <div class="ai-error-boundary">
    <div v-if="hasError" class="error-container">
      <el-alert
        title="AI功能暂时不可用"
        :description="errorMessage"
        type="error"
        show-icon
        :closable="false">
      </el-alert>
      <el-button @click="retry" type="primary" style="margin-top: 16px">
        重试
      </el-button>
    </div>
    <slot v-else></slot>
  </div>
</template>
```

## 8. 性能优化

### 8.1 组件懒加载

```javascript
// 路由懒加载
const AIOfficeIndex = () => import('@/views/ai-office/AIOfficeIndex')
const DocumentGenerator = () => import('@/views/ai-office/DocumentGenerator')
```

### 8.2 API请求优化

```javascript
// 请求防抖
import { debounce } from 'lodash'

export default {
  methods: {
    askQuestion: debounce(function() {
      // AI问答逻辑
    }, 1000)
  }
}
```

## 9. 测试

### 9.1 单元测试示例

```javascript
// tests/unit/ai-office.spec.js
import { shallowMount } from '@vue/test-utils'
import AIOfficeIndex from '@/views/ai-office/AIOfficeIndex.vue'

describe('AIOfficeIndex.vue', () => {
  it('renders AI functions correctly', () => {
    const wrapper = shallowMount(AIOfficeIndex)
    expect(wrapper.find('.ai-office-container').exists()).toBe(true)
  })
})
```

### 9.2 E2E测试

```javascript
// tests/e2e/ai-office.spec.js
describe('AI Office', () => {
  it('should navigate to AI office page', () => {
    cy.visit('/ai-office')
    cy.contains('AI智能办公助手')
    cy.get('.function-card').should('have.length.greaterThan', 0)
  })
})
```

## 10. 部署注意事项

### 10.1 构建配置

```javascript
// vue.config.js
module.exports = {
  // 确保AI相关资源正确打包
  chainWebpack: config => {
    config.optimization.splitChunks({
      chunks: 'all',
      cacheGroups: {
        aiOffice: {
          name: 'chunk-ai-office',
          test: /[\\/]src[\\/].*ai-office/,
          minChunks: 1,
          priority: 20,
          reuseExistingChunk: true
        }
      }
    })
  }
}
```

### 10.2 CDN配置

```javascript
// 如果使用CDN加速
const cdn = {
  css: [
    'https://unpkg.com/element-ui/lib/theme-chalk/index.css'
  ],
  js: [
    'https://unpkg.com/vue@2.6.14/dist/vue.min.js',
    'https://unpkg.com/element-ui/lib/index.js'
  ]
}
```

## 11. 监控和日志

### 11.1 AI功能使用统计

```javascript
// src/utils/analytics.js
export function trackAIUsage(functionName, success, duration) {
  // 发送使用统计到分析服务
  if (window.gtag) {
    window.gtag('event', 'ai_function_used', {
      function_name: functionName,
      success: success,
      duration: duration
    })
  }
}
```

### 11.2 错误监控

```javascript
// src/utils/error-tracking.js
export function trackAIError(error, context) {
  // 发送错误信息到监控服务
  if (window.Sentry) {
    window.Sentry.captureException(error, {
      tags: {
        component: 'ai-office'
      },
      extra: context
    })
  }
}
```

## 12. 常见问题解决

### 12.1 CORS问题

如果遇到跨域问题，在开发环境中配置代理：

```javascript
// vue.config.js
module.exports = {
  devServer: {
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        pathRewrite: {
          '^/api': ''
        }
      }
    }
  }
}
```

### 12.2 权限问题

确保用户角色信息正确传递：

```javascript
// 在登录成功后初始化AI模块
this.$store.dispatch('aiOffice/initAIOffice')
```

### 12.3 性能问题

- 使用虚拟滚动处理大量历史记录
- 实现请求缓存减少重复请求
- 使用Web Workers处理大量数据

## 13. 升级和维护

### 13.1 版本兼容性

- 定期更新AI相关依赖
- 保持与后端API版本同步
- 测试新功能的兼容性

### 13.2 功能扩展

- 预留扩展接口
- 模块化设计便于添加新功能
- 保持代码结构清晰

---

## 总结

通过以上步骤，您可以成功将AI办公功能集成到现有的Vue.js前端项目中。集成完成后，用户将能够：

1. 使用智能问答功能
2. 生成各类办公文档
3. 进行数据分析
4. 管理对话历史
5. 根据角色权限访问不同功能

如有问题，请参考常见问题解决部分或联系技术支持。