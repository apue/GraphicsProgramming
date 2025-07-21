//
//  ExampleTemplates.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import Foundation

struct ExampleTemplate: Identifiable {
    let id = UUID()
    let title: String
    let chapter: String
    let description: String
    let sourceCode: String
    let templateCode: String
    
    static let templates: [ExampleTemplate] = [
        triangleTemplate,
        coloredTriangleTemplate,
        cubeTemplate,
        textureTemplate,
        lightingTemplate
    ]
    
    static let triangleTemplate = ExampleTemplate(
        title: "基础三角形",
        chapter: "第1章：基础渲染",
        description: "OpenGL中最基础的三角形渲染示例",
        sourceCode: """
// 顶点着色器
#version 330 core
layout (location = 0) in vec3 aPos;

void main()
{
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}

// 片段着色器
#version 330 core
out vec4 FragColor;

void main()
{
    FragColor = vec4(1.0, 0.5, 0.2, 1.0);
}

// C++代码
// 顶点数据
float vertices[] = {
    -0.5f, -0.5f, 0.0f,
     0.5f, -0.5f, 0.0f,
     0.0f,  0.5f, 0.0f
};

// 初始化代码...
""",
        templateCode: """
// 这是一个基础三角形模板
// 你可以修改顶点坐标、颜色等参数

// 顶点数据
float vertices[] = {
    -0.5f, -0.5f, 0.0f,  // 左下角
     0.5f, -0.5f, 0.0f,  // 右下角
     0.0f,  0.5f, 0.0f   // 顶部
};

// 渲染循环
while (!glfwWindowShouldClose(window)) {
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 使用着色器程序
    glUseProgram(shaderProgram);
    
    // 绑定VAO并绘制
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    glfwSwapBuffers(window);
    glfwPollEvents();
}
"""
    )
    
    static let coloredTriangleTemplate = ExampleTemplate(
        title: "彩色三角形",
        chapter: "第1章：基础渲染",
        description: "使用顶点颜色的三角形渲染",
        sourceCode: """
// 顶点着色器
#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

out vec3 vertexColor;

void main()
{
    gl_Position = vec4(aPos, 1.0);
    vertexColor = aColor;
}

// 片段着色器
#version 330 core
in vec3 vertexColor;
out vec4 FragColor;

void main()
{
    FragColor = vec4(vertexColor, 1.0);
}

// C++代码
float vertices[] = {
    // 位置          // 颜色
     0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,
     0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f
};
""",
        templateCode: """
// 彩色三角形模板
// 每个顶点都有对应的颜色

// 顶点数据格式：位置(x,y,z) + 颜色(r,g,b)
float vertices[] = {
     0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,  // 右下，红色
    -0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,  // 左下，绿色
     0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f   // 顶部，蓝色
};

// 设置顶点属性指针
// 位置属性
glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
glEnableVertexAttribArray(0);

// 颜色属性
glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
glEnableVertexAttribArray(1);
"""
    )
    
    static let cubeTemplate = ExampleTemplate(
        title: "3D立方体",
        chapter: "第2章：3D变换",
        description: "使用矩阵变换绘制旋转的3D立方体",
        sourceCode: """
// 顶点着色器
#version 330 core
layout (location = 0) in vec3 aPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
    gl_Position = projection * view * model * vec4(aPos, 1.0);
}

// 片段着色器
#version 330 core
out vec4 FragColor;

void main()
{
    FragColor = vec4(0.2, 0.5, 0.8, 1.0);
}
""",
        templateCode: """
// 3D立方体模板
// 包含模型、视图、投影矩阵

// 立方体顶点数据
float vertices[] = {
    // 前面
    -0.5f, -0.5f,  0.5f,
     0.5f, -0.5f,  0.5f,
     0.5f,  0.5f,  0.5f,
    -0.5f,  0.5f,  0.5f,
    // 其他面...
};

// 矩阵设置
glm::mat4 model = glm::mat4(1.0f);
glm::mat4 view = glm::mat4(1.0f);
glm::mat4 projection = glm::mat4(1.0f);

model = glm::rotate(model, (float)glfwGetTime() * glm::radians(50.0f), glm::vec3(0.5f, 1.0f, 0.0f));
view  = glm::translate(view, glm::vec3(0.0f, 0.0f, -3.0f));
projection = glm::perspective(glm::radians(45.0f), 800.0f / 600.0f, 0.1f, 100.0f);

// 传递矩阵到着色器
unsigned int modelLoc = glGetUniformLocation(shaderProgram, "model");
glUniformMatrix4fv(modelLoc, 1, GL_FALSE, glm::value_ptr(model));
"""
    )
    
    static let textureTemplate = ExampleTemplate(
        title: "纹理映射",
        chapter: "第3章：纹理",
        description: "加载并应用纹理到几何体",
        sourceCode: """
// 顶点着色器
#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoord;

out vec2 TexCoord;

void main()
{
    gl_Position = vec4(aPos, 1.0);
    TexCoord = aTexCoord;
}

// 片段着色器
#version 330 core
in vec2 TexCoord;
out vec4 FragColor;

uniform sampler2D texture1;

void main()
{
    FragColor = texture(texture1, TexCoord);
}
""",
        templateCode: """
// 纹理映射模板
// 加载图片作为纹理并应用到几何体

// 纹理坐标
float vertices[] = {
    // 位置         // 纹理坐标
     0.5f,  0.5f, 0.0f,  1.0f, 1.0f,
     0.5f, -0.5f, 0.0f,  1.0f, 0.0f,
    -0.5f, -0.5f, 0.0f,  0.0f, 0.0f,
    -0.5f,  0.5f, 0.0f,  0.0f, 1.0f
};

// 加载纹理
unsigned int texture;
glGenTextures(1, &texture);
glBindTexture(GL_TEXTURE_2D, texture);

// 设置纹理参数
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

// 加载图片数据...
"""
    )
    
    static let lightingTemplate = ExampleTemplate(
        title: "光照模型",
        chapter: "第4章：光照",
        description: "实现基础Phong光照模型",
        sourceCode: """
// 顶点着色器
#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;

out vec3 FragPos;
out vec3 Normal;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
    FragPos = vec3(model * vec4(aPos, 1.0));
    Normal = mat3(transpose(inverse(model))) * aNormal;
    
    gl_Position = projection * view * vec4(FragPos, 1.0);
}

// 片段着色器
#version 330 core
out vec4 FragColor;

in vec3 FragPos;
in vec3 Normal;

uniform vec3 lightPos;
uniform vec3 viewPos;
uniform vec3 lightColor;
uniform vec3 objectColor;

void main()
{
    // 环境光
    float ambientStrength = 0.1;
    vec3 ambient = ambientStrength * lightColor;
    
    // 漫反射
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPos - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * lightColor;
    
    // 镜面反射
    float specularStrength = 0.5;
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    vec3 specular = specularStrength * spec * lightColor;
    
    vec3 result = (ambient + diffuse + specular) * objectColor;
    FragColor = vec4(result, 1.0);
}
""",
        templateCode: """
// 光照模板
// 实现Phong光照模型

// 光照参数设置
vec3 lightPos(1.2f, 1.0f, 2.0f);
vec3 lightColor(1.0f, 1.0f, 1.0f);
vec3 objectColor(1.0f, 0.5f, 0.31f);

// 传递光照参数到着色器
unsigned int lightPosLoc = glGetUniformLocation(shaderProgram, "lightPos");
glUniform3f(lightPosLoc, lightPos.x, lightPos.y, lightPos.z);

unsigned int viewPosLoc = glGetUniformLocation(shaderProgram, "viewPos");
glUniform3f(viewPosLoc, cameraPos.x, cameraPos.y, cameraPos.z);

unsigned int lightColorLoc = glGetUniformLocation(shaderProgram, "lightColor");
glUniform3f(lightColorLoc, lightColor.x, lightColor.y, lightColor.z);

unsigned int objectColorLoc = glGetUniformLocation(shaderProgram, "objectColor");
glUniform3f(objectColorLoc, objectColor.x, objectColor.y, objectColor.z);
"""
    )
}

// 模板管理器
class TemplateManager {
    static func createExampleFromTemplate(_ template: ExampleTemplate, title: String, chapter: String) -> OpenGLExample {
        return OpenGLExample(
            title: title,
            chapter: chapter,
            description: template.description,
            sourceCode: template.sourceCode
        )
    }
    
    static func getTemplate(named name: String) -> ExampleTemplate? {
        return ExampleTemplate.templates.first { $0.title == name }
    }
}