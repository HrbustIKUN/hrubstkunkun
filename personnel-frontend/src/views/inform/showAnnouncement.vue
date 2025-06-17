<template>
  <div class="announcement-container">
    <div class="announcement-card">
      <div class="announcement-header">
        <h1 class="announcement-title">{{ announcement.title }}</h1>
        <div class="announcement-meta">
          <i class="el-icon-time"></i>
          <span class="announcement-time">{{ formatTime(announcement.time) }}</span>
        </div>
      </div>
      <div class="announcement-divider"></div>
      <div class="announcement-content" v-html="announcement.content"></div>
      <div class="announcement-footer">
        <el-button type="primary" @click="goBack">
          <i class="el-icon-back"></i>
          返回列表
        </el-button>
      </div>
    </div>
  </div>
</template>

<script>
import announcement from "@/api/announcement";
export default {
  data() {
    return {
      announcement: {},
    };
  },
  created() {
    this.init();
  },
  watch: {
    //监听
    $route(to, from) {
      //路由发生变化 方法就会执行
      this.init();
    },
  },

  methods: {
    //初始化
    init() {
      //判断路径中是否有id值
      if (this.$route.params && this.$route.params.id) {
        const id = this.$route.params.id;
        this.getAnnouncementById(id);
      } else {
        //清空表单
        this.$router.push({ path: "/" });
      }
    },
    //根据id查询
    getAnnouncementById(id) {
      announcement
        .getAnnouncementById(id)
        .then((response) => {
          this.announcement = response.data.announcement;
        })
        .catch((error) => {});
    },
    //格式化时间
    formatTime(time) {
      if (!time) return '';
      const date = new Date(time);
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      });
    },
    //返回列表
    goBack() {
      this.$router.go(-1);
    }
  },
};
</script>
<style scoped>
.announcement-container {
  min-height: 100vh;
  background: white;
  padding: 20px;
  display: flex;
  justify-content: center;
  align-items: flex-start;
}

.announcement-card {
  background: white;
  border-radius: 15px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  max-width: 800px;
  width: 100%;
  margin-top: 40px;
  overflow: hidden;
  animation: slideUp 0.6s ease-out;
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

.announcement-header {
  padding: 30px 40px 20px;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
}

.announcement-title {
  font-size: 28px;
  font-weight: 600;
  margin: 0 0 15px 0;
  line-height: 1.3;
}

.announcement-meta {
  display: flex;
  align-items: center;
  font-size: 14px;
  opacity: 0.9;
}

.announcement-meta i {
  margin-right: 8px;
  font-size: 16px;
}

.announcement-time {
  font-weight: 500;
}

.announcement-divider {
  height: 4px;
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
}

.announcement-content {
  padding: 40px;
  font-size: 16px;
  line-height: 1.8;
  color: #333;
  min-height: 200px;
}

.announcement-content ::v-deep p {
  margin-bottom: 16px;
}

.announcement-content ::v-deep h1,
.announcement-content ::v-deep h2,
.announcement-content ::v-deep h3 {
  color: #2c3e50;
  margin-top: 24px;
  margin-bottom: 16px;
}

.announcement-footer {
  padding: 20px 40px 30px;
  text-align: center;
  background: #f8f9fa;
}

.announcement-footer .el-button {
  padding: 12px 30px;
  font-size: 14px;
  border-radius: 25px;
  transition: all 0.3s ease;
}

.announcement-footer .el-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(64, 158, 255, 0.3);
}
</style>
