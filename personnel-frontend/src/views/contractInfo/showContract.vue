
<template>
  <div class="contract-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <h1 class="page-title">
        <i class="el-icon-document"></i>
        我的合同信息
      </h1>
      <p class="page-subtitle">查看您的所有合同详情</p>
    </div>

    <!-- 加载状态 -->
    <div v-if="loading" class="loading-container">
      <el-skeleton :rows="3" animated />
    </div>

    <!-- 空状态 -->
    <div v-else-if="!contractList || contractList.length === 0" class="empty-state">
      <div class="empty-icon">
        <i class="el-icon-document-remove"></i>
      </div>
      <h3>暂无合同信息</h3>
      <p>您目前还没有任何合同记录</p>
    </div>

    <!-- 合同列表 -->
    <div v-else class="contract-grid">
      <div 
        v-for="(item, index) in contractList" 
        :key="index"
        class="contract-card-wrapper"
        :style="{ animationDelay: index * 0.1 + 's' }"
      >
        <el-card class="contract-card" shadow="hover">
          <!-- 合同状态标签 -->
          <div class="status-badge" :class="getStatusClass(item)">
            {{ getStatusText(item) }}
          </div>
          
          <!-- 合同图片 -->
          <div class="contract-image-wrapper">
            <img 
              :src="baseApi + item.photo" 
              class="contract-image" 
              @error="handleImageError"
              alt="合同文件"
            />
            <div class="image-overlay">
              <el-button 
                type="primary" 
                icon="el-icon-view" 
                circle 
                @click="previewContract(item)"
              ></el-button>
            </div>
          </div>
          
          <!-- 合同信息 -->
          <div class="contract-info">
            <h3 class="contract-title">{{ item.name }}</h3>
            
            <div class="contract-details">
              <div class="detail-item">
                <i class="el-icon-calendar"></i>
                <span class="label">签约日期：</span>
                <span class="value">{{ formatDate(item.startTime) }}</span>
              </div>
              
              <div class="detail-item">
                <i class="el-icon-time"></i>
                <span class="label">到期日期：</span>
                <span class="value" :class="getExpiryClass(item)">{{ formatDate(item.endTime) }}</span>
              </div>
              
              <div class="detail-item">
                <i class="el-icon-timer"></i>
                <span class="label">剩余天数：</span>
                <span class="value" :class="getExpiryClass(item)">{{ getRemainingDays(item.endTime) }}天</span>
              </div>
            </div>
            
            <!-- 操作按钮 -->
            <div class="contract-actions">
              <el-button 
                type="primary" 
                size="small" 
                icon="el-icon-view"
                @click="previewContract(item)"
              >
                查看详情
              </el-button>
              <el-button 
                type="success" 
                size="small" 
                icon="el-icon-download"
                @click="downloadContract(item)"
              >
                下载
              </el-button>
            </div>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 合同预览对话框 -->
    <el-dialog
      title="合同预览"
      :visible.sync="previewVisible"
      width="80%"
      center
    >
      <div class="preview-container">
         <img 
           v-if="currentContract"
           :src="baseApi + currentContract.photo" 
           class="preview-image"
           alt="合同预览"
         />
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="previewVisible = false">关闭</el-button>
        <el-button type="primary" @click="downloadContract(currentContract)">下载合同</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import contract from "@/api/contract";

export default {
  name: 'ShowContract',
  data() {
    return {
      baseApi: process.env.VUE_APP_BASE_API,
      contractList: [],
      loading: true,
      previewVisible: false,
      currentContract: null
    };
  },
  created() {
    this.getContractList();
  },
  methods: {
    // 获取合同列表
    async getContractList() {
      try {
        this.loading = true;
        console.log('开始获取个人合同信息');
        const response = await contract.getClerkThrough();
        console.log('个人合同API响应:', response.data);
        this.contractList = response.data.contractList || [];
      } catch (error) {
        console.error('个人合同API错误:', error);
        this.$message.error('获取合同信息失败');
        this.contractList = [];
      } finally {
        this.loading = false;
      }
    },
    
    // 格式化日期
    formatDate(dateString) {
      if (!dateString) return '-';
      const date = new Date(dateString);
      return date.toLocaleDateString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
      });
    },
    
    // 获取剩余天数
     getRemainingDays(endDate) {
       if (!endDate) return '-';
       const today = new Date();
       const end = new Date(endDate);
       const diffTime = end - today;
       const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
       return diffDays > 0 ? diffDays : 0;
     },
     
     // 获取状态样式类
     getStatusClass(item) {
       const remainingDays = this.getRemainingDays(item.endTime);
       if (remainingDays <= 0) return 'expired';
       if (remainingDays <= 30) return 'warning';
       return 'active';
     },
     
     // 获取状态文本
     getStatusText(item) {
       const remainingDays = this.getRemainingDays(item.endTime);
       if (remainingDays <= 0) return '已过期';
       if (remainingDays <= 30) return '即将到期';
       return '有效';
     },
     
     // 获取到期日期样式类
     getExpiryClass(item) {
       const remainingDays = this.getRemainingDays(item.endTime);
       if (remainingDays <= 0) return 'expired-text';
       if (remainingDays <= 30) return 'warning-text';
       return 'normal-text';
     },
    
    // 预览合同
    previewContract(item) {
      this.currentContract = item;
      this.previewVisible = true;
    },
    
    // 下载合同
     downloadContract(item) {
       if (!item.photo) {
         this.$message.warning('合同文件不存在');
         return;
       }
       const link = document.createElement('a');
       link.href = this.baseApi + item.photo;
       link.download = item.name + '.png';
       link.target = '_blank';
       document.body.appendChild(link);
       link.click();
       document.body.removeChild(link);
       this.$message.success('开始下载合同文件');
     },
    
    // 图片加载错误处理
     handleImageError(event) {
       event.target.src = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MDAiIGhlaWdodD0iMjAwIiB2aWV3Qm94PSIwIDAgNDAwIDIwMCI+CiAgPHJlY3Qgd2lkdGg9IjQwMCIgaGVpZ2h0PSIyMDAiIGZpbGw9IiNmNWY1ZjUiLz4KICA8ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgyMDAsMTAwKSI+CiAgICA8Y2lyY2xlIGN4PSIwIiBjeT0iLTIwIiByPSIyNSIgZmlsbD0iI2RkZCIvPgogICAgPHBhdGggZD0iTS0xNSwtMTAgTDE1LC0xMCBMMTUsMjAgTC0xNSwyMCBaIiBmaWxsPSIjZGRkIi8+CiAgICA8dGV4dCB4PSIwIiB5PSI0NSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZm9udC1mYW1pbHk9IkFyaWFsLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjE0IiBmaWxsPSIjOTk5Ij7lkIjlkIzmlofku7Y8L3RleHQ+CiAgPC9nPgo8L3N2Zz4=';
     }
  }
};
</script>
<style scoped>
.contract-container {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: calc(100vh - 84px);
}

/* 页面标题 */
.page-header {
  text-align: center;
  margin-bottom: 40px;
  padding: 30px 0;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.page-title {
  font-size: 32px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 10px 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
}

.page-title i {
  font-size: 36px;
  color: #409eff;
}

.page-subtitle {
  font-size: 16px;
  color: #7f8c8d;
  margin: 0;
}

/* 加载状态 */
.loading-container {
  padding: 40px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 20px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.empty-icon {
  font-size: 80px;
  color: #ddd;
  margin-bottom: 20px;
}

.empty-state h3 {
  color: #666;
  margin: 0 0 10px 0;
}

.empty-state p {
  color: #999;
  margin: 0;
}

/* 合同网格 */
.contract-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 30px;
  padding: 20px 0;
}

/* 合同卡片包装器 */
.contract-card-wrapper {
  animation: slideInUp 0.6s ease-out forwards;
  opacity: 0;
  transform: translateY(30px);
}

@keyframes slideInUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 合同卡片 */
.contract-card {
  border-radius: 16px;
  overflow: hidden;
  transition: all 0.3s ease;
  border: none;
  position: relative;
}

.contract-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

/* 状态标签 */
.status-badge {
  position: absolute;
  top: 15px;
  right: 15px;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  z-index: 2;
  color: white;
}

.status-badge.active {
  background: linear-gradient(45deg, #67c23a, #85ce61);
}

.status-badge.warning {
  background: linear-gradient(45deg, #e6a23c, #f0a020);
}

.status-badge.expired {
  background: linear-gradient(45deg, #f56c6c, #f78989);
}

/* 合同图片 */
.contract-image-wrapper {
  position: relative;
  height: 200px;
  overflow: hidden;
  background: #f8f9fa;
}

.contract-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.contract-card:hover .contract-image {
  transform: scale(1.05);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.contract-card:hover .image-overlay {
  opacity: 1;
}

/* 合同信息 */
.contract-info {
  padding: 24px;
}

.contract-title {
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 20px 0;
  line-height: 1.4;
}

/* 详情项 */
.contract-details {
  margin-bottom: 24px;
}

.detail-item {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
  font-size: 14px;
}

.detail-item i {
  color: #409eff;
  margin-right: 8px;
  width: 16px;
}

.detail-item .label {
  color: #666;
  margin-right: 8px;
  min-width: 80px;
}

.detail-item .value {
  font-weight: 500;
}

.normal-text {
  color: #2c3e50;
}

.warning-text {
  color: #e6a23c;
  font-weight: 600;
}

.expired-text {
  color: #f56c6c;
  font-weight: 600;
}

/* 操作按钮 */
.contract-actions {
  display: flex;
  gap: 12px;
}

.contract-actions .el-button {
  flex: 1;
  border-radius: 8px;
  font-weight: 500;
}

/* 预览对话框 */
.preview-container {
  text-align: center;
  max-height: 70vh;
  overflow: auto;
}

.preview-image {
  max-width: 100%;
  max-height: 100%;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .contract-container {
    padding: 15px;
  }
  
  .contract-grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }
  
  .page-title {
    font-size: 24px;
  }
  
  .contract-actions {
    flex-direction: column;
  }
}

/* Element UI 样式覆盖 */
.el-card__body {
  padding: 0 !important;
}

.el-dialog__header {
  background: linear-gradient(135deg, #409eff, #67c23a);
  color: white;
  border-radius: 8px 8px 0 0;
}

.el-dialog__title {
  color: white;
  font-weight: 600;
}

.el-dialog__headerbtn .el-dialog__close {
  color: white;
}
</style>

