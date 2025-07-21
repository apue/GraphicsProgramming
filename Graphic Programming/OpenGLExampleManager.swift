//
//  OpenGLExampleManager.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import Foundation
import OpenGL.GL3

enum ExampleType: String, CaseIterable {
    case triangle = "三角形"
    case coloredTriangle = "彩色三角形"
    case cube = "3D立方体"
    case texture = "纹理映射"
    case lighting = "光照模型"
    case custom = "自定义"
}

protocol OpenGLExampleRenderer {
    func setup()
    func render()
    func cleanup()
}

class TriangleRenderer: OpenGLExampleRenderer {
    private var VAO: GLuint = 0
    private var VBO: GLuint = 0
    private var shaderProgram: GLuint = 0
    
    func setup() {
        // 顶点数据
        let vertices: [GLfloat] = [
            -0.5, -0.5, 0.0,
             0.5, -0.5, 0.0,
             0.0,  0.5, 0.0
        ]
        
        // 创建和绑定VAO
        glGenVertexArrays(1, &VAO)
        glBindVertexArray(VAO)
        
        // 创建和绑定VBO
        glGenBuffers(1, &VBO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertices.count * MemoryLayout<GLfloat>.size, vertices, GLenum(GL_STATIC_DRAW))
        
        // 设置顶点属性指针
        glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 3 * GLsizei(MemoryLayout<GLfloat>.size), nil)
        glEnableVertexAttribArray(0)
        
        // 解绑
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindVertexArray(0)
        
        // 创建着色器程序（简化版）
        setupShaders()
    }
    
    func render() {
        glUseProgram(shaderProgram)
        glBindVertexArray(VAO)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        glBindVertexArray(0)
    }
    
    func cleanup() {
        glDeleteVertexArrays(1, &VAO)
        glDeleteBuffers(1, &VBO)
        glDeleteProgram(shaderProgram)
    }
    
    private func setupShaders() {
        let vertexShaderSource = """
        #version 330 core
        layout (location = 0) in vec3 aPos;
        void main() {
            gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
        }
        """
        
        let fragmentShaderSource = """
        #version 330 core
        out vec4 FragColor;
        void main() {
            FragColor = vec4(1.0, 0.5, 0.2, 1.0);
        }
        """
        
        let vertexShader = compileShader(source: vertexShaderSource, type: GLenum(GL_VERTEX_SHADER))
        let fragmentShader = compileShader(source: fragmentShaderSource, type: GLenum(GL_FRAGMENT_SHADER))
        
        shaderProgram = glCreateProgram()
        glAttachShader(shaderProgram, vertexShader)
        glAttachShader(shaderProgram, fragmentShader)
        glLinkProgram(shaderProgram)
        
        // 清理着色器
        glDeleteShader(vertexShader)
        glDeleteShader(fragmentShader)
    }
    
    private func compileShader(source: String, type: GLenum) -> GLuint {
        let shader = glCreateShader(type)
        var sourceCString = strdup(source)
        defer { free(sourceCString) }
        
        let sources = [UnsafePointer<CChar>(sourceCString)]
        glShaderSource(shader, 1, sources, nil)
        glCompileShader(shader)
        
        // 检查编译状态
        var success: GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &success)
        
        if success == GLint(GL_FALSE) {
            var infoLog = [GLchar](repeating: 0, count: 512)
            glGetShaderInfoLog(shader, 512, nil, &infoLog)
            print("Shader compilation failed: \(String(cString: infoLog))")
        }
        
        return shader
    }
}

class OpenGLExampleManager {
    static let shared = OpenGLExampleManager()
    
    private var currentRenderer: OpenGLExampleRenderer?
    
    func loadExample(_ example: OpenGLExample) {
        // 清理前一个渲染器
        currentRenderer?.cleanup()
        
        // 根据示例类型创建对应的渲染器
        switch example.title {
        case "三角形":
            currentRenderer = TriangleRenderer()
        default:
            currentRenderer = TriangleRenderer() // 默认使用三角形
        }
        
        currentRenderer?.setup()
    }
    
    func renderCurrentExample() {
        currentRenderer?.render()
    }
    
    func cleanup() {
        currentRenderer?.cleanup()
        currentRenderer = nil
    }
}

// 工具函数
func checkOpenGLError() {
    var error = glGetError()
    if error != GLenum(GL_NO_ERROR) {
        print("OpenGL Error: \(error)")
    }
}