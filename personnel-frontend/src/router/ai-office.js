// AI办公模块路由配置
export default [
  {
    path: '/ai-office',
    component: () => import('@/layout/index'),
    redirect: '/ai-office/index',
    name: 'AIOffice',
    meta: {
      title: 'AI智能办公',
      icon: 'el-icon-cpu',
      roles: ['admin', 'hr', 'employee'] // 所有角色都可以访问
    },
    children: [
      {
        path: 'index',
        component: () => import('@/views/ai-office/AIOfficeIndex'),
        name: 'AIOfficeIndex',
        meta: {
          title: 'AI办公助手',
          icon: 'el-icon-chat-dot-round',
          noCache: true
        }
      },
      {
        path: 'document',
        component: () => import('@/views/ai-office/DocumentGenerator'),
        name: 'DocumentGenerator',
        meta: {
          title: '智能文档生成',
          icon: 'el-icon-document',
          aiFunction: 'document-generation',
          noCache: true
        }
      },
      {
        path: 'analysis',
        component: () => import('@/views/ai-office/DataAnalysis'),
        name: 'DataAnalysis',
        meta: {
          title: '数据分析报告',
          icon: 'el-icon-data-analysis',
          aiFunction: 'data-analysis',
          noCache: true
        }
      },
      {
        path: 'qa',
        component: () => import('@/views/ai-office/IntelligentQA'),
        name: 'IntelligentQA',
        meta: {
          title: '智能问答',
          icon: 'el-icon-chat-dot-round',
          aiFunction: 'intelligent-qa',
          noCache: true
        }
      },
      {
        path: 'email',
        component: () => import('@/views/ai-office/EmailGenerator'),
        name: 'EmailGenerator',
        meta: {
          title: '邮件生成',
          icon: 'el-icon-message',
          aiFunction: 'email-generation',
          noCache: true
        }
      },
      {
        path: 'meeting',
        component: () => import('@/views/ai-office/MeetingMinutes'),
        name: 'MeetingMinutes',
        meta: {
          title: '会议纪要',
          icon: 'el-icon-notebook-1',
          aiFunction: 'meeting-minutes',
          noCache: true
        }
      },
      {
        path: 'plan',
        component: () => import('@/views/ai-office/WorkPlan'),
        name: 'WorkPlan',
        meta: {
          title: '工作计划',
          icon: 'el-icon-date',
          aiFunction: 'work-plan',
          noCache: true
        }
      },
      {
        path: 'templates',
        component: () => import('@/views/ai-office/TemplateManager'),
        name: 'TemplateManager',
        meta: {
          title: '模板管理',
          icon: 'el-icon-folder-opened',
          aiFunction: 'advanced-templates',
          noCache: true
        }
      },
      {
        path: 'history',
        component: () => import('@/views/ai-office/ConversationHistory'),
        name: 'ConversationHistory',
        meta: {
          title: '对话历史',
          icon: 'el-icon-time',
          aiFunction: 'intelligent-qa',
          noCache: true
        }
      },
      {
        path: 'settings',
        component: () => import('@/views/ai-office/AISettings'),
        name: 'AISettings',
        meta: {
          title: 'AI设置',
          icon: 'el-icon-setting',
          roles: ['admin'], // 仅管理员可访问
          aiFunction: 'ai-configuration',
          noCache: true
        }
      },
      {
        path: 'statistics',
        component: () => import('@/views/ai-office/UsageStatistics'),
        name: 'UsageStatistics',
        meta: {
          title: '使用统计',
          icon: 'el-icon-data-line',
          roles: ['admin', 'hr'], // 管理员和HR可访问
          aiFunction: 'usage-statistics',
          noCache: true
        }
      }
    ]
  }
]