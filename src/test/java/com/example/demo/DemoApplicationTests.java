package com.example.demo.controller;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;


import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import com.example.demo.controller.HelloController;

@WebMvcTest(HelloController.class)
class DemoApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void testRootEndpoint() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.message").value("Hello from Demo Microservice!"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("running"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.timestamp").exists());
    }

    @Test
    void testHealthEndpoint() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/health"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("UP"));
    }
}
