<template>
  <div class="conversation-history-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>对话历史</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="clearHistory">清空历史</el-button>
      </div>
      
      <!-- 搜索和筛选 -->
      <div class="filter-section">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索对话内容"
              prefix-icon="el-icon-search"
              @input="handleSearch"
            />
          </el-col>
          <el-col :span="6">
            <el-select v-model="selectedFunction" placeholder="选择功能类型" @change="handleFilter">
              <el-option label="全部" value="" />
              <el-option label="文档生成" value="document-generation" />
              <el-option label="数据分析" value="data-analysis" />
              <el-option label="邮件生成" value="email-generation" />
              <el-option label="会议纪要" value="meeting-minutes" />
              <el-option label="工作计划" value="work-plan" />
              <el-option label="智能问答" value="intelligent-qa" />
            </el-select>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              @change="handleFilter"
            />
          </el-col>
        </el-row>
      </div>
      
      <!-- 对话列表 -->
      <div class="conversation-list">
        <el-timeline>
          <el-timeline-item
            v-for="conversation in filteredConversations"
            :key="conversation.id"
            :timestamp="conversation.createdAt"
            placement="top"
          >
            <el-card class="conversation-item">
              <div class="conversation-header">
                <span class="function-tag">{{ getFunctionName(conversation.functionType) }}</span>
                <span class="session-id">会话ID: {{ conversation.sessionId }}</span>
              </div>
              <div class="conversation-content">
                <div class="user-message">
                  <strong>用户:</strong> {{ conversation.userMessage }}
                </div>
                <div class="ai-response">
                  <strong>AI:</strong> {{ conversation.aiResponse }}
                </div>
              </div>
              <div class="conversation-actions">
                <el-button size="mini" @click="viewDetail(conversation)">查看详情</el-button>
                <el-button size="mini" type="danger" @click="deleteConversation(conversation.id)">删除</el-button>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </div>
      
      <!-- 分页 -->
      <div class="pagination-section">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
        />
      </div>
    </el-card>
    
    <!-- 详情对话框 -->
    <el-dialog title="对话详情" :visible.sync="detailDialogVisible" width="60%">
      <div v-if="selectedConversation">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="会话ID">{{ selectedConversation.sessionId }}</el-descriptions-item>
          <el-descriptions-item label="功能类型">{{ getFunctionName(selectedConversation.functionType) }}</el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ selectedConversation.createdAt }}</el-descriptions-item>
          <el-descriptions-item label="用户ID">{{ selectedConversation.userId }}</el-descriptions-item>
        </el-descriptions>
        <div class="detail-content">
          <h4>用户消息:</h4>
          <p>{{ selectedConversation.userMessage }}</p>
          <h4>AI回复:</h4>
          <p>{{ selectedConversation.aiResponse }}</p>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'ConversationHistory',
  data() {
    return {
      conversations: [],
      filteredConversations: [],
      searchKeyword: '',
      selectedFunction: '',
      dateRange: [],
      currentPage: 1,
      pageSize: 20,
      total: 0,
      detailDialogVisible: false,
      selectedConversation: null,
      functionMap: {
        'document-generation': '文档生成',
        'data-analysis': '数据分析',
        'email-generation': '邮件生成',
        'meeting-minutes': '会议纪要',
        'work-plan': '工作计划',
        'intelligent-qa': '智能问答'
      }
    }
  },
  mounted() {
    this.loadConversations()
  },
  methods: {
    loadConversations() {
      // 模拟数据
      this.conversations = [
        {
          id: 1,
          sessionId: 'session_001',
          functionType: 'document-generation',
          userMessage: '帮我生成一份项目报告',
          aiResponse: '好的，我来帮您生成项目报告...',
          userId: 'user001',
          createdAt: '2024-01-15 10:30:00'
        }
      ]
      this.filteredConversations = [...this.conversations]
      this.total = this.conversations.length
    },
    handleSearch() {
      this.filterConversations()
    },
    handleFilter() {
      this.filterConversations()
    },
    filterConversations() {
      let filtered = [...this.conversations]
      
      if (this.searchKeyword) {
        filtered = filtered.filter(conv => 
          conv.userMessage.includes(this.searchKeyword) || 
          conv.aiResponse.includes(this.searchKeyword)
        )
      }
      
      if (this.selectedFunction) {
        filtered = filtered.filter(conv => conv.functionType === this.selectedFunction)
      }
      
      this.filteredConversations = filtered
      this.total = filtered.length
    },
    getFunctionName(functionType) {
      return this.functionMap[functionType] || functionType
    },
    viewDetail(conversation) {
      this.selectedConversation = conversation
      this.detailDialogVisible = true
    },
    deleteConversation(id) {
      this.$confirm('确认删除这条对话记录?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$message.success('删除成功')
        this.loadConversations()
      })
    },
    clearHistory() {
      this.$confirm('确认清空所有对话历史?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$message.success('清空成功')
        this.conversations = []
        this.filteredConversations = []
        this.total = 0
      })
    },
    handleSizeChange(val) {
      this.pageSize = val
      this.loadConversations()
    },
    handleCurrentChange(val) {
      this.currentPage = val
      this.loadConversations()
    }
  }
}
</script>

<style scoped>
.conversation-history-container {
  padding: 20px;
}

.filter-section {
  margin-bottom: 20px;
}

.conversation-list {
  margin: 20px 0;
}

.conversation-item {
  margin-bottom: 10px;
}

.conversation-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.function-tag {
  background: #409EFF;
  color: white;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.session-id {
  color: #909399;
  font-size: 12px;
}

.conversation-content {
  margin: 10px 0;
}

.user-message, .ai-response {
  margin: 5px 0;
  padding: 8px;
  border-radius: 4px;
}

.user-message {
  background: #f0f9ff;
}

.ai-response {
  background: #f0f0f0;
}

.conversation-actions {
  text-align: right;
}

.pagination-section {
  text-align: center;
  margin-top: 20px;
}

.detail-content {
  margin-top: 20px;
}

.detail-content h4 {
  margin: 15px 0 5px 0;
  color: #303133;
}

.detail-content p {
  background: #f5f5f5;
  padding: 10px;
  border-radius: 4px;
  margin: 5px 0;
}
</style>