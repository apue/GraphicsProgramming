# OpenGL学习框架 - 零配置版

一个极简的OpenGL学习框架，专为《Computer Graphics Programming in OpenGL with C++》设计。

## 🚀 快速开始

1. **克隆项目**
```bash
git clone [项目地址]
cd "Graphic Programming"
```

2. **编译运行**
```bash
open "Graphic Programming.xcodeproj"
# 按 ⌘+R 运行
```

## 📝 添加新示例

只需**一步**：

1. **创建C++文件**：File → New → File → C++ File
2. **选择target**：勾选主App target
3. **写代码**：

```cpp
// Examples/chapterX_name.cpp
#include "ExampleBase.hpp"
#include <OpenGL/gl3.h>

class MyExample : public ExampleBase {
public:
    void initialize() override {
        // OpenGL初始化代码
    }
    
    void display() override {
        // 渲染代码
    }
    
    void cleanup() override {
        // 清理代码
    }
    
    std::string getName() const override {
        return "我的示例";
    }
};

// 只需这一行注册
AUTO_EXAMPLE(MyExample, "my_example", "示例标题", "第X章：章节名", "描述", 顺序号)
```

## 示例模板

### 基础模板
```cpp
class BasicExample : public ExampleBase {
    GLuint shader, VAO, VBO;
    
public:
    void initialize() override { /* 设置着色器、顶点数据 */ }
    void display() override { /* 渲染调用 */ }
    void cleanup() override { /* 清理资源 */ }
    std::string getName() const override { return "基础示例"; }
};

AUTO_EXAMPLE(BasicExample, "basic", "基础示例", "第1章：入门", "基础OpenGL示例", 1)
```

### 动画模板
```cpp
class AnimatedExample : public ExampleBase {
    float time = 0.0f;
    
public:
    void display() override {
        time += 0.016f; // ~60 FPS
        // 使用time变量创建动画
    }
};
```

## 项目结构

```
Graphic Programming/
├── Examples/                  # 示例代码
│   ├── chapter1_triangle.cpp
│   ├── chapter2_raster_shader.cpp
│   └── ...
├── C++Bridge/                # C++桥接层
│   ├── Include/              # 头文件
│   └── Renderers/            # 实现文件
└── Graphic Programming/      # Swift UI代码
```

## 文件命名约定

- 格式：`chapterX_name.cpp`
- 类名：首字母大写 + Example后缀
- ID：小写，用下划线分隔

## 开发工具

- **Xcode** - 开发环境
- **OpenGL 4.1** - 图形API
- **SwiftUI** - 界面框架

## 学习建议

1. **先运行** - 运行现有示例
2. **再修改** - 修改参数观察效果
3. **后创建** - 基于模板创建新示例
4. **深入理解** - 研究OpenGL概念

开始你的图形编程之旅吧！🚀