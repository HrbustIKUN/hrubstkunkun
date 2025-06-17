package com.gzb.staff.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import io.swagger.v3.oas.annotations.media.Schema;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * AI对话历史实体类
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@Schema(name = "AIConversationHistory", description = "AI对话历史")
public class AIConversationHistory implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "ID")
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @Schema(description = "用户ID")
    private String userId;

    @Schema(description = "会话ID")
    private String sessionId;

    @Schema(description = "用户问题")
    private String question;

    @Schema(description = "AI回答")
    private String answer;

    @Schema(description = "功能类型")
    private String functionType;

    @Schema(description = "上下文信息")
    private String contextInfo;

    @Schema(description = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdTime;

    @Schema(description = "逻辑删除")
    @TableLogic
    private Integer isDeleted;
}