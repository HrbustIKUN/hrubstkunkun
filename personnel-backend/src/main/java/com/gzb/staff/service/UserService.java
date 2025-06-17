package com.gzb.staff.service;

import com.gzb.staff.entity.User;
import com.baomidou.mybatisplus.extension.service.IService;
import com.gzb.staff.entity.vo.UserVo;

/**
 * <p>
 * 用户表 服务类
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
public interface UserService extends IService<User> {
    //如果验证成功 返回tokrn 否则返回null或者异常
    String login(UserVo userVo);
}
