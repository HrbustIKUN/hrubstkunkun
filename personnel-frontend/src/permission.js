import router from './router'
import store from './store'
import { Message } from 'element-ui'
import NProgress from 'nprogress' // progress bar
import 'nprogress/nprogress.css' // progress bar style
import { getToken } from '@/utils/auth' // get token from cookie
import getPageTitle from '@/utils/get-page-title'
import { hasAIPermission } from '@/permission/ai-office'

// NProgress Configuration
if (typeof NProgress !== 'undefined' && NProgress.configure) {
  NProgress.configure({ 
    showSpinner: false,
    minimum: 0.1,
    easing: 'ease',
    speed: 500,
    trickleSpeed: 200
  })
}

const whiteList = ['/login', '/auth-redirect'] // no redirect whitelist

router.beforeEach(async(to, from, next) => {
  // start progress bar
  NProgress.start()

  // set page title
  document.title = getPageTitle(to.meta.title)

  // determine whether the user has logged in
  const hasToken = getToken()

  if (hasToken) {
    if (to.path === '/login') {
      // if is logged in, redirect to the home page
      next({ path: '/' })
      NProgress.done()
    } else {
      // determine whether the user has obtained his permission roles through getInfo
      const hasRoles = store.getters.roles && store.getters.roles.length > 0
      if (hasRoles) {
        // 检查AI办公功能权限
        if (to.path.startsWith('/ai-office/') && to.meta && to.meta.aiFunction) {
          const userRoles = store.getters.roles
          const requiredFunction = to.meta.aiFunction
          if (userRoles.length > 0) {
            // 取第一个角色进行权限检查
            const userRole = userRoles[0]
            if (!hasAIPermission(userRole, requiredFunction)) {
              // 使用更安全的Message调用方式
              Message({
                message: '您没有权限访问此AI功能',
                type: 'error'
              })
              next('/401')
              NProgress.done()
              return
            }
          }
        }
        next()
      } else {
        try {
          // get user info
          // note: roles must be a object array! such as: ['admin'] or ,['developer','editor']
          const { roles } = await store.dispatch('user/getInfo')

          // generate accessible routes map based on roles
          const accessRoutes = await store.dispatch('permission/generateRoutes', roles)

          // dynamically add accessible routes
          router.addRoutes(accessRoutes)

          // ensure the added routes are available
          if (to.path === '/') {
            // redirect based on user role
            if (roles.includes('职员')) {
              next('/employee/dashboard')
            } else if (roles.includes('admin') || roles.includes('super_admin') || roles.includes('管理员') || roles.includes('人事经理')) {
              next('/admin/index')
            } else {
              next('/employee/dashboard') // 默认重定向到员工首页
            }
          } else {
            // hack method to ensure that addRoutes is complete
            next({ ...to, replace: true })
          }
        } catch (error) {
          // remove token and go to login page to re-login
          await store.dispatch('user/resetToken')
          // 使用更安全的Message调用方式避免Vue警告
          Message({
            message: error || 'Has Error',
            type: 'error'
          })
          next(`/login?redirect=${to.path}`)
          NProgress.done()
        }
      }
    }
  } else {
    /* has no token*/

    if (whiteList.indexOf(to.path) !== -1) {
      // in the free login whitelist, go directly
      next()
    } else {
      // other pages that do not have permission to access are redirected to the login page.
      next(`/login?redirect=${to.path}`)
      NProgress.done()
    }
  }
})

router.afterEach(() => {
  // finish progress bar
  NProgress.done()
})
