package com.gzb.staff.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Clerk;
import com.baomidou.mybatisplus.extension.service.IService;
import com.gzb.staff.entity.vo.ClerkQueryVo;

/**
 * <p>
 * 职员表 服务类
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
public interface ClerkService extends IService<Clerk> {
    //员工分页查询
    IPage<Clerk> pageListQuery(Page<Clerk> clerkPage, ClerkQueryVo clerkQueryVo);

    boolean addClerk(Clerk clerk);

    boolean updateClerk(Clerk clerk);

    boolean deleteClerkById(String id);
}
