package com.gzb.staff.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.gzb.staff.entity.AIDocumentTemplate;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * AI文档模板 Mapper 接口
 */
@Mapper
public interface AIDocumentTemplateMapper extends BaseMapper<AIDocumentTemplate> {

    /**
     * 根据模板类型查询模板
     */
    @Select("SELECT * FROM ai_document_template WHERE template_type = #{templateType} AND is_deleted = 0 ORDER BY is_system DESC, usage_count DESC")
    List<AIDocumentTemplate> selectByTemplateType(@Param("templateType") String templateType);

    /**
     * 根据部门和角色查询适用的模板
     */
    @Select("SELECT * FROM ai_document_template WHERE (department_id = #{departmentId} OR department_id IS NULL) AND (role_type = #{roleType} OR role_type IS NULL) AND is_deleted = 0 ORDER BY is_system DESC, usage_count DESC")
    List<AIDocumentTemplate> selectByDepartmentAndRole(@Param("departmentId") String departmentId, @Param("roleType") String roleType);

    /**
     * 查询系统模板
     */
    @Select("SELECT * FROM ai_document_template WHERE is_system = 1 AND is_deleted = 0 ORDER BY template_type, usage_count DESC")
    List<AIDocumentTemplate> selectSystemTemplates();

    /**
     * 查询用户创建的模板
     */
    List<AIDocumentTemplate> selectByCreator(@Param("creatorId") String creatorId);

    /**
     * 增加模板使用次数
     */
    int incrementUsageCount(@Param("id") String id);

    /**
     * 查询热门模板
     */
    List<AIDocumentTemplate> selectPopularTemplates(@Param("limit") Integer limit);
}