#include "GraphicsProgramming.hpp"
#include <iostream>
#include <fstream>
#include <sstream>

namespace GraphicsProgramming {

// Shader Implementation
Shader::Shader(const std::string& vertexSource, const std::string& fragmentSource) {
    unsigned int vertexShader = compileShader(vertexSource, GL_VERTEX_SHADER);
    unsigned int fragmentShader = compileShader(fragmentSource, GL_FRAGMENT_SHADER);
    
    linkProgram(vertexShader, fragmentShader);
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
}

Shader::~Shader() {
    glDeleteProgram(programID);
}

void Shader::use() const {
    glUseProgram(programID);
}

void Shader::setUniform(const std::string& name, float value) const {
    int location = glGetUniformLocation(programID, name.c_str());
    glUniform1f(location, value);
}

void Shader::setUniform(const std::string& name, int value) const {
    int location = glGetUniformLocation(programID, name.c_str());
    glUniform1i(location, value);
}

void Shader::setUniform(const std::string& name, const float* matrix4x4) const {
    int location = glGetUniformLocation(programID, name.c_str());
    glUniformMatrix4fv(location, 1, GL_FALSE, matrix4x4);
}

unsigned int Shader::compileShader(const std::string& source, GLenum type) {
    unsigned int shader = glCreateShader(type);
    const char* sourceCStr = source.c_str();
    glShaderSource(shader, 1, &sourceCStr, nullptr);
    glCompileShader(shader);
    
    int success;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetShaderInfoLog(shader, 512, nullptr, infoLog);
        std::cerr << "Shader compilation failed: " << infoLog << std::endl;
    }
    
    return shader;
}

void Shader::linkProgram(unsigned int vertexShader, unsigned int fragmentShader) {
    programID = glCreateProgram();
    glAttachShader(programID, vertexShader);
    glAttachShader(programID, fragmentShader);
    glLinkProgram(programID);
    
    int success;
    glGetProgramiv(programID, GL_LINK_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetProgramInfoLog(programID, 512, nullptr, infoLog);
        std::cerr << "Shader linking failed: " << infoLog << std::endl;
    }
}

// Mesh Implementation
Mesh::Mesh(const std::vector<float>& vertices, const std::vector<unsigned int>& indices) 
    : hasIndices(!indices.empty()), vertexCount(vertices.size() / 3), indexCount(indices.size()) {
    
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(float), vertices.data(), GL_STATIC_DRAW);
    
    if (hasIndices) {
        glGenBuffers(1, &EBO);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(unsigned int), indices.data(), GL_STATIC_DRAW);
    }
    
    // Position attribute (location = 0)
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    glBindVertexArray(0);
}

Mesh::~Mesh() {
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    if (hasIndices) {
        glDeleteBuffers(1, &EBO);
    }
}

void Mesh::draw() const {
    glBindVertexArray(VAO);
    if (hasIndices) {
        glDrawElements(GL_TRIANGLES, indexCount, GL_UNSIGNED_INT, 0);
    } else {
        glDrawArrays(GL_TRIANGLES, 0, vertexCount);
    }
    glBindVertexArray(0);
}

// Renderer Implementation
Renderer::Renderer() {
    
}

Renderer::~Renderer() {
    
}

void Renderer::initialize() {
    glEnable(GL_DEPTH_TEST);
    initializeBasicShader();
}

void Renderer::clear(float r, float g, float b, float a) {
    glClearColor(r, g, b, a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void Renderer::setViewport(int width, int height) {
    glViewport(0, 0, width, height);
}

void Renderer::drawTriangle(const std::vector<float>& vertices) {
    if (vertices.size() >= 9) {
        Mesh triangleMesh(vertices);
        drawMesh(triangleMesh, *basicShader);
    }
}

void Renderer::drawQuad(const std::vector<float>& vertices) {
    if (vertices.size() >= 12) {
        std::vector<unsigned int> indices = {0, 1, 2, 2, 3, 0};
        Mesh quadMesh(vertices, indices);
        drawMesh(quadMesh, *basicShader);
    }
}

void Renderer::drawMesh(const Mesh& mesh, const Shader& shader) {
    shader.use();
    mesh.draw();
}

void Renderer::initializeBasicShader() {
    const std::string vertexSource = R"(
        #version 410 core
        layout (location = 0) in vec3 aPos;
        
        void main() {
            gl_Position = vec4(aPos, 1.0);
        }
    )";
    
    const std::string fragmentSource = R"(
        #version 410 core
        out vec4 FragColor;
        
        void main() {
            FragColor = vec4(1.0, 0.5, 0.2, 1.0);
        }
    )";
    
    basicShader = std::make_unique<Shader>(vertexSource, fragmentSource);
}

// Example Programs
namespace Examples {

void drawBasicTriangle(Renderer& renderer) {
    std::vector<float> vertices = {
        -0.5f, -0.5f, 0.0f,
         0.5f, -0.5f, 0.0f,
         0.0f,  0.5f, 0.0f
    };
    
    renderer.drawTriangle(vertices);
}

void drawColoredTriangle(Renderer& renderer) {
    // This would require a more advanced shader with color attributes
    drawBasicTriangle(renderer);
}

void drawTexturedQuad(Renderer& renderer) {
    std::vector<float> vertices = {
        -0.5f, -0.5f, 0.0f,  // bottom left
         0.5f, -0.5f, 0.0f,  // bottom right
         0.5f,  0.5f, 0.0f,  // top right
        -0.5f,  0.5f, 0.0f   // top left
    };
    
    renderer.drawQuad(vertices);
}

} // namespace Examples

} // namespace GraphicsProgramming