package com.gzb.staff.controller;


import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Attendance;
import com.gzb.staff.entity.Clerk;
import com.gzb.staff.entity.Department;
import com.gzb.staff.entity.User;
import com.gzb.staff.entity.vo.AttendanceQueryVo;
import com.gzb.staff.service.AttendanceService;
import com.gzb.staff.service.ClerkService;
import com.gzb.staff.service.DepartmentService;
import com.gzb.staff.service.UserService;
import com.gzb.staff.utils.JwtUtils;
import com.gzb.staff.utils.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * 考勤表 前端控制器
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
@RestController
@RequestMapping("/staff/attendance")
@CrossOrigin
public class AttendanceController {
    @Autowired
    private AttendanceService attendanceService;
    @Autowired
    private ClerkService clerkService;
    @Autowired
    private UserService userService;
    @Autowired
    private DepartmentService departmentService;
    //1.分页查询所有
    @PostMapping("listPage/{current}/{limit}")
    public R getAttendanceListPage(
            @PathVariable long current,
            @PathVariable long limit,
            @RequestBody(required = false) AttendanceQueryVo attendanceQueryVo) {
        System.out.println("接收到的查询参数: " + attendanceQueryVo);
        if (attendanceQueryVo != null) {
            System.out.println("audit值: " + attendanceQueryVo.getAudit());
        }
        Page<Attendance> attendancePage = new Page<>(current,limit);
        IPage<Attendance> clerkIPage = attendanceService.pageListQuery(attendancePage,attendanceQueryVo);
        //获取总记录数
        long total = clerkIPage.getTotal();
        //每页类别集合
        List<Attendance> attendanceList = clerkIPage.getRecords();

        for (Attendance attendance:attendanceList) {

//            事假1,迟到2,早退3,病假4,旷工5,休补6
            if (Integer.valueOf(1).equals(attendance.getStatus())) {
                attendance.setName("事假");
            } else if (Integer.valueOf(2).equals(attendance.getStatus())) {
                attendance.setName("迟到");
            } else if (Integer.valueOf(3).equals(attendance.getStatus())) {
                attendance.setName("早退");
            } else if (Integer.valueOf(4).equals(attendance.getStatus())) {
                attendance.setName("病假");
            } else if (Integer.valueOf(5).equals(attendance.getStatus())) {
                attendance.setName("旷工");
            } else if (Integer.valueOf(6).equals(attendance.getStatus())) {
                attendance.setName("休补");
            }
        }
        return R.ok().data("attendanceList",attendanceList).data("total",total);
    }

    //3.查询所有
    @GetMapping("list")
    public R getAttendanceList() {
        List<Attendance> attendanceList = attendanceService.list((Wrapper<Attendance>) null);
        return R.ok().data("attendanceList",attendanceList);
    }

    //2.根据id查询
    @GetMapping("{id}")
    public R getAttendanceById(@PathVariable String id){
        Attendance attendance = attendanceService.getById(id);
        if (StringUtils.isEmpty(attendance)){
            return R.error();
        }
        return R.ok().data("attendance",attendance);
    }

    //4.根据id删除
    @DeleteMapping("{id}")
    public R deleteAttendanceById(@PathVariable String id){
        boolean removeById = attendanceService.removeById(id);
        if (removeById){
            return R.ok();
        }
        return R.error().message("删除失败");
    }

    //5.修改
    @PutMapping
    public R updateAttendance(@RequestBody Attendance attendance){
        attendance.setAudit("0");
        boolean updateById = attendanceService.updateById(attendance);
        if (updateById){
            return R.ok().message("修改成功");
        }
        return R.error().message("修改失败");
    }

    //6.增加
    @PostMapping
    public R addAttendance(@RequestBody Attendance attendance){
        boolean save = attendanceService.save(attendance);
        if (save){
            return R.ok().message("增加成功");
        }
        return R.error().message("增加失败");
    }

    //根据token获取他的考勤信息
    @PostMapping("getAttendance/{current}/{limit}")
    public R getAttendance(@PathVariable long current,
                                   @PathVariable long limit,
                                   @RequestBody(required = false) AttendanceQueryVo attendanceQueryVo,
                                   @RequestHeader("X-Token") String token) {
        try {
            System.out.println("个人考勤查询 - 接收到的参数: " + attendanceQueryVo);
            String userId = JwtUtils.getMemberIdByToken(token);
            System.out.println("从token解析的用户ID: " + userId);
            
            // 直接通过用户ID获取用户信息
            User user = userService.getById(userId);
            if (user == null) {
                System.out.println("用户信息不存在，用户ID: " + userId);
                return R.error().message("用户信息不存在");
            }
            String userName = user.getName();
            System.out.println("找到用户姓名: " + userName);

            // 直接通过用户姓名查询考勤记录
            QueryWrapper<Attendance> attendanceQueryWrapper = new QueryWrapper<>();
            attendanceQueryWrapper.eq("name", userName).eq("is_deleted", 0);
            
            // 添加查询条件（注意：姓名条件已经固定为当前用户，不再从查询参数中获取）
            if (attendanceQueryVo != null) {
                // 不再使用查询参数中的姓名条件，因为我们只查询当前用户的考勤记录
                if (!StringUtils.isEmpty(attendanceQueryVo.getStatus())) {
                     attendanceQueryWrapper.eq("status",attendanceQueryVo.getStatus());
                 }
                if (!StringUtils.isEmpty(attendanceQueryVo.getAudit())) {
                    attendanceQueryWrapper.eq("audit",attendanceQueryVo.getAudit());
                }
            }
            
            // 按创建时间倒序排列
            attendanceQueryWrapper.orderByDesc("gmt_create");
            
            Page<Attendance> attendancePage = new Page<>(current,limit);
            attendanceService.page(attendancePage,attendanceQueryWrapper);
            
            List<Attendance> attendanceList = attendancePage.getRecords();
            System.out.println("查询到考勤记录数量: " + attendanceList.size());
            long total = attendancePage.getTotal();
            System.out.println("考勤记录总数: " + total);
            
            // 获取用户的部门信息
            String departmentName = "暂无部门信息";
            try {
                QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
                clerkQueryWrapper.eq("user_id", userId).eq("is_deleted", 0);
                Clerk clerk = clerkService.getOne(clerkQueryWrapper);
                if (clerk != null && clerk.getDepartmentId() != null) {
                    Department department = departmentService.getById(clerk.getDepartmentId());
                    if (department != null) {
                        departmentName = department.getName();
                    }
                }
            } catch (Exception e) {
                System.out.println("获取部门信息失败: " + e.getMessage());
            }
            
            // 为每个考勤记录添加部门信息
            for (Attendance attendance : attendanceList) {
                attendance.setDepartmentName(departmentName);
            }
            
            return R.ok().data("attendanceList",attendanceList).data("total",total);
        } catch (Exception e) {
            return R.error().message("查询失败: " + e.getMessage());
        }
    }
    //审核通过
    @PutMapping("updateAttendanceOk/{id}")
    public R updateAttendanceOk(@PathVariable String id){
        Attendance attendance = new Attendance();
        attendance.setId(id);
        attendance.setAudit("1");
        attendanceService.updateById(attendance);
        return R.ok();
    }
    //审核失败
    @PutMapping("updateAttendanceNo/{id}")
    public R updateAttendanceNo(@PathVariable String id){
        Attendance attendance = new Attendance();
        attendance.setId(id);
        attendance.setAudit("2");
        attendanceService.updateById(attendance);
        return R.ok();
    }
    
    //员工提交请假申请
    @PostMapping("employee/apply")
    public R addAttendanceByEmployee(@RequestBody Attendance attendance, @RequestHeader("X-Token") String token){
        try {
            // 从token获取用户信息
            String userId = JwtUtils.getMemberIdByToken(token);
            User user = userService.getById(userId);
            
            if (user == null) {
                return R.error().message("用户信息不存在");
            }
            
            // 设置用户信息
            attendance.setName(user.getName());
            attendance.setAudit("0"); // 待审核状态
            // 注意：clerk_id和department_id可以设置为null或默认值，因为我们不再依赖clerk表
            attendance.setClerkId(null);
            attendance.setDepartmentId(null);
            
            boolean save = attendanceService.save(attendance);
            if (save) {
                return R.ok().message("请假申请提交成功");
            }
            return R.error().message("提交失败");
        } catch (Exception e) {
            return R.error().message("提交失败: " + e.getMessage());
        }
    }
    
    //员工查询自己的请假记录
    @GetMapping("employee/records/{current}/{limit}")
    public R getAttendanceByEmployee(@PathVariable long current,
                                   @PathVariable long limit,
                                   @RequestHeader("X-Token") String token) {
        try {
            // 从token获取用户信息
            String userId = JwtUtils.getMemberIdByToken(token);
            QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
            clerkQueryWrapper.eq("user_id", userId);
            Clerk clerk = clerkService.getOne(clerkQueryWrapper);
            
            if (clerk == null) {
                return R.error().message("用户信息不存在");
            }
            
            // 查询该员工的请假记录（只查询事假和病假）
            QueryWrapper<Attendance> attendanceQueryWrapper = new QueryWrapper<>();
            attendanceQueryWrapper.eq("clerk_id", clerk.getId());
            attendanceQueryWrapper.in("status", 1, 4); // 1-事假, 4-病假
            attendanceQueryWrapper.orderByDesc("gmt_create");
            
            Page<Attendance> attendancePage = new Page<>(current, limit);
            attendanceService.page(attendancePage, attendanceQueryWrapper);
            
            List<Attendance> attendanceList = attendancePage.getRecords();
            
            // 状态和类型保持为数字，前端处理显示
            // status: 0-待审核, 1-已通过, 2-已拒绝
            // type: 1-事假, 2-迟到, 3-早退, 4-病假, 5-旷工, 6-休补, 0-正常
            
            long total = attendancePage.getTotal();
            return R.ok().data("records", attendanceList).data("total", total);
        } catch (Exception e) {
            return R.error().message("查询失败: " + e.getMessage());
        }
    }
}

