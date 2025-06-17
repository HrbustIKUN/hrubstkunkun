package com.gzb.staff.controller;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Clerk;
import com.gzb.staff.entity.Department;
import com.gzb.staff.entity.Role;
import com.gzb.staff.entity.User;
import com.gzb.staff.entity.vo.ClerkQueryVo;
import com.gzb.staff.service.ClerkService;
import com.gzb.staff.service.DepartmentService;
import com.gzb.staff.service.RoleService;
import com.gzb.staff.service.UserService;
import com.gzb.staff.utils.JwtUtils;
import com.gzb.staff.utils.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;

import java.util.List;

/**
 * <p>
 * 职员表 前端控制器
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
@RestController
@RequestMapping("/staff/clerk")
@CrossOrigin
public class ClerkController {
    @Autowired
    private ClerkService clerkService;
    @Autowired
    private UserService userService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private DepartmentService departmentService;
    //1.分页查询
    @PostMapping("listPage/{current}/{limit}")
    public R getClerkListPage(@PathVariable long current, @PathVariable long limit, @RequestBody(required = false) ClerkQueryVo clerkQueryVo) {
        Page<Clerk> clerkPage = new Page<>(current,limit);
        clerkQueryVo.setIsDeleted(0);
        IPage<Clerk> clerkIPage = clerkService.pageListQuery(clerkPage,clerkQueryVo);
        //获取总记录数
        long total = clerkIPage.getTotal();
        //每页类别集合
        List<Clerk> clerkList = clerkIPage.getRecords();
        return R.ok().data("clerkList",clerkList).data("total",total);
    }

    //3.查询所有
    @GetMapping("list")
    public R getClerkList() {
        List<Clerk> clerkList = clerkService.list((Wrapper<Clerk>) null);
        return R.ok().data("clerkList",clerkList);
    }

    //2.根据id查询
    @GetMapping("{id}")
    public R getClerkById(@PathVariable String id){
        Clerk clerk = clerkService.getById(id);
        return R.ok().data("clerk",clerk);
    }

    //4.根据id删除
    @DeleteMapping("{id}")
    public R deleteClerkById(@PathVariable String id){
        boolean removeById = clerkService.deleteClerkById(id);
        if (removeById){
            return R.ok();
        }
        return R.error().message("删除失败");
    }

    //5.修改
    @PutMapping
    public R updateClerk(@RequestBody Clerk clerk){
        boolean updateById = clerkService.updateClerk(clerk);
        String userId = clerk.getUserId();
        User user = new User();
        user.setId(userId);
        user.setUsername(clerk.getPhoneNumber());
        userService.updateById(user);
        if (updateById){
            return R.ok().message("修改成功");
        }
        return R.error().message("修改失败");
    }
    //6.增加
    @PostMapping
    public R addClerk(@RequestBody Clerk clerk){
        String phoneNumber = clerk.getPhoneNumber();
        QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
        clerkQueryWrapper.eq("phone_number",phoneNumber);
        long count = clerkService.count(clerkQueryWrapper);
        if (count >= 1 ){
            R.error().message("增加失败,请检查手机号是否重复!");
        }
        boolean save = clerkService.addClerk(clerk);

        if (save){
            return R.ok().message("增加成功");
        }
        return R.error().message("增加失败,请检查手机号是否重复!");
    }
    //根据部门查询
    @GetMapping("listClerkByDepartmentId/{id}")
    public R listClerkByDepartmentId(@PathVariable String id){
        QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
        clerkQueryWrapper.eq("department_id",id);
        List<Clerk> clerkList = clerkService.list(clerkQueryWrapper);
        return R.ok().data("clerkList",clerkList);
    }
    //用户获取个人信息
    @PostMapping("getClerkAndUserRole")
    public R getClerkAndUserRole(@RequestHeader("X-Token") String token) {
        String id = JwtUtils.getMemberIdByToken(token);
        //获取账户信息
        User user = userService.getById(id);
        //获取权限信息
        QueryWrapper<Role> roleQueryWrapper = new QueryWrapper<>();
        roleQueryWrapper.eq("userid",id);
        List<Role> roleList = roleService.list(roleQueryWrapper);
        //获取个人信息
        QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
        clerkQueryWrapper.eq("user_id",id);
        Clerk clerk = clerkService.getOne(clerkQueryWrapper);
        Department department = departmentService.getById(clerk.getDepartmentId());
        // 这里应该设置部门名称到相应的字段，而不是departmentId
        // clerk.setDepartmentName(department.getName());
        return R.ok().data("user",user).data("roleList",roleList).data("clerk",clerk);
    }
    //根据部门编号查询员工
    @GetMapping("getClerkByDepartmentId/{departmentId}")
    public R getClerkByDepartmentId(@PathVariable String departmentId){
        QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
        clerkQueryWrapper.eq("department_id",departmentId);
        List<Clerk> clerkList = clerkService.list(clerkQueryWrapper);
        return R.ok().data("clerkList",clerkList);
    }
    //查询离职员工
    //1.分页查询
    @PostMapping("listPageLiZhi/{current}/{limit}")
    public R getClerkListPageLiZhi(@PathVariable long current, @PathVariable long limit, @RequestBody(required = false) ClerkQueryVo clerkQueryVo) {
        Page<Clerk> clerkPage = new Page<>(current,limit);
        clerkQueryVo.setIsDeleted(1);
        IPage<Clerk> clerkIPage = clerkService.pageListQuery(clerkPage,clerkQueryVo);
        //获取总记录数
        long total = clerkIPage.getTotal();
        //每页类别集合
        List<Clerk> clerkList = clerkIPage.getRecords();
        return R.ok().data("clerkList",clerkList).data("total",total);
    }

    //更新员工技能
    @PutMapping("updateSkills")
    public R updateClerkSkills(@RequestHeader("X-Token") String token, @RequestBody Map<String, Object> skillsData) {
        try {
            String userId = JwtUtils.getMemberIdByToken(token);
            
            // 根据用户ID查找员工信息
            QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
            clerkQueryWrapper.eq("user_id", userId);
            Clerk clerk = clerkService.getOne(clerkQueryWrapper);
            
            if (clerk == null) {
                return R.error().message("员工信息不存在");
            }
            
            // 将技能数组转换为JSON字符串
            ObjectMapper objectMapper = new ObjectMapper();
            String skillsJson = objectMapper.writeValueAsString(skillsData.get("skills"));
            
            // 更新技能信息
            clerk.setSkills(skillsJson);
            boolean updated = clerkService.updateById(clerk);
            
            if (updated) {
                return R.ok().message("技能更新成功");
            } else {
                return R.error().message("技能更新失败");
            }
        } catch (Exception e) {
            return R.error().message("技能更新失败: " + e.getMessage());
        }
    }

    //获取员工详细资料（包含技能和联系信息）
    @GetMapping("profile")
    public R getClerkProfile(@RequestHeader("X-Token") String token) {
        try {
            String userId = JwtUtils.getMemberIdByToken(token);
            
            // 根据用户ID查找员工信息
            QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
            clerkQueryWrapper.eq("user_id", userId);
            Clerk clerk = clerkService.getOne(clerkQueryWrapper);
            
            if (clerk == null) {
                return R.error().message("员工信息不存在");
            }
            
            // 获取部门信息
            Department department = departmentService.getById(clerk.getDepartmentId());
            String departmentName = department != null ? department.getName() : "未分配部门";
            
            // 解析技能JSON
            Object skills = null;
            if (clerk.getSkills() != null && !clerk.getSkills().isEmpty()) {
                try {
                    ObjectMapper objectMapper = new ObjectMapper();
                    skills = objectMapper.readValue(clerk.getSkills(), Object.class);
                } catch (Exception e) {
                    skills = new String[]{}; // 如果解析失败，返回空数组
                }
            } else {
                skills = new String[]{};
            }
            
            return R.ok()
                .data("id", clerk.getId())
                .data("name", clerk.getName())
                .data("sex", clerk.getSex())
                .data("phoneNumber", clerk.getPhoneNumber())
                .data("email", clerk.getEmail())
                .data("idCard", clerk.getIdCard())
                .data("photo", clerk.getPhoto())
                .data("position", clerk.getPosition())
                .data("address", clerk.getAddress())
                .data("departmentId", clerk.getDepartmentId())
                .data("departmentName", departmentName)
                .data("skills", skills);
        } catch (Exception e) {
            return R.error().message("获取员工资料失败: " + e.getMessage());
        }
    }

    //更新员工基本信息（包含邮箱）
    @PutMapping("updateProfile")
    public R updateClerkProfile(@RequestHeader("X-Token") String token, @RequestBody Clerk clerkData) {
        try {
            String userId = JwtUtils.getMemberIdByToken(token);
            
            // 根据用户ID查找员工信息
            QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
            clerkQueryWrapper.eq("user_id", userId);
            Clerk clerk = clerkService.getOne(clerkQueryWrapper);
            
            if (clerk == null) {
                return R.error().message("员工信息不存在");
            }
            
            // 更新允许修改的字段
            if (clerkData.getEmail() != null) {
                clerk.setEmail(clerkData.getEmail());
            }
            if (clerkData.getAddress() != null) {
                clerk.setAddress(clerkData.getAddress());
            }
            if (clerkData.getPhoneNumber() != null) {
                clerk.setPhoneNumber(clerkData.getPhoneNumber());
            }
            
            boolean updated = clerkService.updateById(clerk);
            
            if (updated) {
                return R.ok().message("个人信息更新成功");
            } else {
                return R.error().message("个人信息更新失败");
            }
        } catch (Exception e) {
            return R.error().message("个人信息更新失败: " + e.getMessage());
        }
    }
}

