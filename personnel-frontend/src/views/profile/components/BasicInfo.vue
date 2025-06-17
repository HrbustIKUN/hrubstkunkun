<template>
  <div class="basic-info">
    <el-form :model="form" :rules="rules" ref="basicForm" label-width="120px" class="info-form">
      <div class="form-section">
        <h3 class="section-title">
          <i class="el-icon-user"></i>
          个人信息
        </h3>
        
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="姓名" prop="name">
              <el-input v-model="form.name" disabled placeholder="姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="性别" prop="sex">
              <el-input v-model="sexDisplay" disabled placeholder="性别" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="身份证号" prop="idCard">
              <el-input v-model="form.idCard" disabled placeholder="身份证号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机号码" prop="phoneNumber">
              <el-input v-model="form.phoneNumber" :disabled="!editing" placeholder="手机号码" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="邮箱地址" prop="email">
          <el-input v-model="form.email" :disabled="!editing" placeholder="邮箱地址" />
        </el-form-item>
        
        <el-form-item label="地址" prop="address">
          <el-input
            v-model="form.address"
            type="textarea"
            :rows="3"
            :disabled="!editing"
            placeholder="地址信息"
          />
        </el-form-item>
      </div>
      
      <div class="form-section">
        <h3 class="section-title">
          <i class="el-icon-office-building"></i>
          工作信息
        </h3>
        
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="员工编号" prop="id">
              <el-input v-model="form.id" disabled placeholder="员工编号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="部门" prop="departmentName">
              <el-input v-model="form.departmentName" disabled placeholder="部门信息" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="职位" prop="position">
              <el-input v-model="form.position" disabled placeholder="职位信息" />
            </el-form-item>
          </el-col>
        </el-row>
      </div>
      
      <div class="form-actions">
        <el-button v-if="!editing" type="primary" @click="startEdit">
          <i class="el-icon-edit"></i>
          编辑信息
        </el-button>
        <template v-else>
          <el-button @click="cancelEdit">
            <i class="el-icon-close"></i>
            取消
          </el-button>
          <el-button type="primary" @click="saveInfo">
            <i class="el-icon-check"></i>
            保存
          </el-button>
        </template>
      </div>
    </el-form>
  </div>
</template>

<script>
import { getClerkProfile, updateClerkProfile } from '@/api/profile'
import { getDepartmentList } from '@/api/department'

export default {
  name: 'BasicInfo',
  props: {
    userProfile: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      editing: false,
      loading: false,
      form: {
        id: '',
        name: '',
        sex: '',
        phoneNumber: '',
        email: '',
        idCard: '',
        address: '',
        position: '',
        departmentId: '',
        departmentName: '',
        photo: ''
      },
      originalForm: {},
      departments: [],
      rules: {
        name: [
          { required: true, message: '请输入姓名', trigger: 'blur' }
        ],
        phoneNumber: [
          { required: true, message: '请输入手机号码', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
        ],
        email: [
          { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
        ],
        idCard: [
          { pattern: /^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/, message: '请输入正确的身份证号', trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    sexDisplay() {
      return this.form.sex == 1 ? '男' : this.form.sex == 0 ? '女' : this.form.sex
    }
  },
  watch: {
    userProfile: {
      handler(newProfile) {
        if (newProfile && Object.keys(newProfile).length > 0) {
          this.form = {
            id: newProfile.id || '',
            name: newProfile.name || '',
            sex: newProfile.sex || '',
            phoneNumber: newProfile.phoneNumber || '',
            email: newProfile.email || '',
            idCard: newProfile.idCard || '',
            address: newProfile.address || '',
            position: newProfile.position || '',
            departmentId: newProfile.departmentId || '',
            departmentName: newProfile.departmentName || '',
            photo: newProfile.photo || ''
          }
        }
      },
      immediate: true
    }
  },
  mounted() {
    this.loadDepartments()
  },
  methods: {
    async loadDepartments() {
      try {
        const response = await getDepartmentList()
        this.departments = response.data || []
      } catch (error) {
        console.error('获取部门列表失败:', error)
      }
    },
    
    startEdit() {
      this.editing = true
      this.originalForm = { ...this.form }
    },
    
    cancelEdit() {
      this.editing = false
      this.form = { ...this.originalForm }
    },
    
    async saveInfo() {
      this.$refs.basicForm.validate(async (valid) => {
        if (valid) {
          this.loading = true
          try {
            const updateData = {
              phoneNumber: this.form.phoneNumber,
              email: this.form.email,
              address: this.form.address
            }
            
            await updateClerkProfile(updateData)
            this.editing = false
            this.$message.success('基本信息更新成功')
            this.$emit('profile-updated', this.form)
          } catch (error) {
            console.error('更新基本信息失败:', error)
            this.$message.error('更新失败，请重试')
          } finally {
            this.loading = false
          }
        } else {
          this.$message.error('请检查表单信息')
        }
      })
    },
    
    getDepartmentName(departmentId) {
      const dept = this.departments.find(d => d.id === departmentId)
      return dept ? dept.name : '未知部门'
    }
  }
}
</script>

<style lang="scss" scoped>
.basic-info {
  .info-form {
    .form-section {
      margin-bottom: 32px;
      
      .section-title {
        font-size: 18px;
        font-weight: 600;
        color: #333;
        margin-bottom: 20px;
        padding-bottom: 12px;
        border-bottom: 2px solid #f0f0f0;
        
        i {
          margin-right: 8px;
          color: #667eea;
        }
      }
    }
    
    .form-actions {
      text-align: center;
      padding-top: 24px;
      border-top: 1px solid #f0f0f0;
      
      .el-button {
        margin: 0 8px;
        padding: 12px 24px;
        border-radius: 6px;
        font-weight: 500;
        
        i {
          margin-right: 4px;
        }
      }
    }
  }
  
  ::v-deep .el-form-item {
    margin-bottom: 20px;
    
    .el-form-item__label {
      font-weight: 500;
      color: #666;
    }
    
    .el-input__inner,
    .el-textarea__inner {
      border-radius: 6px;
      transition: all 0.3s ease;
      
      &:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
      }
    }
    
    .el-input.is-disabled .el-input__inner {
      background-color: #f8f9fa;
      color: #666;
    }
  }
}
</style>