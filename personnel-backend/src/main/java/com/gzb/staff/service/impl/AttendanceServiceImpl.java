package com.gzb.staff.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Attendance;
import com.gzb.staff.entity.vo.AttendanceQueryVo;
import com.gzb.staff.mapper.AttendanceMapper;
import com.gzb.staff.service.AttendanceService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 考勤表 服务实现类
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
@Service
public class AttendanceServiceImpl extends ServiceImpl<AttendanceMapper, Attendance> implements AttendanceService {

    @Override
    public IPage<Attendance> pageListQuery(Page<Attendance> attendancePage, AttendanceQueryVo attendanceQueryVo) {
        System.out.println("Service层接收到的查询参数: " + attendanceQueryVo);
        IPage<Attendance> result = baseMapper.pageListQuery(attendancePage,attendanceQueryVo);
        System.out.println("查询结果数量: " + result.getRecords().size());
        return result;
    }
}
