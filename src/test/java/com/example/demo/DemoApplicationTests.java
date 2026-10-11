package com.example.demo;

import com.example.demo.controller.HelloController;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class DemoApplicationTests {

    @Autowired
    private HelloController helloController;

    @Test
    @DisplayName("Kiểm tra Spring Context khởi tạo thành công")
    void contextLoads() {
        assertNotNull(helloController, "HelloController phải được inject thành công");
    }

    @Test
    @DisplayName("Kiểm tra API Health trả về OK (Cố tình làm fail để kiểm chứng)")
    void testHealthEndpoint() {
        String result = helloController.health();
        // Cố tình gán kỳ vọng là FAIL để kiểm chứng Job test báo đỏ và Job docker-build chuyển sang Skipped
        assertEquals("FAIL_TRIGGER_SKIPPED", result, "Cố tình làm đứt JUnit Test để kiểm chứng needs: test");
    }

    @Test
    @DisplayName("Kiểm tra API Index trả về status UP")
    void testIndexEndpoint() {
        Map<String, Object> response = helloController.index();
        assertEquals("UP", response.get("status"));
        assertTrue(response.containsKey("message"));
    }
}
