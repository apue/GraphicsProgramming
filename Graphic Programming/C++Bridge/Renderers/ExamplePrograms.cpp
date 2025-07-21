#include "GraphicsProgramming.hpp"
#include <cmath>

namespace GraphicsProgramming {
namespace Examples {

// Chapter 2: Basic Triangle (from Computer Graphics Programming in OpenGL with C++)
void Chapter2_BasicTriangle(Renderer& renderer) {
    // Clear the screen
    renderer.clear(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Define triangle vertices
    std::vector<float> vertices = {
        -0.5f, -0.5f, 0.0f,  // Left vertex
         0.5f, -0.5f, 0.0f,  // Right vertex
         0.0f,  0.5f, 0.0f   // Top vertex
    };
    
    renderer.drawTriangle(vertices);
}

// Chapter 2: Animated Triangle
void Chapter2_AnimatedTriangle(Renderer& renderer) {
    renderer.clear(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Get current time for animation
    static float time = 0.0f;
    time += 0.016f; // Simulate 60fps
    
    float offset = sin(time) * 0.3f;
    
    std::vector<float> vertices = {
        -0.5f + offset, -0.5f, 0.0f,
         0.5f + offset, -0.5f, 0.0f,
         0.0f + offset,  0.5f, 0.0f
    };
    
    renderer.drawTriangle(vertices);
}

// Chapter 3: Colored Quad
void Chapter3_ColoredQuad(Renderer& renderer) {
    renderer.clear(0.1f, 0.1f, 0.1f, 1.0f);
    
    // Define quad vertices
    std::vector<float> vertices = {
        -0.7f, -0.7f, 0.0f,  // Bottom left
         0.7f, -0.7f, 0.0f,  // Bottom right
         0.7f,  0.7f, 0.0f,  // Top right
        -0.7f,  0.7f, 0.0f   // Top left
    };
    
    renderer.drawQuad(vertices);
}

// Chapter 4: Multiple Objects
void Chapter4_MultipleObjects(Renderer& renderer) {
    renderer.clear(0.2f, 0.3f, 0.3f, 1.0f);
    
    // Draw first triangle (left)
    std::vector<float> leftTriangle = {
        -1.0f, -0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        -0.75f, 0.0f, 0.0f
    };
    renderer.drawTriangle(leftTriangle);
    
    // Draw second triangle (right)
    std::vector<float> rightTriangle = {
         0.5f, -0.5f, 0.0f,
         1.0f, -0.5f, 0.0f,
         0.75f, 0.0f, 0.0f
    };
    renderer.drawTriangle(rightTriangle);
    
    // Draw quad in center
    std::vector<float> centerQuad = {
        -0.3f, -0.8f, 0.0f,
         0.3f, -0.8f, 0.0f,
         0.3f, -0.2f, 0.0f,
        -0.3f, -0.2f, 0.0f
    };
    renderer.drawQuad(centerQuad);
}

// Advanced: Sierpinski Triangle (Fractal)
void Advanced_SierpinskiTriangle(Renderer& renderer) {
    renderer.clear(0.0f, 0.0f, 0.0f, 1.0f);
    
    // This is a simplified version - in a real implementation,
    // you would recursively generate the fractal
    
    // Main triangle
    std::vector<float> mainTriangle = {
        -0.8f, -0.8f, 0.0f,
         0.8f, -0.8f, 0.0f,
         0.0f,  0.8f, 0.0f
    };
    
    // Inner triangles (inverted)
    std::vector<float> innerTriangle1 = {
        -0.4f, -0.4f, 0.0f,
         0.0f, -0.4f, 0.0f,
        -0.2f,  0.0f, 0.0f
    };
    
    std::vector<float> innerTriangle2 = {
         0.0f, -0.4f, 0.0f,
         0.4f, -0.4f, 0.0f,
         0.2f,  0.0f, 0.0f
    };
    
    std::vector<float> innerTriangle3 = {
        -0.2f,  0.0f, 0.0f,
         0.2f,  0.0f, 0.0f,
         0.0f,  0.4f, 0.0f
    };
    
    renderer.drawTriangle(mainTriangle);
    // Note: In a real implementation, these would be "cut out" from the main triangle
}

} // namespace Examples
} // namespace GraphicsProgramming