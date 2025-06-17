<template>
  <div class="leave-application-container">
    <div class="leave-form-card">
      <div class="form-header">
        <h2><i class="el-icon-edit-outline"></i> 请假申请</h2>
        <p>请填写以下信息提交请假申请</p>
      </div>
      
      <el-form 
        :model="leaveForm" 
        :rules="rules" 
        ref="leaveForm" 
        label-width="100px"
        class="leave-form"
      >
        <el-form-item label="请假类型" prop="leaveType">
          <el-radio-group v-model="leaveForm.leaveType">
            <el-radio label="1" class="leave-radio">
              <i class="el-icon-user"></i> 事假
            </el-radio>
            <el-radio label="4" class="leave-radio">
              <i class="el-icon-first-aid-kit"></i> 病假
            </el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="请假日期" prop="leaveDate">
          <el-date-picker
            v-model="leaveForm.leaveDate"
            type="date"
            placeholder="选择请假日期"
            value-format="yyyy-MM-dd"
            style="width: 100%"
            :picker-options="pickerOptions"
          >
          </el-date-picker>
        </el-form-item>

        <el-form-item label="请假原因" prop="reason">
          <el-input
            v-model="leaveForm.reason"
            type="textarea"
            :rows="4"
            placeholder="请详细说明请假原因"
            maxlength="200"
            show-word-limit
          >
          </el-input>
        </el-form-item>

        <el-form-item class="form-buttons">
          <el-button 
            type="primary" 
            @click="submitApplication"
            :loading="submitting"
            class="submit-btn"
          >
            <i class="el-icon-check"></i>
            提交申请
          </el-button>
          <el-button @click="resetForm" class="reset-btn">
            <i class="el-icon-refresh"></i>
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 我的请假记录 -->
    <div class="leave-records-card">
      <div class="records-header">
        <h3><i class="el-icon-document"></i> 我的请假记录</h3>
        <el-button 
          type="text" 
          @click="refreshRecords"
          :loading="loading"
        >
          <i class="el-icon-refresh"></i> 刷新
        </el-button>
      </div>

      <el-table 
        :data="leaveRecords" 
        stripe 
        style="width: 100%"
        v-loading="loading"
      >
        <el-table-column prop="status" label="类型">
          <template slot-scope="scope">
            <el-tag :type="getTypeTagType(scope.row.status)">
              {{ getTypeText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="time" label="请假日期" width="120">
          <template slot-scope="scope">
            {{ formatDate(scope.row.time) }}
          </template>
        </el-table-column>
        <el-table-column prop="reason" label="请假原因" show-overflow-tooltip>
        </el-table-column>
        <el-table-column prop="audit" label="审核状态" width="100">
          <template slot-scope="scope">
            <el-tag 
              :type="scope.row.audit === 1 ? 'success' : scope.row.audit === 2 ? 'danger' : 'info'"
            >
              {{ getAuditStatusText(scope.row.audit) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="gmtCreate" label="申请时间" width="150">
          <template slot-scope="scope">
            {{ formatTime(scope.row.gmtCreate) }}
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <el-pagination
        :current-page="currentPage"
        :page-size="pageSize"
        :total="total"
        layout="total, prev, pager, next, jumper"
        @current-change="handlePageChange"
        style="margin-top: 20px; text-align: center"
      >
      </el-pagination>
    </div>
  </div>
</template>

<script>
import attendance from '@/api/attendance'

export default {
  name: 'LeaveApplication',
  data() {
    return {
      leaveForm: {
        leaveType: '1',
        leaveDate: '',
        reason: ''
      },
      rules: {
        leaveType: [
          { required: true, message: '请选择请假类型', trigger: 'change' }
        ],
        leaveDate: [
          { required: true, message: '请选择请假日期', trigger: 'change' }
        ],
        reason: [
          { required: true, message: '请填写请假原因', trigger: 'blur' },
          { min: 5, max: 200, message: '请假原因长度在 5 到 200 个字符', trigger: 'blur' }
        ]
      },
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < Date.now() - 8.64e7 // 不能选择昨天之前的日期
        }
      },
      submitting: false,
      loading: false,
      leaveRecords: [],
      currentPage: 1,
      pageSize: 10,
      total: 0
    }
  },
  created() {
    this.getLeaveRecords()
  },
  methods: {
    // 提交请假申请
    submitApplication() {
      this.$refs.leaveForm.validate((valid) => {
        if (valid) {
          this.submitting = true
          
          const attendanceData = {
            type: parseInt(this.leaveForm.leaveType),
            time: this.leaveForm.leaveDate + ' 08:00:00',
            reason: this.leaveForm.reason,
            audit: 0 // 待审核
          }
          
          attendance.addAttendanceByEmployee(attendanceData)
            .then(response => {
              this.$message.success('请假申请提交成功，等待审核')
              this.resetForm()
              this.getLeaveRecords() // 刷新记录
            })
            .catch(error => {
              this.$message.error('提交失败，请重试')
              console.error(error)
            })
            .finally(() => {
              this.submitting = false
            })
        }
      })
    },
    
    // 重置表单
    resetForm() {
      this.$refs.leaveForm.resetFields()
      this.leaveForm = {
        leaveType: '1',
        leaveDate: '',
        reason: ''
      }
    },
    
    // 获取请假记录
    getLeaveRecords() {
      this.loading = true
      attendance.getAttendanceByEmployee(this.currentPage, this.pageSize)
        .then(response => {
          this.leaveRecords = response.data.records || []
          this.total = response.data.total || 0
        })
        .catch(error => {
          console.error(error)
          this.$message.error('获取请假记录失败')
        })
        .finally(() => {
          this.loading = false
        })
    },
    
    // 刷新记录
    refreshRecords() {
      this.currentPage = 1
      this.getLeaveRecords()
    },
    
    // 分页处理
    handlePageChange(page) {
      this.currentPage = page
      this.getLeaveRecords()
    },
    
    // 获取请假类型文本
    getLeaveTypeText(type) {
      const typeMap = {
        1: '事假',
        4: '病假'
      }
      return typeMap[type] || '未知'
    },
    
    // 获取审核状态文本
    getAuditStatusText(audit) {
      const auditMap = {
        0: '待审核',
        1: '已通过',
        2: '已拒绝'
      }
      return auditMap[audit] || '未知'
    },
    
    // 格式化时间
    formatTime(time) {
      if (!time) return ''
      const date = new Date(time)
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      })
    },
    
    // 格式化日期
    formatDate(time) {
      if (!time) return ''
      const date = new Date(time)
      return date.toLocaleDateString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
      })
    }
  }
}
</script>

<style scoped>
.leave-application-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
}

.leave-form-card, .leave-records-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  overflow: hidden;
}

.form-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 25px 30px;
  text-align: center;
}

.form-header h2 {
  margin: 0 0 8px 0;
  font-size: 24px;
  font-weight: 600;
}

.form-header p {
  margin: 0;
  opacity: 0.9;
  font-size: 14px;
}

.leave-form {
  padding: 30px;
}

.leave-radio {
  display: flex;
  align-items: center;
  margin-right: 30px;
  margin-bottom: 10px;
}

.leave-radio i {
  margin-right: 5px;
}

.form-buttons {
  text-align: center;
  margin-top: 30px;
}

.submit-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  padding: 12px 30px;
  border-radius: 25px;
  margin-right: 15px;
  transition: all 0.3s ease;
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
}

.reset-btn {
  padding: 12px 30px;
  border-radius: 25px;
  transition: all 0.3s ease;
}

.records-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 30px;
  border-bottom: 1px solid #ebeef5;
  background: #fafbfc;
}

.records-header h3 {
  margin: 0;
  color: #2c3e50;
  font-size: 18px;
}

.el-table {
  margin: 0 30px;
}

.el-pagination {
  padding-bottom: 20px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .leave-application-container {
    padding: 10px;
  }
  
  .leave-form {
    padding: 20px;
  }
  
  .form-header {
    padding: 20px;
  }
  
  .records-header {
    padding: 15px 20px;
  }
  
  .el-table {
    margin: 0 20px;
  }
}
</style>