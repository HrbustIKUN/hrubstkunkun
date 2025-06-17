package com.gzb.staff.handler;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class MyMetaObjectHandler implements MetaObjectHandler {
    @Override
    public void insertFill(MetaObject metaObject) {
        //属性名称不是字段名称
        this.setFieldValByName("gmtCreate", new Date(), metaObject);
        this.setFieldValByName("gmtModified", new Date(), metaObject);
        // 支持AI相关实体类的时间字段
        this.setFieldValByName("createdTime", java.time.LocalDateTime.now(), metaObject);
        this.setFieldValByName("updatedTime", java.time.LocalDateTime.now(), metaObject);
    }
    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("gmtModified", new Date(), metaObject);
        // 支持AI相关实体类的时间字段
        this.setFieldValByName("updatedTime", java.time.LocalDateTime.now(), metaObject);
    }
}
