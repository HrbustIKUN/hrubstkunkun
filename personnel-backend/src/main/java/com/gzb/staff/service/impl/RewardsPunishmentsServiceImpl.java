package com.gzb.staff.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.RewardsPunishments;
import com.gzb.staff.entity.vo.RPQueryVo;
import com.gzb.staff.mapper.RewardsPunishmentsMapper;
import com.gzb.staff.service.RewardsPunishmentsService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 奖惩表 服务实现类
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
@Service
public class RewardsPunishmentsServiceImpl extends ServiceImpl<RewardsPunishmentsMapper, RewardsPunishments> implements RewardsPunishmentsService {

    @Override
    public IPage<RewardsPunishments> pageListQuery(Page<RewardsPunishments> clerkPage, RPQueryVo rpQueryVo) {
        IPage<RewardsPunishments> rewardsPunishmentsIPage = baseMapper.pageListQuery(clerkPage,rpQueryVo);
        return rewardsPunishmentsIPage;
    }
}
