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
    public IPage<RewardsPunishments> pageListQuery(Page<RewardsPunishments> rewardsPunishmentsPage, RPQueryVo rpQueryVo) {
        System.out.println("奖惩Service层接收到的查询参数: " + rpQueryVo);
        IPage<RewardsPunishments> result = baseMapper.pageListQuery(rewardsPunishmentsPage,rpQueryVo);
        System.out.println("奖惩查询结果数量: " + result.getRecords().size());
        return result;
    }
}
