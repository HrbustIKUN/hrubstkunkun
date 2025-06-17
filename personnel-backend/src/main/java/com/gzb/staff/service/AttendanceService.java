package com.gzb.staff.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Attendance;
import com.baomidou.mybatisplus.extension.service.IService;
import com.gzb.staff.entity.vo.AttendanceQueryVo;

/**
 * <p>
 * 考勤表 服务类
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
public interface AttendanceService extends IService<Attendance> {

    IPage<Attendance> pageListQuery(Page<Attendance> attendancePage, AttendanceQueryVo attendanceQueryVo);
}
