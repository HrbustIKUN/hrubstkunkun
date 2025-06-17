package com.gzb.staff.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Contract;
import com.gzb.staff.entity.vo.ContractQueryVo;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * 合同表 Mapper 接口
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
public interface ContractMapper extends BaseMapper<Contract> {

    IPage<Contract> pageListQuery(Page<Contract> clerkPage,@Param("contractQueryVo") ContractQueryVo contractQueryVo);
}
