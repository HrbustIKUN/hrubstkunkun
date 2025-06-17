import request from '@/utils/request'

// 获取员工详细资料（包含技能和联系信息）
export function getClerkProfile() {
  return request({
    url: '/staff/clerk/profile',
    method: 'get'
  })
}

// 更新员工技能
export function updateClerkSkills(skills) {
  return request({
    url: '/staff/clerk/updateSkills',
    method: 'put',
    data: {
      skills: skills
    }
  })
}

// 更新员工基本信息
export function updateClerkProfile(profileData) {
  return request({
    url: '/staff/clerk/updateProfile',
    method: 'put',
    data: profileData
  })
}

// 获取员工和用户角色信息（原有接口）
export function getClerkAndUserRole() {
  return request({
    url: '/staff/clerk/getClerkAndUserRole',
    method: 'post'
  })
}