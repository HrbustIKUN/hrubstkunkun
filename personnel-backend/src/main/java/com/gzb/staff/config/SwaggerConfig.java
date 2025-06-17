package com.gzb.staff.config;

/**
 * SpringDoc OpenAPI 配置
 * 替代原有的 Swagger2 配置，兼容 Spring Boot 3.x
 */

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {
    
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("企业员工信息管理系统 API文档")
                        .description("本文档描述了企业员工信息管理系统的接口定义，包含AI办公功能")
                        .version("1.0")
                        .contact(new Contact()
                                .name("开发团队")
                                .email("admin@company.com")
                                .url("https://company.com")));
    }
}
