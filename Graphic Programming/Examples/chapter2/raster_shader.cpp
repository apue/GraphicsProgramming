#include "ExampleBase.hpp"
#include <OpenGL/gl3.h>
#include <iostream>
#include <string>
#include <cmath>

class RasterShaderExample : public ExampleBase {
private:
    GLuint shaderProgram;
    GLuint VAO, VBO;
    float time = 0.0f;
    
    const char* vertexShaderSource = R"(
        #version 410 core
        layout (location = 0) in vec3 aPos;
        layout (location = 1) in vec3 aColor;
        out vec3 vertexColor;
        uniform float time;
        void main() {
            // Add some animation based on time
            vec3 pos = aPos;
            pos.x += sin(time + aPos.y) * 0.1;
            gl_Position = vec4(pos, 1.0);
            vertexColor = aColor;
        }
    )";
    
    const char* fragmentShaderSource = R"(
        #version 410 core
        in vec3 vertexColor;
        out vec4 FragColor;
        uniform float time;
        void main() {
            // Add some color variation based on time
            vec3 color = vertexColor;
            color.r += sin(time * 2.0) * 0.2;
            color.g += cos(time * 1.5) * 0.2;
            color.b += sin(time * 3.0) * 0.1;
            FragColor = vec4(color, 1.0);
        }
    )";
    
    GLuint compileShader(GLenum type, const char* source) {
        GLuint shader = glCreateShader(type);
        glShaderSource(shader, 1, &source, NULL);
        glCompileShader(shader);
        
        int success;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
        if (!success) {
            char infoLog[512];
            glGetShaderInfoLog(shader, 512, NULL, infoLog);
            std::cout << "ERROR::SHADER::COMPILATION_FAILED\n" << infoLog << std::endl;
        }
        return shader;
    }

public:
    void initialize() override {
        std::cout << "Initializing Raster Shader Example" << std::endl;
        
        // Create and compile shaders
        GLuint vertexShader = compileShader(GL_VERTEX_SHADER, vertexShaderSource);
        GLuint fragmentShader = compileShader(GL_FRAGMENT_SHADER, fragmentShaderSource);
        
        // Create shader program
        shaderProgram = glCreateProgram();
        glAttachShader(shaderProgram, vertexShader);
        glAttachShader(shaderProgram, fragmentShader);
        glLinkProgram(shaderProgram);
        
        // Check linking
        int success;
        glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
        if (!success) {
            char infoLog[512];
            glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
            std::cout << "ERROR::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
        }
        
        // Clean up shaders
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        
        // Triangle vertices with colors (position + color)
        float vertices[] = {
            // positions         // colors
            -0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,  // bottom left - red
             0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,  // bottom right - green
             0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f   // top - blue
        };
        
        // Create VAO and VBO
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);
        
        glBindVertexArray(VAO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        
        // Position attribute
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        
        // Color attribute
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
        glEnableVertexAttribArray(1);
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);
        
        std::cout << "Raster Shader Example initialized successfully" << std::endl;
    }
    
    void display() override {
        // Clear screen with dark background
        glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        // Use shader program
        glUseProgram(shaderProgram);
        
        // Update time uniform
        time += 0.016f; // ~60 FPS
        GLint timeLocation = glGetUniformLocation(shaderProgram, "time");
        glUniform1f(timeLocation, time);
        
        // Bind VAO and draw triangle
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        glBindVertexArray(0);
    }
    
    void cleanup() override {
        glDeleteVertexArrays(1, &VAO);
        glDeleteBuffers(1, &VBO);
        glDeleteProgram(shaderProgram);
        std::cout << "Raster Shader Example cleaned up" << std::endl;
    }
    
    std::string getName() const override {
        return "Raster Shader Example";
    }
};

// Register the example
REGISTER_EXAMPLE(RasterShaderExample);