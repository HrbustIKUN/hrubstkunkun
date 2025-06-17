package com.gzb.staff.entity.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;

public class RPQueryVo {

    @Schema(description = "奖惩类型:0奖励，1惩罚")
    private String type;

    private String time;

    @Schema(description = "奖惩原因")
    private String reason;

    @Schema(description = "奖惩金额")
    private BigDecimal money;

    @Schema(description = "员工")
    private String clerkName;

    @Schema(description = "部门")
    private String departmentName;

    // getter and setter methods
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public BigDecimal getMoney() {
        return money;
    }

    public void setMoney(BigDecimal money) {
        this.money = money;
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
}
