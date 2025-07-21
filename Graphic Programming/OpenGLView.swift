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
    private var cppRenderer: OpaquePointer?
    
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
            
            // Initialize C++ renderer
            cppRenderer = createRenderer()
            initializeRenderer(cppRenderer)
            
            // 设置OpenGL视口
            resizeViewport(cppRenderer, Int32(glView.bounds.width), Int32(glView.bounds.height))
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
        
        // Use C++ renderer
        if let renderer = cppRenderer {
            renderFrame(renderer)
        }
        
        // 执行自定义渲染
        renderCallback?()
        
        // 交换缓冲区
        glView.openGLContext?.flushBuffer()
    }
    
    func updateRenderCallback(_ callback: @escaping () -> Void) {
        self.renderCallback = callback
    }
    
    deinit {
        if let renderer = cppRenderer {
            destroyRenderer(renderer)
        }
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