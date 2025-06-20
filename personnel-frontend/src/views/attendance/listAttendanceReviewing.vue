<template>
  <div class="app-container">
    <!--查询表单-->
    <el-form :inline="true" class="demo-form-inline">
      <el-form-item>
        <el-input
          v-model="attendanceQueryVo.clerkName"
          placeholder="员工名称"
        />
      </el-form-item>
      <el-form-item>
        <el-input
          v-model="attendanceQueryVo.departmentName"
          placeholder="部门名称"
        />
      </el-form-item>
      <el-form-item>
        <el-select
          clearable
          v-model="attendanceQueryVo.status"
          placeholder="请选择考勤类型"
        >
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          >
          </el-option>
        </el-select>
      </el-form-item>

      <el-button
        type="primary"
        icon="el-icon-search"
        @click="getAttendanceListPage()"
        >查询</el-button
      >
      <el-button type="default" @click="resetData()">清空</el-button>
    </el-form>
    <el-table
      :data="list"
      element-loading-text="数据加载中"
      fit
      highlight-current-row
    >
      <el-table-column label="序号" width="70" align="center">
        <template slot-scope="scope">{{
          (page - 1) * limit + scope.$index + 1
        }}</template>
      </el-table-column>
      <el-table-column prop="id" sortable label="编号" width="200" />

      <el-table-column prop="time" sortable label="日期" width="200" />
      <el-table-column prop="status" label="类型">
        <template slot-scope="scope">
          <el-tag :type="getTypeTagType(scope.row.status)">
            {{ getTypeText(scope.row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="clerkName" sortable label="员工姓名" />
      <el-table-column prop="departmentName" sortable label="员工部门" />
      <el-table-column prop="reason" label="原因" width="200">
        <template slot-scope="scope">
          <span>{{ scope.row.reason || '无' }}</span>
        </template>
      </el-table-column>
      <el-table-column
        v-if="isAdmin == true"
        label="操作"
        width="200"
        align="center"
      >
        <template slot-scope="scope">
          <el-button
            type="primary"
            size="mini"
            icon="el-icon-edit"
            @click="updateAttendance(scope.row.id, true)"
            >通过</el-button
          >
          <el-button
            type="danger"
            size="mini"
            icon="el-icon-delete"
            @click="updateAttendance(scope.row.id, false)"
            >不通过</el-button
          >
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <el-pagination
      :current-page="page"
      :page-size="limit"
      :total="total"
      style="padding: 30px 0; text-align: center"
      layout="total, prev, pager, next, jumper"
      @current-change="getAttendanceListPage"
    />
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import attendance from "@/api/attendance";
export default {
  data() {
    return {
      //            正常0,事假1,迟到2,早退3,病假4,旷工5,休补6
      options: [
        {
          value: "0",
          label: "正常",
        },
        {
          value: "1",
          label: "事假",
        },
        {
          value: "2",
          label: "迟到",
        },
        {
          value: "3",
          label: "早退",
        },
        {
          value: "4",
          label: "病假",
        },
        {
          value: "5",
          label: "旷工",
        },
        {
          value: "6",
          label: "休补",
        },
      ],
      list: null, //查询之后接口返回集合
      page: 1, //当前页
      limit: 6, //每页记录数
      total: 0, //总记录数
      attendanceQueryVo: {
        audit: "0",
      },
      isAdmin: false,
    };
  },
  computed: {
    ...mapGetters(["roles"]),
  },
  created() {
    if (this.roles.includes("管理员")) {
      this.isAdmin = true;
    }
    //页面渲染之前执行，一般用于调用methods中定义的方法
    this.getAttendanceListPage();
  },
  methods: {
    resetData() {
      //清空的方法
      //表单数据清空
      this.attendanceQueryVo = {
        audit: '0'  // 保持audit为0，确保只查询审核中的记录
      };
      //查询所有
      this.getAttendanceListPage();
    },
    //页面渲染之后执行，一般用于创建具体方法
    //列表方法
    getAttendanceListPage(page = 1) {
      this.page = page;
      attendance
        .getAttendanceListPage(this.page, this.limit, this.attendanceQueryVo)
        .then((response) => {
          //请求成功
          //response接口返回的数据
          this.list = response.data.attendanceList;
          this.total = response.data.total;
        })
        .catch((error) => {
          console.log(error);
        });
    },
    // 获取考勤类型文本
    getTypeText(type) {
      const typeMap = {
        0: '正常',
        1: '事假',
        2: '迟到', 
        3: '早退',
        4: '病假',
        5: '旷工',
        6: '休补'
      }
      return typeMap[type] || '未知'
    },
    // 获取考勤类型标签颜色
    getTypeTagType(type) {
      const tagTypeMap = {
        0: 'success',  // 正常
        1: 'warning',  // 事假
        2: 'danger',   // 迟到
        3: 'danger',   // 早退
        4: 'info',     // 病假
        5: 'danger',   // 旷工
        6: 'success'   // 休补
      }
      return tagTypeMap[type] || ''
    },
    updateAttendance(id, flag) {
      if (flag) {
        // 通过
        attendance.updateAttendanceOk(id).then((response) => {
          this.$message({
            type: "success",
            message: "已通过!",
          });
          this.getAttendanceListPage();
        });
      } else {
        // 不通过
        attendance.updateAttendanceNo(id).then((response) => {
          this.$message({
            type: "error",
            message: "未通过!",
          });
          this.getAttendanceListPage();
        });
      }
    },
    deleteAttendanceById(id) {
      //删除功能
      this.$confirm("此操作将永久删除该记录, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        attendance
          .deleteAttendanceById(id)
          .then((response) => {
            //删除成功
            //提示信息
            this.$message({
              type: "success",
              message: "删除成功!",
            });
            //回到列表
            this.getAttendanceListPage();
          })
          .catch((error) => {
            //提示信息
            this.$message({
              type: "warning",
              message: "删除失败!",
            });
          });
      });
    },
  },
};
</script>

