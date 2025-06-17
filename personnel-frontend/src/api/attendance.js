import request from '@/utils/request'

export default {
  //1.（查询分页）
  getAttendanceListPage(current, limit, attendanceQueryVo) {
    return request({
      url: `/staff/attendance/listPage/${current}/${limit}`,
      method: "post",
      data: attendanceQueryVo
    })
  },
  getAttendance(current, limit, attendanceQueryVo) {
    return request({
      url: `/staff/attendance/getAttendance/${current}/${limit}`,
      method: "post",
      data: attendanceQueryVo
    })
  },
  //2.删除
  deleteAttendanceById(id) {
    return request({
      url: `/staff/attendance/${id}`,
      method: "delete"
    })
  },
  //3.添加
  addAttendance(attendance) {
    return request({
      url: `/staff/attendance`,
      method: "post",
      data: attendance
    })
  },
  //4.根据id查询
  getAttendanceById(id) {
    return request({
      url: `/staff/attendance/${id}`,
      method: "get"
    })
  },
  //修改
  updateAttendance(attendance) {
    return request({
      url: `/staff/attendance`,
      method: "put",
      data: attendance
    })
  },
  //查询所有
  getAttendanceList() {
    return request({
      url: `/staff/attendance/list`,
      method: "get"
    })
  },
  //审核通过
  updateAttendanceOk(id) {
    return request({
      url: `/staff/attendance/updateAttendanceOk/${id}`,
      method: "put"
    })
  },
  //不通过
  updateAttendanceNo(id) {
    return request({
      url: `/staff/attendance/updateAttendanceNo/${id}`,
      method: "put"
    })
  },
  
  //员工提交请假申请
  addAttendanceByEmployee(attendance) {
    return request({
      url: `/staff/attendance/employee/apply`,
      method: "post",
      data: attendance
    })
  },
  
  //员工查询自己的请假记录
  getAttendanceByEmployee(current, limit) {
    return request({
      url: `/staff/attendance/employee/records/${current}/${limit}`,
      method: "get"
    })
  }

}
