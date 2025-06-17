package com.gzb.staff.controller;


import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Clerk;
import com.gzb.staff.entity.RewardsPunishments;
import com.gzb.staff.entity.vo.RPQueryVo;
import com.gzb.staff.service.ClerkService;
import com.gzb.staff.service.RewardsPunishmentsService;
import com.gzb.staff.utils.JwtUtils;
import com.gzb.staff.utils.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * 奖惩表 前端控制器
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
@RestController
@RequestMapping("/staff/rewards_punishments")
@CrossOrigin
public class RewardsPunishmentsController {
    @Autowired
    private RewardsPunishmentsService rewardsPunishmentsService;
    @Autowired
    private ClerkService clerkService;
    //1.分页查询所有
    @PostMapping("listPage/{current}/{limit}")
    public R getRewardsPunishmentsListPage(
            @PathVariable long current,
            @PathVariable long limit,
            @RequestBody(required = false) RPQueryVo rpQueryVo) {
        Page<RewardsPunishments> clerkPage = new Page<>(current,limit);
        IPage<RewardsPunishments> clerkIPage = rewardsPunishmentsService.pageListQuery(clerkPage,rpQueryVo);
        //获取总记录数
        long total = clerkIPage.getTotal();
        //每页类别集合
        List<RewardsPunishments> rewardsPunishmentsList = clerkIPage.getRecords();
        for (RewardsPunishments rewardsPunishments:rewardsPunishmentsList) {
            // 类型保持为数字，前端处理显示
            // type: 0-奖励, 1-惩罚
        }
        return R.ok().data("rewardsPunishmentsList",rewardsPunishmentsList).data("total",total);
    }

    //3.查询所有
    @GetMapping("list")
    public R getRewardsPunishmentsList() {
        List<RewardsPunishments> rewardsPunishmentsList = rewardsPunishmentsService.list((Wrapper<RewardsPunishments>) null);
        return R.ok().data("rewardsPunishmentsList",rewardsPunishmentsList);
    }

    //2.根据id查询
    @GetMapping("{id}")
    public R getRewardsPunishmentsById(@PathVariable String id){
        RewardsPunishments rewardsPunishments = rewardsPunishmentsService.getById(id);
        if (StringUtils.isEmpty(rewardsPunishments)){
            return R.error();
        }
        return R.ok().data("rewardsPunishments",rewardsPunishments);
    }

    //4.根据id删除
    @DeleteMapping("{id}")
    public R deleteRewardsPunishmentsById(@PathVariable String id){
        boolean removeById = rewardsPunishmentsService.removeById(id);
        if (removeById){
            return R.ok();
        }
        return R.error().message("删除失败");
    }

    //5.修改
    @PutMapping
    public R updateRewardsPunishments(@RequestBody RewardsPunishments rewardsPunishments){
        boolean updateById = rewardsPunishmentsService.updateById(rewardsPunishments);
        if (updateById){
            return R.ok().message("修改成功");
        }
        return R.error().message("修改失败");
    }

    //6.增加
    @PostMapping
    public R addRewardsPunishments(@RequestBody RewardsPunishments rewardsPunishments){
        boolean save = rewardsPunishmentsService.save(rewardsPunishments);
        if (save){
            return R.ok().message("增加成功");
        }
        return R.error().message("增加失败");
    }

    //根据token获取他的奖惩信息
    @PostMapping("getRewardsPunishments/{current}/{limit}")
    public R getRewardsPunishments(@PathVariable long current,
                                   @PathVariable long limit,
                                   @RequestBody(required = false) RPQueryVo rpQueryVo,
                                   @RequestHeader("X-Token") String token) {
        System.out.println("个人奖惩查询 - 接收到的参数: " + rpQueryVo);
        String id = JwtUtils.getMemberIdByToken(token);
        System.out.println("从token解析的用户ID: " + id);
        QueryWrapper<Clerk> clerkQueryWrapper = new QueryWrapper<>();
        clerkQueryWrapper.eq("user_id",id).eq("is_deleted",0);
        Clerk clerk = clerkService.getOne(clerkQueryWrapper);
        if (clerk == null) {
            System.out.println("员工信息不存在，用户ID: " + id);
            return R.error().message("员工信息不存在");
        }
        String clerkId = clerk.getId();
        System.out.println("找到员工ID: " + clerkId);
        QueryWrapper<RewardsPunishments> rewardsPunishmentsQueryWrapper = new QueryWrapper<>();
        rewardsPunishmentsQueryWrapper.eq("clerk_id",clerkId).eq("is_deleted",0);
        Page<RewardsPunishments> rewardsPunishmentsPage = new Page<>(current,limit);
        if (!StringUtils.isEmpty(rpQueryVo.getType())) {
            rewardsPunishmentsQueryWrapper.eq("type",rpQueryVo.getType());
        }
        if (!StringUtils.isEmpty(rpQueryVo.getReason())) {
            rewardsPunishmentsQueryWrapper.like("reason",rpQueryVo.getReason());
        }
        if (rpQueryVo.getMoney() != null) {
            rewardsPunishmentsQueryWrapper.eq("amount",rpQueryVo.getMoney());
        }
        rewardsPunishmentsService.page(rewardsPunishmentsPage,rewardsPunishmentsQueryWrapper);
        List<RewardsPunishments> rewardsPunishmentsList = rewardsPunishmentsPage.getRecords();
        System.out.println("查询到奖惩记录数量: " + rewardsPunishmentsList.size());
        for (RewardsPunishments rewardsPunishments:rewardsPunishmentsList) {
            // 类型保持为数字，前端处理显示
            // type: 0-奖励, 1-惩罚
        }
        long total = rewardsPunishmentsPage.getTotal();
        System.out.println("奖惩记录总数: " + total);
        return R.ok().data("rewardsPunishmentsList",rewardsPunishmentsList).data("total",total);
    }
}

