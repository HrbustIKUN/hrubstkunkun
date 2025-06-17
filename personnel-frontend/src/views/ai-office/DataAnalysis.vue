<template>
  <div class="data-analysis-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>数据分析报告</span>
      </div>
      
      <!-- 数据源选择 -->
      <el-form ref="analysisForm" :model="analysisForm" label-width="120px">
        <el-form-item label="数据源类型">
          <el-select v-model="analysisForm.dataSource" placeholder="请选择数据源" @change="handleDataSourceChange">
            <el-option label="员工数据" value="employee" />
            <el-option label="考勤数据" value="attendance" />
            <el-option label="薪资数据" value="salary" />
            <el-option label="部门数据" value="department" />
            <el-option label="合同数据" value="contract" />
            <el-option label="自定义数据" value="custom" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="分析类型">
          <el-select v-model="analysisForm.analysisType" placeholder="请选择分析类型">
            <el-option label="趋势分析" value="trend" />
            <el-option label="对比分析" value="comparison" />
            <el-option label="分布分析" value="distribution" />
            <el-option label="相关性分析" value="correlation" />
            <el-option label="预测分析" value="prediction" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="时间范围">
          <el-date-picker
            v-model="analysisForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        
        <el-form-item label="分析要求">
          <el-input
            v-model="analysisForm.requirements"
            type="textarea"
            :rows="4"
            placeholder="请描述您的具体分析需求，例如：分析最近3个月的员工离职率趋势，找出影响因素"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="generateAnalysis" :loading="loading">生成分析报告</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    
    <!-- 分析结果 -->
    <el-card v-if="analysisResult" class="result-card">
      <div slot="header" class="clearfix">
        <span>分析结果</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="exportReport">导出报告</el-button>
      </div>
      
      <div class="analysis-content">
        <!-- 摘要 -->
        <div class="summary-section">
          <h3>分析摘要</h3>
          <p>{{ analysisResult.summary }}</p>
        </div>
        
        <!-- 图表展示 -->
        <div class="charts-section">
          <h3>数据可视化</h3>
          <el-row :gutter="20">
            <el-col :span="12">
              <div class="chart-container">
                <div id="chart1" style="width: 100%; height: 300px;"></div>
              </div>
            </el-col>
            <el-col :span="12">
              <div class="chart-container">
                <div id="chart2" style="width: 100%; height: 300px;"></div>
              </div>
            </el-col>
          </el-row>
        </div>
        
        <!-- 详细分析 -->
        <div class="detailed-analysis">
          <h3>详细分析</h3>
          <div v-for="(section, index) in analysisResult.details" :key="index" class="analysis-section">
            <h4>{{ section.title }}</h4>
            <p>{{ section.content }}</p>
            <ul v-if="section.points">
              <li v-for="point in section.points" :key="point">{{ point }}</li>
            </ul>
          </div>
        </div>
        
        <!-- 建议和结论 -->
        <div class="recommendations">
          <h3>建议和结论</h3>
          <div v-for="(rec, index) in analysisResult.recommendations" :key="index" class="recommendation-item">
            <el-tag :type="rec.priority === 'high' ? 'danger' : rec.priority === 'medium' ? 'warning' : 'info'">
              {{ rec.priority === 'high' ? '高优先级' : rec.priority === 'medium' ? '中优先级' : '低优先级' }}
            </el-tag>
            <span class="recommendation-text">{{ rec.text }}</span>
          </div>
        </div>
      </div>
    </el-card>
    
    <!-- 历史报告 -->
    <el-card class="history-card">
      <div slot="header" class="clearfix">
        <span>历史报告</span>
      </div>
      
      <el-table :data="historyReports" style="width: 100%">
        <el-table-column prop="title" label="报告标题" />
        <el-table-column prop="dataSource" label="数据源" />
        <el-table-column prop="analysisType" label="分析类型" />
        <el-table-column prop="createdAt" label="创建时间" />
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button size="mini" @click="viewReport(scope.row)">查看</el-button>
            <el-button size="mini" type="danger" @click="deleteReport(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'DataAnalysis',
  data() {
    return {
      loading: false,
      analysisForm: {
        dataSource: '',
        analysisType: '',
        dateRange: [],
        requirements: ''
      },
      analysisResult: null,
      historyReports: [
        {
          id: 1,
          title: '员工离职率分析报告',
          dataSource: '员工数据',
          analysisType: '趋势分析',
          createdAt: '2024-01-15 14:30:00'
        },
        {
          id: 2,
          title: '部门绩效对比分析',
          dataSource: '部门数据',
          analysisType: '对比分析',
          createdAt: '2024-01-14 09:15:00'
        }
      ]
    }
  },
  methods: {
    handleDataSourceChange() {
      // 根据数据源类型更新可用的分析类型
      console.log('数据源变更:', this.analysisForm.dataSource)
    },
    generateAnalysis() {
      if (!this.analysisForm.dataSource || !this.analysisForm.analysisType) {
        this.$message.warning('请选择数据源和分析类型')
        return
      }
      
      this.loading = true
      
      // 模拟AI分析过程
      setTimeout(() => {
        this.analysisResult = {
          summary: '基于最近3个月的员工数据分析，发现离职率呈上升趋势，主要集中在技术部门。通过相关性分析发现，工作满意度和薪资水平是影响离职的主要因素。',
          details: [
            {
              title: '数据概览',
              content: '分析了1000名员工的数据，涵盖5个部门，时间跨度为2023年10月至2024年1月。',
              points: [
                '总员工数：1000人',
                '离职员工数：85人',
                '整体离职率：8.5%',
                '技术部门离职率最高：12.3%'
              ]
            },
            {
              title: '趋势分析',
              content: '离职率在过去3个月呈现逐月上升趋势，从6.2%增长到10.8%。',
              points: [
                '10月离职率：6.2%',
                '11月离职率：8.1%',
                '12月离职率：9.7%',
                '1月离职率：10.8%'
              ]
            }
          ],
          recommendations: [
            {
              priority: 'high',
              text: '立即启动技术部门员工满意度调研，了解具体离职原因'
            },
            {
              priority: 'medium',
              text: '考虑调整技术部门薪资结构，提高竞争力'
            },
            {
              priority: 'low',
              text: '建立定期的员工沟通机制，及时发现和解决问题'
            }
          ]
        }
        
        this.loading = false
        this.$message.success('分析报告生成成功')
        
        // 渲染图表
        this.$nextTick(() => {
          this.renderCharts()
        })
      }, 3000)
    },
    renderCharts() {
      // 这里应该使用ECharts或其他图表库渲染图表
      // 为了简化，这里只是占位
      const chart1 = document.getElementById('chart1')
      const chart2 = document.getElementById('chart2')
      
      if (chart1) {
        chart1.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; background: #f5f5f5; border: 1px dashed #ccc;">离职率趋势图</div>'
      }
      
      if (chart2) {
        chart2.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; background: #f5f5f5; border: 1px dashed #ccc;">部门对比图</div>'
      }
    },
    resetForm() {
      this.$refs.analysisForm.resetFields()
      this.analysisResult = null
    },
    exportReport() {
      this.$message.success('报告导出成功')
    },
    viewReport(report) {
      this.$message.info(`查看报告: ${report.title}`)
    },
    deleteReport(id) {
      this.$confirm('确认删除这份报告?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.historyReports = this.historyReports.filter(report => report.id !== id)
        this.$message.success('删除成功')
      })
    }
  }
}
</script>

<style scoped>
.data-analysis-container {
  padding: 20px;
}

.box-card, .result-card, .history-card {
  margin-bottom: 20px;
}

.analysis-content {
  padding: 20px 0;
}

.summary-section, .charts-section, .detailed-analysis, .recommendations {
  margin-bottom: 30px;
}

.summary-section h3, .charts-section h3, .detailed-analysis h3, .recommendations h3 {
  color: #303133;
  margin-bottom: 15px;
  border-bottom: 2px solid #409EFF;
  padding-bottom: 5px;
}

.analysis-section {
  margin-bottom: 20px;
  padding: 15px;
  background: #f9f9f9;
  border-radius: 4px;
}

.analysis-section h4 {
  color: #606266;
  margin-bottom: 10px;
}

.analysis-section ul {
  margin: 10px 0;
  padding-left: 20px;
}

.analysis-section li {
  margin: 5px 0;
}

.chart-container {
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  padding: 10px;
}

.recommendation-item {
  display: flex;
  align-items: center;
  margin: 10px 0;
  padding: 10px;
  background: #f0f9ff;
  border-radius: 4px;
}

.recommendation-text {
  margin-left: 10px;
  flex: 1;
}
</style>