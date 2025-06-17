package com.gzb.staff.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import io.swagger.v3.oas.annotations.media.Schema;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * AI文档模板实体类
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@Schema(name = "AIDocumentTemplate", description = "AI文档模板")
public class AIDocumentTemplate implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "ID")
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @Schema(description = "模板名称")
    private String templateName;

    @Schema(description = "模板类型")
    private String templateType;

    @Schema(description = "模板内容")
    private String templateContent;

    @Schema(description = "适用部门ID")
    private String departmentId;

    @Schema(description = "适用角色类型")
    private String roleType;

    @Schema(description = "是否系统模板")
    private Integer isSystem;

    @Schema(description = "使用次数")
    private Integer usageCount;

    @Schema(description = "创建者ID")
    private String creatorId;

    @Schema(description = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdTime;

    @Schema(description = "更新时间")
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedTime;

    @Schema(description = "逻辑删除")
    @TableLogic
    private Integer isDeleted;
}