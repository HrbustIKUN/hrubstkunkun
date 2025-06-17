# OpenAI API 配置指南

## 概述
本系统的AI办公功能需要连接到OpenAI API服务。请按照以下步骤配置您的OpenAI API密钥。

## 步骤1：获取OpenAI API密钥

1. 访问 [OpenAI官网](https://platform.openai.com/)
2. 注册或登录您的账户
3. 进入 [API Keys页面](https://platform.openai.com/api-keys)
4. 点击 "Create new secret key" 创建新的API密钥
5. 复制生成的API密钥（格式类似：sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx）

## 步骤2：设置环境变量

### Windows系统

#### 方法1：通过系统设置
1. 右键点击 "此电脑" → "属性"
2. 点击 "高级系统设置"
3. 点击 "环境变量"
4. 在 "用户变量" 或 "系统变量" 中点击 "新建"
5. 变量名：`OPENAI_API_KEY`
6. 变量值：您的OpenAI API密钥
7. 点击 "确定" 保存

#### 方法2：通过命令行（临时设置）
```cmd
set OPENAI_API_KEY=your_api_key_here
```

#### 方法3：通过PowerShell（临时设置）
```powershell
$env:OPENAI_API_KEY="your_api_key_here"
```

### macOS/Linux系统

#### 临时设置（当前会话有效）
```bash
export OPENAI_API_KEY="your_api_key_here"
```

#### 永久设置
将以下行添加到 `~/.bashrc` 或 `~/.zshrc` 文件中：
```bash
export OPENAI_API_KEY="your_api_key_here"
```

然后执行：
```bash
source ~/.bashrc  # 或 source ~/.zshrc
```

## 步骤3：验证配置

1. 重启您的IDE或命令行终端
2. 启动后端服务：
   ```bash
   cd personnel-backend
   mvn spring-boot:run
   ```
3. 查看控制台输出，确认没有AI服务相关的错误信息

## 步骤4：测试AI功能

1. 启动前端服务：
   ```bash
   cd personnel-frontend
   npm run dev
   ```
2. 访问 http://localhost:9528
3. 进入 "AI智能办公" 模块
4. 尝试使用任一AI功能（如邮件生成、文档生成等）

## 故障排除

### 常见问题

1. **API密钥无效**
   - 确认API密钥格式正确（以sk-开头）
   - 确认API密钥未过期
   - 确认OpenAI账户有足够的使用额度

2. **环境变量未生效**
   - 确认环境变量名称正确：`OPENAI_API_KEY`
   - 重启IDE和命令行终端
   - 检查环境变量是否正确设置：
     ```bash
     echo $OPENAI_API_KEY  # macOS/Linux
     echo %OPENAI_API_KEY%  # Windows CMD
     echo $env:OPENAI_API_KEY  # Windows PowerShell
     ```

3. **网络连接问题**
   - 确认网络可以访问 https://api.openai.com
   - 如果在中国大陆，可能需要配置代理或使用API代理服务

4. **Spring Boot启动错误**
   - 检查控制台错误信息
   - 确认Spring AI依赖正确安装
   - 确认Java版本兼容（推荐Java 17+）

### 日志检查

如果遇到问题，请检查后端服务的日志输出：
- 查找包含 "AI" 或 "OpenAI" 的错误信息
- 查找Spring Boot启动时的配置信息

## 安全注意事项

1. **保护API密钥**
   - 不要将API密钥提交到代码仓库
   - 不要在公共场所分享API密钥
   - 定期轮换API密钥

2. **使用限制**
   - 监控API使用量和费用
   - 设置合理的使用限制
   - 考虑为不同环境使用不同的API密钥

## 支持

如果您在配置过程中遇到问题，请：
1. 检查本指南的故障排除部分
2. 查看OpenAI官方文档
3. 联系系统管理员或开发团队

---

**注意**：OpenAI API是付费服务，请确保您的账户有足够的使用额度。建议在测试阶段设置使用限制以避免意外费用。