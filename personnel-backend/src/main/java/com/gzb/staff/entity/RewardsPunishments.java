package com.gzb.staff.entity;

import com.baomidou.mybatisplus.annotation.*;

import java.math.BigDecimal;
import java.util.Date;
import java.io.Serializable;
import java.util.Objects;

import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import io.swagger.v3.oas.annotations.media.Schema;

/**
 * <p>
 * 奖惩表
 * </p>
 *
 * @author
 * @since 2025-05-30
 */
@Schema(description = "奖惩表")
public class RewardsPunishments implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "id")
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @Schema(description = "奖惩类型:0奖励，1惩罚")
    private Integer type;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "奖惩日期")
    private Date time;

    @Schema(description = "奖惩原因")
    private String reason;

    @Schema(description = "奖惩金额")
    private BigDecimal money;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "员工id")
    private String clerkId;

    @Schema(description = "部门编号")
    private String departmentId;

    @Schema(description = "逻辑删除 1（true）已删除， 0（false）未删除")
    @TableLogic
    private Integer isDeleted;

    @Schema(description = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    private Date gmtCreate;

    @Schema(description = "更新时间")
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date gmtModified;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
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

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getClerkId() {
        return clerkId;
    }

    public void setClerkId(String clerkId) {
        this.clerkId = clerkId;
    }

    public String getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId;
    }

    public Integer getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Integer isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Date getGmtCreate() {
        return gmtCreate;
    }

    public void setGmtCreate(Date gmtCreate) {
        this.gmtCreate = gmtCreate;
    }

    public Date getGmtModified() {
        return gmtModified;
    }

    public void setGmtModified(Date gmtModified) {
        this.gmtModified = gmtModified;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RewardsPunishments that = (RewardsPunishments) o;
        return Objects.equals(id, that.id) && Objects.equals(type, that.type) && Objects.equals(time, that.time) && Objects.equals(reason, that.reason) && Objects.equals(money, that.money) && Objects.equals(remark, that.remark) && Objects.equals(clerkId, that.clerkId) && Objects.equals(departmentId, that.departmentId) && Objects.equals(isDeleted, that.isDeleted) && Objects.equals(gmtCreate, that.gmtCreate) && Objects.equals(gmtModified, that.gmtModified);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, type, time, reason, money, remark, clerkId, departmentId, isDeleted, gmtCreate, gmtModified);
    }

    @Override
    public String toString() {
        return "RewardsPunishments{" +
                "id='" + id + '\'' +
                ", type=" + type +
                ", time=" + time +
                ", reason='" + reason + '\'' +
                ", money=" + money +
                ", remark='" + remark + '\'' +
                ", clerkId='" + clerkId + '\'' +
                ", departmentId='" + departmentId + '\'' +
                ", isDeleted=" + isDeleted +
                ", gmtCreate=" + gmtCreate +
                ", gmtModified=" + gmtModified +
                '}';
    }
}
