# 企业员工信息管理系统 - AI办公功能升级指南

## 升级概述

本次升级为企业员工信息管理系统集成了Spring AI框架，为所有角色添加了AI办公功能，提供智能化的办公辅助服务。

## 升级内容

### 1. 技术栈升级
- **Spring Boot**: 2.2.11.RELEASE → 3.2.5
- **Java版本**: 1.8 → 17
- **MyBatis Plus**: 3.0.5 → 3.5.3.1
- **Swagger**: SpringFox → SpringDoc OpenAPI 3
- **新增**: Spring AI 1.0.0-M2

### 2. 新增AI功能模块

#### 2.1 智能文档生成
- 支持多种文档类型：工作报告、会议纪要、通知公告等
- 基于模板的快速生成
- 自定义模板管理

#### 2.2 数据分析报告
- 员工绩效分析
- 部门效率分析
- 考勤统计分析
- 薪资结构分析

#### 2.3 智能问答助手
- 企业政策咨询
- 流程指导
- 问题解答

#### 2.4 邮件内容生成
- 规范化邮件模板
- 智能内容补全
- 多场景适配

#### 2.5 会议纪要生成
- 标准格式会议记录
- 关键信息提取
- 行动项跟踪

#### 2.6 工作计划制定
- 目标分解
- 时间安排
- 资源配置建议

### 3. 数据库增强

新增以下数据表：
- `ai_conversation_history` - AI对话历史记录
- `ai_document_template` - 文档模板管理
- `ai_function_usage_stats` - 功能使用统计
- `ai_knowledge_base` - AI知识库
- `ai_config` - AI配置管理

## 部署指南

### 1. 环境要求
- Java 17+
- MySQL 8.0+
- Maven 3.6+

### 2. 数据库升级
```sql
-- 执行数据库升级脚本
source 数据库/ai_office_enhancement.sql
```

### 3. 配置AI服务

#### 3.1 OpenAI配置（推荐）
```properties
# 设置环境变量或修改application.properties
OPENAI_API_KEY=your_openai_api_key
OPENAI_BASE_URL=https://api.openai.com
```

#### 3.2 本地AI模型配置（可选）
```properties
# 使用Ollama本地模型
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=llama2
```

### 4. 启动应用
```bash
cd personnel-backend
mvn clean install
mvn spring-boot:run
```

## API接口文档

启动后访问：http://localhost:8001/swagger-ui.html

### 主要接口

#### 1. 智能文档生成
```
POST /staff/ai-office/generate-document
{
  "documentType": "工作报告",
  "content": "本周完成项目开发任务",
  "department": "技术部",
  "userId": "user123"
}
```

#### 2. 智能问答
```
POST /staff/ai-office/intelligent-qa
{
  "question": "如何申请年假？",
  "context": "员工手册相关内容",
  "userId": "user123"
}
```

#### 3. 获取对话历史
```
GET /staff/ai-office/conversation-history/{userId}?limit=10
```

#### 4. 获取文档模板
```
GET /staff/ai-office/templates?templateType=工作报告
```

## 前端集成指南

### 1. 添加AI办公菜单
在前端路由中添加AI办公模块：
```javascript
{
  path: '/ai-office',
  component: Layout,
  meta: { title: 'AI办公', icon: 'ai' },
  children: [
    {
      path: 'document',
      name: 'AIDocument',
      component: () => import('@/views/ai-office/document'),
      meta: { title: '智能文档', icon: 'document' }
    },
    {
      path: 'qa',
      name: 'AIQA',
      component: () => import('@/views/ai-office/qa'),
      meta: { title: '智能问答', icon: 'question' }
    }
    // 其他AI功能页面...
  ]
}
```

### 2. API调用示例
```javascript
// 智能文档生成
export function generateDocument(data) {
  return request({
    url: '/staff/ai-office/generate-document',
    method: 'post',
    data
  })
}

// 智能问答
export function intelligentQA(data) {
  return request({
    url: '/staff/ai-office/intelligent-qa',
    method: 'post',
    data
  })
}
```

## 角色权限配置

所有角色都可以使用AI办公功能，但可以根据需要进行细化权限控制：

- **普通员工**: 基础AI功能（问答、简单文档生成）
- **部门主管**: 完整AI功能（包括数据分析、高级文档生成）
- **人事经理**: 全部AI功能 + 模板管理 + 使用统计
- **系统管理员**: 全部功能 + AI配置管理

## 使用限制

为了控制成本和确保服务质量，建议设置以下限制：
- 每用户每日最大使用次数：100次
- 单次请求最大token数：2000
- 请求超时时间：30秒

## 监控和维护

### 1. 使用统计
- 查看AI功能使用情况
- 分析用户行为模式
- 优化服务配置

### 2. 数据清理
```sql
-- 清理90天前的对话历史
CALL CleanExpiredAIHistory(90);
```

### 3. 性能监控
- 监控API响应时间
- 跟踪错误率
- 优化提示词模板

## 故障排除

### 常见问题

1. **AI服务无响应**
   - 检查API密钥配置
   - 验证网络连接
   - 查看应用日志

2. **生成内容质量不佳**
   - 优化提示词模板
   - 调整温度参数
   - 增加上下文信息

3. **数据库连接错误**
   - 确认数据库升级脚本已执行
   - 检查数据库连接配置
   - 验证表结构是否正确

## 后续优化建议

1. **功能扩展**
   - 添加语音转文字功能
   - 集成图像识别
   - 支持多语言

2. **性能优化**
   - 实现请求缓存
   - 添加负载均衡
   - 优化数据库查询

3. **用户体验**
   - 添加实时打字效果
   - 支持对话上下文
   - 个性化推荐

## 技术支持

如有问题，请联系技术团队或查看详细的API文档。

---

**升级完成时间**: 2024年12月
**版本**: v2.0.0-AI
**维护团队**: 企业信息化部门