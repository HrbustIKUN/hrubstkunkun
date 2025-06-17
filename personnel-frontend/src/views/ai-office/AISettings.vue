<template>
  <div class="ai-settings-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>AI设置</span>
      </div>
      
      <el-form ref="settingsForm" :model="settings" label-width="120px">
        <el-form-item label="API密钥">
          <el-input
            v-model="settings.apiKey"
            type="password"
            placeholder="请输入AI API密钥"
            show-password
          />
        </el-form-item>
        
        <el-form-item label="模型选择">
          <el-select v-model="settings.model" placeholder="请选择AI模型">
            <el-option label="GPT-3.5" value="gpt-3.5-turbo" />
            <el-option label="GPT-4" value="gpt-4" />
            <el-option label="Claude" value="claude" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="最大令牌数">
          <el-input-number
            v-model="settings.maxTokens"
            :min="100"
            :max="4000"
            :step="100"
          />
        </el-form-item>
        
        <el-form-item label="温度参数">
          <el-slider
            v-model="settings.temperature"
            :min="0"
            :max="2"
            :step="0.1"
            show-input
          />
        </el-form-item>
        
        <el-form-item label="启用功能">
          <el-checkbox-group v-model="settings.enabledFeatures">
            <el-checkbox label="document-generation">文档生成</el-checkbox>
            <el-checkbox label="data-analysis">数据分析</el-checkbox>
            <el-checkbox label="email-generation">邮件生成</el-checkbox>
            <el-checkbox label="meeting-minutes">会议纪要</el-checkbox>
            <el-checkbox label="work-plan">工作计划</el-checkbox>
            <el-checkbox label="intelligent-qa">智能问答</el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="saveSettings">保存设置</el-button>
          <el-button @click="resetSettings">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'AISettings',
  data() {
    return {
      settings: {
        apiKey: '',
        model: 'gpt-3.5-turbo',
        maxTokens: 2000,
        temperature: 0.7,
        enabledFeatures: [
          'document-generation',
          'data-analysis',
          'email-generation',
          'meeting-minutes',
          'work-plan',
          'intelligent-qa'
        ]
      }
    }
  },
  mounted() {
    this.loadSettings()
  },
  methods: {
    loadSettings() {
      // 加载AI设置
      console.log('加载AI设置')
    },
    saveSettings() {
      this.$message.success('设置保存成功')
    },
    resetSettings() {
      this.$refs.settingsForm.resetFields()
    }
  }
}
</script>

<style scoped>
.ai-settings-container {
  padding: 20px;
}

.box-card {
  max-width: 800px;
}
</style>