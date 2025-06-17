package com.gzb.staff.entity.vo;

import io.swagger.v3.oas.annotations.media.Schema;

public class AttendanceQueryVo {
    @Schema(description = "考勤名称")
    private String name;

    @Schema(description = "员工姓名")
    private String clerkName;

    @Schema(description = "部门姓名")
    private String departmentName;

    @Schema(description = "审核状态:0正在审核，1审核通过，2审核不通过")
    private String audit;

    @Schema(description = "考勤状态:正常0,事假1,迟到2,早退3,病假4,旷工5,休补6")
    private String status;

    // getter and setter methods
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getClerkName() {
        return clerkName;
    }

    public void setClerkName(String clerkName) {
        this.clerkName = clerkName;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getAudit() {
        return audit;
    }

    public void setAudit(String audit) {
        this.audit = audit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "AttendanceQueryVo{" +
                "clerkName='" + clerkName + '\'' +
                ", departmentName='" + departmentName + '\'' +
                ", audit='" + audit + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
