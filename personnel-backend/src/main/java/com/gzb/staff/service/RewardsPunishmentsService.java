package com.gzb.staff.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.RewardsPunishments;
import com.baomidou.mybatisplus.extension.service.IService;
import com.gzb.staff.entity.vo.RPQueryVo;

/**
 * <p>
 * 奖惩表 服务类
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
public interface RewardsPunishmentsService extends IService<RewardsPunishments> {

    IPage<RewardsPunishments> pageListQuery(Page<RewardsPunishments> clerkPage, RPQueryVo rpQueryVo);
}
