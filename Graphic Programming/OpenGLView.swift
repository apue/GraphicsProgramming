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
    private var renderCallback: (() -> Void)?
    
    convenience init(renderCallback: @escaping () -> Void) {
        self.init()
        self.renderCallback = renderCallback
    }
    
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
            
            // 设置OpenGL视口
            glViewport(0, 0, GLsizei(glView.bounds.width), GLsizei(glView.bounds.height))
            
            // 启用深度测试
            glEnable(GLenum(GL_DEPTH_TEST))
            
            // 设置清屏颜色为深灰色
            glClearColor(0.2, 0.2, 0.2, 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置定时器进行渲染
        Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            self.render()
        }
    }
    
    private func render() {
        guard let context = glView.openGLContext else { return }
        
        context.makeCurrentContext()
        
        // 清除颜色缓冲区和深度缓冲区
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        // 执行自定义渲染
        renderCallback?()
        
        // 交换缓冲区
        glView.openGLContext?.flushBuffer()
    }
    
    func updateRenderCallback(_ callback: @escaping () -> Void) {
        self.renderCallback = callback
    }
}

struct OpenGLView: NSViewControllerRepresentable {
    var renderCallback: () -> Void
    
    func makeNSViewController(context: Context) -> OpenGLViewController {
        return OpenGLViewController(renderCallback: renderCallback)
    }
    
    func updateNSViewController(_ nsViewController: OpenGLViewController, context: Context) {
        nsViewController.updateRenderCallback(renderCallback)
    }
}