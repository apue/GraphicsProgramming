#ifndef GraphicsProgramming_hpp
#define GraphicsProgramming_hpp

#include <OpenGL/gl3.h>
#include <vector>
#include <memory>
#include <string>

namespace GraphicsProgramming {

class Shader {
public:
    Shader(const std::string& vertexSource, const std::string& fragmentSource);
    ~Shader();
    
    void use() const;
    void setUniform(const std::string& name, float value) const;
    void setUniform(const std::string& name, int value) const;
    void setUniform(const std::string& name, const float* matrix4x4) const;
    
private:
    unsigned int programID;
    unsigned int compileShader(const std::string& source, GLenum type);
    void linkProgram(unsigned int vertexShader, unsigned int fragmentShader);
};

class Mesh {
public:
    Mesh(const std::vector<float>& vertices, const std::vector<unsigned int>& indices = {});
    ~Mesh();
    
    void draw() const;
    
private:
    unsigned int VAO, VBO, EBO;
    bool hasIndices;
    size_t vertexCount;
    size_t indexCount;
};

class Renderer {
public:
    Renderer();
    ~Renderer();
    
    void initialize();
    void clear(float r = 0.2f, float g = 0.2f, float b = 0.2f, float a = 1.0f);
    void setViewport(int width, int height);
    
    // Basic shapes
    void drawTriangle(const std::vector<float>& vertices);
    void drawQuad(const std::vector<float>& vertices);
    
    // Advanced rendering
    void drawMesh(const Mesh& mesh, const Shader& shader);
    
private:
    std::unique_ptr<Shader> basicShader;
    void initializeBasicShader();
};

// Example programs matching the book structure
namespace Examples {
    void drawBasicTriangle(Renderer& renderer);
    void drawColoredTriangle(Renderer& renderer);
    void drawTexturedQuad(Renderer& renderer);
}

} // namespace GraphicsProgramming

#endif /* GraphicsProgramming_hpp */