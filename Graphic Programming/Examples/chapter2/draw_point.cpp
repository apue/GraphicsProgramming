#include "ExampleBase.hpp"
#include <OpenGL/gl3.h>
#include <iostream>
#include <string>
#include <cmath>

class DrawPointExample : public ExampleBase {
    
private:
    GLuint renderingProgram;
    GLuint vao[1];
public:
    void initialize() override {
        std::cout << "Initializing DrawPointExample" << std::endl;
        const char* vShaderSource = "#version 410 \n"
        "void main(void) \n"
        "{gl_Position = vec4(0.0, 0.0, 0.0, 1.0);}";
        const char* fShaderSource = "#version 410 \n"
        "out vec4 FragColor; \n"
        "void main(void) \n"
        "{FragColor = vec4(0.0, 0.0, 1.0, 1.0);}";
        
        GLuint vShader = glCreateShader(GL_VERTEX_SHADER);
        GLuint fShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(vShader, 1, &vShaderSource, NULL);
        glShaderSource(fShader, 1, &fShaderSource, NULL);
        glCompileShader(vShader);
        glCompileShader(fShader);
        
        GLuint vfProgram = glCreateProgram();
        // 检查着色器编译状态
        GLint success;
        GLchar infoLog[512];
        
        glGetShaderiv(vShader, GL_COMPILE_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(vShader, 512, NULL, infoLog);
            std::cout << "顶点着色器编译失败: " << infoLog << std::endl;
        }
        
        glGetShaderiv(fShader, GL_COMPILE_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(fShader, 512, NULL, infoLog);
            std::cout << "片段着色器编译失败: " << infoLog << std::endl;
        }
        
        // 检查程序链接状态
        glGetProgramiv(vfProgram, GL_LINK_STATUS, &success);
        if (!success) {
            glGetProgramInfoLog(vfProgram, 512, NULL, infoLog);
            std::cout << "着色器程序链接失败: " << infoLog << std::endl;
        } else {
            std::cout << "着色器程序链接成功!" << std::endl;
        }
        glAttachShader(vfProgram, vShader);
        glAttachShader(vfProgram, fShader);
        glLinkProgram(vfProgram);
        renderingProgram = vfProgram;
        glGenVertexArrays(1, vao);
        glBindVertexArray(vao[0]);
        // 验证VAO设置
        if (vao[0] == 0) {
            std::cout << "VAO创建失败!" << std::endl;
        } else {
            std::cout << "VAO创建成功: " << vao[0] << std::endl;
        }
    }
    
    void display() override {
        // 检查OpenGL错误
        GLenum error = glGetError();
        if (error != GL_NO_ERROR) {
            std::cout << "OpenGL错误 before display: " << error << std::endl;
        }
        
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        std::cout << "正在渲染点..." << std::endl;
        
        glUseProgram(renderingProgram);
        glPointSize(30.0f);
        glDrawArrays(GL_POINTS, 0, 1);
        
        // 检查渲染后的OpenGL错误
        error = glGetError();
        if (error != GL_NO_ERROR) {
            std::cout << "OpenGL错误 after draw: " << error << std::endl;
        }
        
    }
    
    void cleanup() override {
        
    }
    
    void onResize(int w, int h) override {
        
    }
    
    std::string getName() const override {
        return "DrawPointExample";
    }
};

AUTO_EXAMPLE(DrawPointExample, "draw point", "Draw a point on OpenGL", "第2章：着色器基础", "演示最基础的OpenGL渲染流程", 2)
