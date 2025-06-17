# DeepSeek API 配置指南

本指南将帮助您配置 DeepSeek API，以便在企业员工信息管理系统中使用 AI 智能办公功能。

## 📋 前提条件

- 已获取 DeepSeek API 密钥
- Java 8+ 环境
- Maven 3.6+

## 🔑 您的 DeepSeek API 密钥

您提供的 API 密钥：`sk-a510d3fe75324c44906fd90423b9cb82`

## ⚙️ 配置步骤

### 1. 设置环境变量

#### Windows 系统（推荐方法）：

**方法1：通过系统设置**
1. 右键点击 "此电脑" → "属性"
2. 点击 "高级系统设置"
3. 点击 "环境变量"
4. 在 "用户变量" 中点击 "新建"
5. 变量名：`OPENAI_API_KEY`
6. 变量值：`sk-a510d3fe75324c44906fd90423b9cb82`
7. 点击 "确定" 保存
8. **重启您的 IDE 和命令行终端**

**方法2：通过 PowerShell（临时设置）**
```powershell
$env:OPENAI_API_KEY="sk-a510d3fe75324c44906fd90423b9cb82"
```

#### Linux/macOS 系统：

**临时设置（当前会话）：**
```bash
export OPENAI_API_KEY="sk-a510d3fe75324c44906fd90423b9cb82"
```

**永久设置：**
```bash
echo 'export OPENAI_API_KEY="sk-a510d3fe75324c44906fd90423b9cb82"' >> ~/.bashrc
source ~/.bashrc
```

### 2. 验证配置

启动后端服务前，验证环境变量是否设置成功：

**Windows PowerShell：**
```powershell
echo $env:OPENAI_API_KEY
```

**Linux/macOS：**
```bash
echo $OPENAI_API_KEY
```

应该输出您的 API 密钥。

### 3. 启动服务

#### 启动后端服务：
```bash
cd personnel-backend
mvn spring-boot:run
```

#### 启动前端服务：
```bash
cd personnel-frontend
npm run dev
```

### 4. 测试 AI 功能

1. 打开浏览器访问：http://localhost:9528
2. 登录系统
3. 进入 "AI智能办公" 模块
4. 测试以下功能：
   - 📧 邮件生成
   - 📄 文档生成
   - 📊 数据分析
   - 📝 会议纪要
   - 📋 工作计划
   - ❓ 智能问答

## 🔧 配置详情

### DeepSeek API 配置

系统已配置为使用 DeepSeek API，相关配置如下：

- **API 基础URL**: `https://api.deepseek.com`
- **模型**: `deepseek-chat`
- **温度**: `0.7`
- **最大令牌数**: `2000`

### 兼容性说明

DeepSeek API 完全兼容 OpenAI 接口规范，因此：
- 无需修改现有代码
- 所有 AI 功能正常工作
- 支持相同的参数和响应格式

## 🚨 故障排除

### 常见问题

1. **服务启动失败**
   - 确认环境变量设置正确
   - 重启 IDE 和终端
   - 检查 API 密钥格式

2. **AI 功能无响应**
   - 检查网络连接
   - 验证 API 密钥有效性
   - 查看后端日志错误信息

3. **环境变量未生效**
   - Windows：重启 IDE 和命令行
   - Linux/macOS：执行 `source ~/.bashrc`

### 日志检查

查看后端服务日志，寻找以下关键信息：
- Spring AI 初始化日志
- ChatClient 创建日志
- API 调用错误信息

## 💡 使用建议

1. **API 密钥安全**
   - 不要将密钥提交到代码仓库
   - 定期轮换 API 密钥
   - 监控 API 使用量

2. **性能优化**
   - 根据需要调整 `max-tokens` 参数
   - 合理设置 `temperature` 值
   - 监控响应时间

3. **成本控制**
   - 监控 API 调用频率
   - 设置合理的令牌限制
   - 定期检查账单

## 📞 技术支持

如果遇到问题，请检查：
1. 环境变量配置
2. 网络连接状态
3. API 密钥有效性
4. 后端服务日志

---

**注意**: DeepSeek API 提供高质量的 AI 服务，完全兼容 OpenAI 接口，是一个优秀的 AI 解决方案选择。