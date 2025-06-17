package com.gzb.staff.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.vo.RPQueryVo;
import com.gzb.staff.entity.RewardsPunishments;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * 奖惩表 Mapper 接口
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
public interface RewardsPunishmentsMapper extends BaseMapper<RewardsPunishments> {

    IPage<RewardsPunishments> pageListQuery(Page<RewardsPunishments> clerkPage, @Param("rPQueryVo") RPQueryVo rpQueryVo);
}
