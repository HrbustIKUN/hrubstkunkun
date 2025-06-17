package com.gzb.staff.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Contract;
import com.gzb.staff.entity.vo.ContractQueryVo;
import com.gzb.staff.mapper.ContractMapper;
import com.gzb.staff.service.ContractService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 合同表 服务实现类
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
@Service
public class ContractServiceImpl extends ServiceImpl<ContractMapper, Contract> implements ContractService {

    @Override
    public IPage<Contract> pageListQuery(Page<Contract> clerkPage, ContractQueryVo contractQueryVo) {
        IPage<Contract> contractIPage = baseMapper.pageListQuery(clerkPage,contractQueryVo);
        return contractIPage;
    }
}
