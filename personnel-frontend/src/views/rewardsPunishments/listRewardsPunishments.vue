<template>
  <div class="app-container">
    <!--查询表单-->
    <el-form :inline="true" class="demo-form-inline">
      <el-form-item>
        <el-input
          v-model="rewardsPunishmentsQueryVo.reason"
          placeholder="奖惩原因"
        />
      </el-form-item>
      <el-form-item>
        <el-input
          v-model="rewardsPunishmentsQueryVo.money"
          placeholder="奖惩金额"
        />
      </el-form-item>
      <el-form-item>
        <el-input
          v-model="rewardsPunishmentsQueryVo.clerkName"
          placeholder="员工名称"
        />
      </el-form-item>
      <el-form-item>
        <el-input
          v-model="rewardsPunishmentsQueryVo.departmentName"
          placeholder="部门名称"
        />
      </el-form-item>
      <el-form-item>
        <el-select
          clearable
          v-model="rewardsPunishmentsQueryVo.type"
          placeholder="请选择奖惩类型"
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
        @click="getRewardsPunishmentsListPage()"
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
      <el-table-column
        prop="type"
        sortable
        label="类型"
        width="100"
      >
        <template slot-scope="scope">
          <el-tag :type="scope.row.type === '0' ? 'success' : 'danger'">
            {{ scope.row.type === '0' ? '奖励' : '惩罚' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="time" sortable label="日期" width="200" />
      <el-table-column prop="reason" label="原因" />
      <el-table-column prop="money" sortable label="金额" >
        <template slot-scope="scope">
          ¥{{ scope.row.money }}
        </template>
      </el-table-column>
      <el-table-column prop="clerkName" sortable label="员工姓名" />
      <el-table-column prop="departmentName" sortable label="员工部门" />
      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="scope">
          <router-link
            :to="'/rewardsPunishments/updateRewardsPunishments/' + scope.row.id"
          >
            <el-button type="primary" size="mini" icon="el-icon-edit"
              >修改</el-button
            >
          </router-link>
          <el-button
            type="danger"
            size="mini"
            icon="el-icon-delete"
            @click="deleteRewardsPunishmentsById(scope.row.id)"
            >删除</el-button
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
      @current-change="getRewardsPunishmentsListPage"
    />
  </div>
</template>

<script>
import rewardsPunishments from "@/api/rewardsPunishments";
export default {
  data() {
    return {
      options: [
        {
          value: "0",
          label: "奖励",
        },
        {
          value: "1",
          label: "惩罚",
        },
      ],
      list: null, //查询之后接口返回集合
      page: 1, //当前页
      limit: 6, //每页记录数
      total: 0, //总记录数
      rewardsPunishmentsQueryVo: {},
    };
  },
  created() {
    //页面渲染之前执行，一般用于调用methods中定义的方法
    this.getRewardsPunishmentsListPage();
  },
  methods: {
    resetData() {
      //清空的方法
      //表单数据清空
      this.rewardsPunishmentsQueryVo = {};
      //查询所有
      this.getRewardsPunishmentsListPage();
    },
    //页面渲染之后执行，一般用于创建具体方法
    //列表方法
    getRewardsPunishmentsListPage(page = 1) {
      this.page = page;
      console.log('奖惩查询参数:', this.rewardsPunishmentsQueryVo);
      rewardsPunishments
        .getRewardsPunishmentsListPage(
          this.page,
          this.limit,
          this.rewardsPunishmentsQueryVo
        )
        .then((response) => {
          //请求成功
          //response接口返回的数据
          console.log('奖惩API响应:', response.data);
          this.list = response.data.rewardsPunishmentsList;
          this.total = response.data.total;
        })
        .catch((error) => {
          console.log('奖惩API错误:', error);
        });
    },
    resetData() {
      this.getRewardsPunishmentsListPage();
    },
    deleteRewardsPunishmentsById(id) {
      //删除功能
      this.$confirm("此操作将永久删除该记录, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        rewardsPunishments
          .deleteRewardsPunishmentsById(id)
          .then((response) => {
            //删除成功
            //提示信息
            this.$message({
              type: "success",
              message: "删除成功!",
            });
            //回到列表
            this.getRewardsPunishmentsListPage();
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

