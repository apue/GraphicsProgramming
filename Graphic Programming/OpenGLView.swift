//
//  OpenGLView.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import SwiftUI
import AppKit
import OpenGL
import OpenGL.GL3

final class OpenGLViewController: NSViewController {
    private var glView: NSOpenGLView!
    private var cppRenderer: OpaquePointer?
    
    override func loadView() {
        let pixelFormatAttributes: [NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAColorSize), 24,
            UInt32(NSOpenGLPFAAlphaSize), 8,
            UInt32(NSOpenGLPFADepthSize), 24,
            UInt32(NSOpenGLPFAStencilSize), 8,
            UInt32(NSOpenGLPFADoubleBuffer),
            0
        ]
        
        guard let pixelFormat = NSOpenGLPixelFormat(attributes: pixelFormatAttributes) else {
            fatalError("Failed to create OpenGL pixel format")
        }
        
        glView = NSOpenGLView(frame: NSRect(x: 0, y: 0, width: 800, height: 600), pixelFormat: pixelFormat)
        glView.autoresizingMask = [.width, .height]
        self.view = glView
        
        if let context = glView.openGLContext {
            context.makeCurrentContext()
            
            // Initialize C++ renderer
            cppRenderer = createRenderer()
            if let renderer = cppRenderer {
                initializeRenderer(renderer)
                checkOpenGLError("initializeRenderer")
                
                // 设置OpenGL视口
                resizeViewport(renderer, Int32(glView.bounds.width), Int32(glView.bounds.height))
                checkOpenGLError("resizeViewport")
                
                print("OpenGL Renderer initialized successfully")
            } else {
                print("Failed to create C++ renderer")
            }
        } else {
            print("Failed to create OpenGL context")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置定时器进行渲染
        Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            self.render()
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        // 当视图大小改变时更新视口
        if let renderer = cppRenderer {
            resizeViewport(renderer, Int32(glView.bounds.width), Int32(glView.bounds.height))
        }
    }
    
    private func render() {
        guard let context = glView.openGLContext else { 
            print("OpenGL Error: No OpenGL context available")
            return 
        }
        
        context.makeCurrentContext()
        
        // Use C++ renderer
        if let renderer = cppRenderer {
            renderFrame(renderer)
            checkOpenGLError("C++ renderFrame")
        } else {
            print("OpenGL Error: No C++ renderer available")
        }
        
        // 交换缓冲区
        glView.openGLContext?.flushBuffer()
    }
    
    private func checkOpenGLError(_ operation: String) {
        let error = glGetError()
        if error != GLenum(GL_NO_ERROR) {
            print("OpenGL Error in \(operation): \(error)")
        }
    }
    
    deinit {
        if let renderer = cppRenderer {
            destroyRenderer(renderer)
        }
    }
}

struct OpenGLView: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> OpenGLViewController {
        return OpenGLViewController()
    }
    
    func updateNSViewController(_ nsViewController: OpenGLViewController, context: Context) {
        // C++渲染器自动处理渲染，无需额外更新
    }
}