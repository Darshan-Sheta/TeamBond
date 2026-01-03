package com.spring.codeamigosbackend.config;

import io.github.cdimascio.dotenv.Dotenv;
import java.io.File;

public class LoadEnvConfig {

    private static boolean isLocal = false;

    public static void load() {
        try {
            // Try to load .env file if it exists (for local development)
            File envFile = new File(".env");
            if (envFile.exists()) {
                Dotenv dotenv = Dotenv.load();
                dotenv.entries().forEach(entry -> System.setProperty(entry.getKey(), entry.getValue()));
                System.out.println("Loaded environment variables from .env file");
                isLocal = true;
            } else {
                // .env file doesn't exist - environment variables are provided by platform
                // (Railway, etc.)
                System.out.println(".env file not found - using system environment variables");
                isLocal = false;
            }
        } catch (Exception e) {
            // If .env loading fails, continue with system environment variables
            System.out.println("Could not load .env file: " + e.getMessage() + " - using system environment variables");
        }
    }

    public static String get(String key) {
        // First try to get from System properties (populated by .env in local)
        String value = System.getProperty(key);

        // If not found, try System environment variables (Production/Container)
        if (value == null || value.isEmpty()) {
            value = System.getenv(key);
        }

        return value;
    }
}
