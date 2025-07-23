#include "OpenGLRenderer.h"
#include "ExampleBase.hpp"
#include <memory>
#include <vector>
#include <iostream>
#include <string>
#include <OpenGL/gl3.h>

// 示例实例包装
struct ExampleInstance {
    std::unique_ptr<ExampleBase> example;
    bool initialized;
    
    ExampleInstance(std::unique_ptr<ExampleBase> ex) 
        : example(std::move(ex)), initialized(false) {}
};

// 用于Swift获取示例信息的静态存储
static std::vector<ExampleInfo> cachedExamples;

extern "C" {

// 示例实例管理
ExampleInstance* createExampleById(const char* id) {
    if (!id) {
        std::cout << "Error: id is null" << std::endl;
        return nullptr;
    }
    
    auto example = ExampleRegistry::getInstance().createExample(id);
    if (!example) {
        std::cout << "Failed to create example: " << id << std::endl;
        return nullptr;
    }
    
    return new ExampleInstance(std::move(example));
}

void destroyExample(ExampleInstance* instance) {
    if (instance) {
        if (instance->example && instance->initialized) {
            instance->example->cleanup();
        }
        delete instance;
    }
}

void initializeExample(ExampleInstance* instance) {
    if (instance && instance->example && !instance->initialized) {
        instance->example->initialize();
        instance->initialized = true;
    }
}

void renderExample(ExampleInstance* instance) {
    if (instance && instance->example && instance->initialized) {
        instance->example->display();
    }
}

void resizeExample(ExampleInstance* instance, int width, int height) {
    if (instance && instance->example && instance->initialized) {
        instance->example->onResize(width, height);
    }
}

// 示例信息获取
int cppGetExampleCount(void) {
    auto examples = ExampleRegistry::getInstance().getAllExamples();
    cachedExamples = examples;
    return static_cast<int>(examples.size());
}

void cppGetExampleInfo(int index, struct CExampleInfo* info) {
    if (!info) return;
    
    if (index < 0 || index >= static_cast<int>(cachedExamples.size())) {
        info->id = "";
        info->title = "";
        info->chapter = "";
        info->description = "";
        info->order = 0;
        return;
    }
    
    const auto& exampleInfo = cachedExamples[index];
    
    // 使用静态存储确保字符串生命周期
    static std::vector<std::string> stringStorage;
    stringStorage.clear();
    stringStorage.push_back(exampleInfo.id);
    stringStorage.push_back(exampleInfo.title);
    stringStorage.push_back(exampleInfo.chapter);
    stringStorage.push_back(exampleInfo.description);
    
    info->id = stringStorage[0].c_str();
    info->title = stringStorage[1].c_str();
    info->chapter = stringStorage[2].c_str();
    info->description = stringStorage[3].c_str();
    info->order = exampleInfo.order;
}

// 工具函数
unsigned int loadShader(const char* vertexSource, const char* fragmentSource) {
    if (!vertexSource || !fragmentSource) return 0;
    
    // 创建顶点着色器
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexSource, NULL);
    glCompileShader(vertexShader);
    
    // 检查编译错误
    GLint success;
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        std::cout << "Vertex shader compilation failed: " << infoLog << std::endl;
        glDeleteShader(vertexShader);
        return 0;
    }
    
    // 创建片段着色器
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentSource, NULL);
    glCompileShader(fragmentShader);
    
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "Fragment shader compilation failed: " << infoLog << std::endl;
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return 0;
    }
    
    // 创建着色器程序
    GLuint shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        std::cout << "Shader program linking failed: " << infoLog << std::endl;
        glDeleteProgram(shaderProgram);
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return 0;
    }
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return shaderProgram;
}

void useShader(unsigned int shaderProgram) {
    glUseProgram(shaderProgram);
}

void clearScreen(float r, float g, float b, float a) {
    glClearColor(r, g, b, a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

}