package com.gzb.staff.controller;


import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Clerk;
import com.gzb.staff.entity.Contract;
import com.gzb.staff.entity.vo.ContractQueryVo;
import com.gzb.staff.service.ClerkService;
import com.gzb.staff.service.ContractService;
import com.gzb.staff.utils.JwtUtils;
import com.gzb.staff.utils.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * 合同表 前端控制器
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
@RestController
@RequestMapping("/staff/contract")
@CrossOrigin
public class ContractController {
    @Autowired
    private ContractService contractService;
    @Autowired
    private ClerkService clerkService;
    //1.分页查询所有
    @PostMapping("listPage/{current}/{limit}")
    public R getContractListPage(@PathVariable long current,
                                 @PathVariable long limit,
                                 @RequestBody(required = false) ContractQueryVo contractQueryVo) {
        Page<Contract> clerkPage = new Page<>(current,limit);
        IPage<Contract> clerkIPage = contractService.pageListQuery(clerkPage,contractQueryVo);
        //获取总记录数
        long total = clerkIPage.getTotal();
        //每页类别集合
        List<Contract> contractList = clerkIPage.getRecords();
        return R.ok().data("contractList",contractList).data("total",total);
    }

    //3.查询所有
    @GetMapping("list")
    public R getContractList() {
        List<Contract> contractList = contractService.list((Wrapper<Contract>) null);
        return R.ok().data("contractList",contractList);
    }

    //2.根据id查询
    @GetMapping("{id}")
    public R getContractById(@PathVariable String id){
        Contract contract = contractService.getById(id);
        if (StringUtils.isEmpty(contract)){
            return R.error().message("没有此类别");
        }
        return R.ok().data("contract",contract);
    }

    //4.根据id删除
    @DeleteMapping("{id}")
    public R deleteContractById(@PathVariable String id){
        boolean removeById = contractService.removeById(id);
        if (removeById){
            return R.ok();
        }
        return R.error().message("删除失败");
    }

    //5.修改
    @PutMapping
    public R updateContract(@RequestBody Contract contract){
        boolean updateById = contractService.updateById(contract);
        if (updateById){
            return R.ok().message("修改成功");
        }
        return R.error().message("修改失败");
    }
    //6.增加
    @PostMapping
    public R addContract(@RequestBody Contract contract){
        boolean save = contractService.save(contract);

        if (save){
            return R.ok().message("增加成功");
        }
        return R.error().message("增加失败");
    }
    //7.根据登录人id查询合同
    //查询自身
    @PostMapping("getContract")
    public R getContract(@RequestHeader("X-Token") String token) {
        System.out.println("个人合同查询开始");
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
        QueryWrapper<Contract> contractQueryWrapper = new QueryWrapper<>();
        contractQueryWrapper.eq("clerk_id",clerkId).eq("is_deleted",0);
        List<Contract> contractList = contractService.list(contractQueryWrapper);
        System.out.println("查询到合同数量: " + contractList.size());
        return R.ok().data("contractList",contractList);
    }
    //查询快到期合同
    
}

