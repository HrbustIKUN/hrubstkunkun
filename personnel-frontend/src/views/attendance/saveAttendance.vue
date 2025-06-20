<!--
 * @Description: 
 * @Author: Rabbiter
 * @Date: 2023-03-16 01:17:25
-->
<template>
  <div class="app-container">
    <el-form label-width="120px" :rules="rule" :model="attendance" 
        ref="attendance">
      <el-form-item label="编号">
        <el-input :span="6" :disabled="true" v-model="attendance.id" />
      </el-form-item>
      <el-form-item label="选择部门"  prop="departmentId">
        <el-select
          v-model="attendance.departmentId"
          clearable
          placeholder="请选择部门"
          @change="selectClerk"
        >
          <el-option
            v-for="item in departmentList"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-select
          v-model="attendance.clerkId"
          clearable
          placeholder="请选择员工"
          @change="$forceUpdate()"
        >
          <el-option
            v-for="item in clerkList"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
          </el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="请选择时间" prop="time">
        <el-date-picker
          v-model="attendance.time"
          type="datetime"
          placeholder="请选择时间"
          value-format="yyyy-MM-dd HH:mm:ss"
        >
        </el-date-picker>
      </el-form-item>
      
      <el-form-item label="考勤类型" prop="status">
        <el-radio v-model="attendance.status" label="1">事假</el-radio>
        <el-radio v-model="attendance.status" label="2">迟到</el-radio>
        <el-radio v-model="attendance.status" label="3">早退</el-radio>
        <el-radio v-model="attendance.status" label="4">病假</el-radio>
        <el-radio v-model="attendance.status" label="5">旷工</el-radio>
        <el-radio v-model="attendance.status" label="6">休补</el-radio>
      </el-form-item>

      <el-form-item label="原因" prop="reason">
        <el-input
          v-model="attendance.reason"
          type="textarea"
          :rows="3"
          placeholder="请输入原因（可选）"
          maxlength="500"
          show-word-limit
        />
      </el-form-item>

      <el-form-item>
        <el-button
          :disabled="saveBtnDisabled"
          type="primary"
          @click="saveOrUpdate"
          >保存</el-button
        >
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import attendance from "@/api/attendance";
import department from "@/api/department";
import clerk from "@/api/clerk";
export default {
  data() {
    return {
      attendance: {
        clerkId: '',
        departmentId: '',
        time: '',
        status: '',
        reason: ''
      },
      saveBtnDisabled: false, // 保存按钮是否禁用,
      departmentList: [],
      imagecropperKey: 0, //上传组件的key值
      clerkList: [],      
      rule: {
        time: [{ required: true, message: "请选择时间", trigger: "change" }],
        clerkId: [{ required: true, message: "请选择员工", trigger: "change" }],
        departmentId: [
          { required: true, message: "请选择部门", trigger: "change" },
        ],
        status: [{ required: true, message: "请选择考勤类型", trigger: "change" }],
        reason: [
          {
            validator: (rule, value, callback) => {
              // 原因字段为可选，不进行必填验证
              callback();
            },
            trigger: 'blur'
          }
        ],
      },
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
    initClerk() {
      clerk.getClerkList().then((response) => {
        this.clerkList = response.data.clerkList;
      });
    },
    selectClerk() {
      this.attendance.clerkId = '';
      clerk
        .getClerkByDepartmentId(this.attendance.departmentId)
        .then((response) => {
          this.clerkList = response.data.clerkList;
        });
    },
    //初始化
    init() {
      //判断路径中是否有id值
      if (this.$route.params && this.$route.params.id) {
        const id = this.$route.params.id;
        this.getAttendanceById(id);
        this.initClerk();
      } else {
        //清空表单
        this.attendance = {
          clerkId: '',
          departmentId: '',
          time: '',
          status: '',
          reason: ''
        };
      }
      this.initDepartment();
    },
    //查询部门
    initDepartment() {
      department.getDepartmentList().then((response) => {
        this.departmentList = response.data.departmentList;
      });
      
    },
    //修改
    updateAttendance() {
      attendance
        .updateAttendance(this.attendance)
        .then((response) => {
          this.$message({
            type: "success",
            message: "修改成功!",
          });
          this.$router.push({
            path: "/attendance",
          });
        });
    },
    //根据id查询
    getAttendanceById(id) {
      attendance
        .getAttendanceById(id)
        .then((response) => {
          this.attendance = response.data.attendance;
          console.log(this.attendance);
        })
        .catch((error) => {});
    },
    saveOrUpdate() {
      //判断是修改还是添加
      //判断路径中是否有id
      this.$refs['attendance'].validate((valid) => {
        if (valid) {
          //判断是修改还是添加
          //判断路径中是否有id
          if (this.$route.params && this.$route.params.id) {
            //修改
            this.updateAttendance();
          } else {
            //添加
            this.saveAttendance();
          }
        }
      });
    },
    //添加
    saveAttendance() {
      if(!this.attendance.time || this.attendance.time == "") {
          this.$message({
            type: "error",
            message: "日期不能为空",
          });
        return;
      }
      // this.attendance.time = this.attendance.time.split(" ")[0];
      attendance
        .addAttendance(this.attendance)
        .then((response) => {
          //添加成功
          //提示信息
          this.$message({
            type: "success",
            message: "添加成功",
          });
          //回到列表 路由跳转(重定向)
          this.$router.push({
            path: "/attendance/listAttendanceReviewing",
          });
        })
        .catch((error) => {
          //提示信息
          // this.$message({
          //   type: "warning",
          //   message: "添加失败",
          // });
        });
    },
  },
};
</script>

