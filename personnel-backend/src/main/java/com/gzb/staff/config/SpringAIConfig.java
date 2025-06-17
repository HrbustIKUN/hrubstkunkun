package com.gzb.staff.config;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Spring AI 配置类
 * 配置AI聊天模型和客户端
 * 只有在正确配置DeepSeek API密钥时才启用（兼容OpenAI接口）
 */
@Configuration
public class SpringAIConfig {

    /**
     * 配置聊天客户端
     * 只有当ChatModel bean存在且配置了有效的DeepSeek API密钥时才创建ChatClient
     */
    @Bean
    @ConditionalOnBean(ChatModel.class)
    @ConditionalOnProperty(name = "spring.ai.openai.api-key")
    public ChatClient chatClient(ChatModel chatModel) {
        return ChatClient.builder(chatModel).build();
    }
}