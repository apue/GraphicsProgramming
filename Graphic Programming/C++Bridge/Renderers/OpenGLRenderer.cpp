#include "OpenGLRenderer.h"
#include "ExampleBase.hpp"
#include <memory>
#include <iostream>
#include <OpenGL/gl3.h>

// Bridge implementation - simple OpenGL wrapper for legacy compatibility
struct OpenGLRenderer {
    bool initialized = false;
    
    void initialize() {
        if (!initialized) {
            glEnable(GL_DEPTH_TEST);
            initialized = true;
        }
    }
    
    void clear() {
        glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    
    void setViewport(int width, int height) {
        glViewport(0, 0, width, height);
    }
};

// Example instance wrapper
struct ExampleInstance {
    std::unique_ptr<ExampleBase> example;
    bool initialized;
    
    ExampleInstance(std::unique_ptr<ExampleBase> ex) 
        : example(std::move(ex)), initialized(false) {}
};

extern "C" {

// Traditional renderer functions (for backward compatibility)
OpenGLRenderer* createRenderer(void) {
    return new OpenGLRenderer();
}

void destroyRenderer(OpenGLRenderer* renderer) {
    delete renderer;
}

void initializeRenderer(OpenGLRenderer* renderer) {
    if (renderer) {
        renderer->initialize();
    }
}

void renderFrame(OpenGLRenderer* renderer) {
    if (renderer) {
        renderer->clear();
        // Default rendering - just clear screen with dark gray background
    }
}

void resizeViewport(OpenGLRenderer* renderer, int width, int height) {
    if (renderer) {
        renderer->setViewport(width, height);
    }
}

// New example-based functions
ExampleInstance* createExampleByClassName(const char* className) {
    if (!className) {
        std::cout << "Error: className is null" << std::endl;
        return nullptr;
    }
    
    std::cout << "Creating example: " << className << std::endl;
    
    auto example = ExampleRegistry::getInstance().createExample(className);
    if (!example) {
        std::cout << "Failed to create example: " << className << std::endl;
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
        try {
            instance->example->initialize();
            instance->initialized = true;
            std::cout << "Example initialized successfully" << std::endl;
        } catch (const std::exception& e) {
            std::cout << "Failed to initialize example: " << e.what() << std::endl;
        }
    }
}

void renderExample(ExampleInstance* instance) {
    if (instance && instance->example && instance->initialized) {
        try {
            instance->example->display();
        } catch (const std::exception& e) {
            std::cout << "Failed to render example: " << e.what() << std::endl;
        }
    }
}

void resizeExample(ExampleInstance* instance, int width, int height) {
    if (instance && instance->example && instance->initialized) {
        try {
            glViewport(0, 0, width, height);
            instance->example->onResize(width, height);
        } catch (const std::exception& e) {
            std::cout << "Failed to resize example: " << e.what() << std::endl;
        }
    }
}

unsigned int loadShader(const char* vertexSource, const char* fragmentSource) {
    // Simplified shader loading - for compatibility only
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexSource, NULL);
    glCompileShader(vertexShader);
    
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentSource, NULL);
    glCompileShader(fragmentShader);
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return program;
}

void useShader(unsigned int shaderProgram) {
    glUseProgram(shaderProgram);
}

void clearScreen(float r, float g, float b, float a) {
    glClearColor(r, g, b, a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void drawTriangle(float vertices[9]) {
    // Simplified triangle drawing for compatibility
    GLuint VAO, VBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, 9 * sizeof(float), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
}

void drawQuad(float vertices[12]) {
    // Simplified quad drawing for compatibility  
    GLuint VAO, VBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, 12 * sizeof(float), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
}

} // extern "C"