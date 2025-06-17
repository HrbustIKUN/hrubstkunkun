package com.gzb.staff.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.gzb.staff.entity.AIConversationHistory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * AI对话历史 Mapper 接口
 */
@Mapper
public interface AIConversationHistoryMapper extends BaseMapper<AIConversationHistory> {

    /**
     * 根据用户ID和会话ID查询对话历史
     */
    @Select("SELECT * FROM ai_conversation_history WHERE user_id = #{userId} AND session_id = #{sessionId} AND is_deleted = 0 ORDER BY created_time ASC")
    List<AIConversationHistory> selectByUserAndSession(@Param("userId") String userId, @Param("sessionId") String sessionId);

    /**
     * 查询用户最近的对话记录
     */
    @Select("SELECT * FROM ai_conversation_history WHERE user_id = #{userId} AND is_deleted = 0 ORDER BY created_time DESC LIMIT #{limit}")
    List<AIConversationHistory> selectRecentByUser(@Param("userId") String userId, @Param("limit") Integer limit);

    /**
     * 统计用户各功能使用次数
     */
    List<Map<String, Object>> countByFunctionType(@Param("userId") String userId);

    /**
     * 统计指定时间范围内的使用情况
     */
    List<Map<String, Object>> countByDateRange(@Param("startTime") LocalDateTime startTime, @Param("endTime") LocalDateTime endTime);
}