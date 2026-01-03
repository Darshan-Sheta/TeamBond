package com.spring.codeamigosbackend.config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.cloudinary.*;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class AppConfig {

    @Bean
    public Cloudinary getCloudinary() {
        Map config = new HashMap();
        config.put("cloud_name", LoadEnvConfig.get("CLOUD_NAME"));
        config.put("api_key", LoadEnvConfig.get("API_KEY"));
        config.put("api_secret", LoadEnvConfig.get("API_SECRET"));
        return new Cloudinary(config);
    }
}
