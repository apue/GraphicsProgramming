# 如何添加新的OpenGL示例

## 架构概览

这个项目使用了配置文件驱动 + C++多态的架构，让添加新示例变得超级简单。

## 添加新示例的步骤

### 1. 创建JSON配置文件

在对应章节目录下创建JSON文件，例如 `Examples/chapter3/texture_mapping.json`:

```json
{
    "id": "chapter3_texture_mapping",
    "title": "纹理映射",
    "chapter": "第3章：纹理", 
    "description": "演示纹理加载和映射到3D模型",
    "orderIndex": 1,
    "cppClass": "TextureMappingExample"
}
```

### 2. 实现C++示例类

创建继承自`ExampleBase`的类：

```cpp
#include "ExampleBase.hpp"
#include <OpenGL/gl3.h>

class TextureMappingExample : public ExampleBase {
private:
    GLuint shaderProgram;
    GLuint VAO, VBO, texture;

public:
    void initialize() override {
        // 初始化着色器、顶点数据、纹理等
        std::cout << "Initializing Texture Mapping Example" << std::endl;
        
        // 创建着色器程序
        // 设置顶点数据
        // 加载纹理
    }
    
    void display() override {
        // 渲染逻辑
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        glUseProgram(shaderProgram);
        glBindVertexArray(VAO);
        glBindTexture(GL_TEXTURE_2D, texture);
        glDrawArrays(GL_TRIANGLES, 0, 6);
    }
    
    void cleanup() override {
        // 清理OpenGL资源
        glDeleteTextures(1, &texture);
        glDeleteVertexArrays(1, &VAO);
        glDeleteBuffers(1, &VBO);
        glDeleteProgram(shaderProgram);
    }
    
    std::string getName() const override {
        return "Texture Mapping Example";
    }
};

// 注册示例 - 这一行很重要！
REGISTER_EXAMPLE(TextureMappingExample);
```

### 3. 添加到编译系统

在 `ExampleRegistry.cpp` 文件末尾添加：

```cpp
// 在文件末尾添加新的示例类代码，或者include新的cpp文件
```

### 4. 编译和运行

1. 在Xcode中编译项目
2. 应用会自动扫描Examples文件夹
3. 新示例将出现在左侧导航栏中
4. 点击可以切换到对应的渲染效果

## 目录结构

```
Examples/
├── chapter1/
│   ├── triangle.json
│   └── triangle.cpp
├── chapter2/
│   ├── raster_shader.json
│   └── raster_shader.cpp
└── chapter3/
    ├── texture_mapping.json
    └── texture_mapping.cpp
```

## 重要提醒

1. **JSON文件中的`cppClass`必须与C++类名完全匹配**
2. **不要忘记在C++文件末尾使用`REGISTER_EXAMPLE(ClassName)`注册**
3. **确保在`ExampleRegistry.cpp`中包含新的实现代码**
4. **所有OpenGL资源都要在`cleanup()`中正确释放**

## 示例特性

- **自动资源管理**：切换示例时会自动调用cleanup()
- **错误处理**：编译/链接错误会输出到控制台
- **实时渲染**：每个示例都有独立的渲染循环
- **动态加载**：运行时动态创建示例实例

这个架构让你可以专注于OpenGL编程本身，而不用担心框架代码！