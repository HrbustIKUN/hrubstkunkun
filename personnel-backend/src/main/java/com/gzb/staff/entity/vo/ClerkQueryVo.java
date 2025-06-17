package com.gzb.staff.entity.vo;

import io.swagger.v3.oas.annotations.media.Schema;

public class ClerkQueryVo {
    @Schema(description = "职员姓名")
    private String name;

    @Schema(description = "职位")
    private String position;

    @Schema(description = "部门名称")
    private String departmentName;

    private Integer isDeleted;

    public ClerkQueryVo() {
    }

    public ClerkQueryVo(String name, String position, String departmentName, Integer isDeleted) {
        this.name = name;
        this.position = position;
        this.departmentName = departmentName;
        this.isDeleted = isDeleted;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public Integer getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Integer isDeleted) {
        this.isDeleted = isDeleted;
    }

    @Override
    public String toString() {
        return "ClerkQueryVo{" +
                "name='" + name + '\'' +
                ", position='" + position + '\'' +
                ", departmentName='" + departmentName + '\'' +
                ", isDeleted=" + isDeleted +
                '}';
    }
}
