#include "OpenGLRenderer.h"
#include "GraphicsProgramming.hpp"
#include <memory>

// Bridge implementation - wraps C++ class in C interface
struct OpenGLRenderer {
    std::unique_ptr<GraphicsProgramming::Renderer> renderer;
    
    OpenGLRenderer() : renderer(std::make_unique<GraphicsProgramming::Renderer>()) {}
};

extern "C" {

OpenGLRenderer* createRenderer(void) {
    return new OpenGLRenderer();
}

void destroyRenderer(OpenGLRenderer* renderer) {
    delete renderer;
}

void initializeRenderer(OpenGLRenderer* renderer) {
    if (renderer && renderer->renderer) {
        renderer->renderer->initialize();
    }
}

void renderFrame(OpenGLRenderer* renderer) {
    if (renderer && renderer->renderer) {
        renderer->renderer->clear();
        
        // Default: render a basic triangle as example
        GraphicsProgramming::Examples::drawBasicTriangle(*renderer->renderer);
    }
}

void resizeViewport(OpenGLRenderer* renderer, int width, int height) {
    if (renderer && renderer->renderer) {
        renderer->renderer->setViewport(width, height);
    }
}

unsigned int loadShader(const char* vertexSource, const char* fragmentSource) {
    try {
        GraphicsProgramming::Shader shader(vertexSource, fragmentSource);
        // Note: This is a simplified implementation
        // In a real scenario, you'd want to manage shader lifecycle properly
        return 1; // Return a dummy ID for now
    } catch (...) {
        return 0;
    }
}

void useShader(unsigned int shaderProgram) {
    glUseProgram(shaderProgram);
}

void clearScreen(float r, float g, float b, float a) {
    glClearColor(r, g, b, a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void drawTriangle(float vertices[9]) {
    std::vector<float> verts(vertices, vertices + 9);
    
    // Create a temporary renderer instance for standalone drawing
    GraphicsProgramming::Renderer tempRenderer;
    tempRenderer.initialize();
    tempRenderer.drawTriangle(verts);
}

void drawQuad(float vertices[12]) {
    std::vector<float> verts(vertices, vertices + 12);
    
    // Create a temporary renderer instance for standalone drawing
    GraphicsProgramming::Renderer tempRenderer;
    tempRenderer.initialize();
    tempRenderer.drawQuad(verts);
}

} // extern "C"