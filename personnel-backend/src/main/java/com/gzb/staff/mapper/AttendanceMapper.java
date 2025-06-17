package com.gzb.staff.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gzb.staff.entity.Attendance;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.gzb.staff.entity.vo.AttendanceQueryVo;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * 考勤表 Mapper 接口
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
public interface AttendanceMapper extends BaseMapper<Attendance> {

    IPage<Attendance> pageListQuery(Page<Attendance> attendancePage,@Param("attendanceQueryVo") AttendanceQueryVo attendanceQueryVo);
}
