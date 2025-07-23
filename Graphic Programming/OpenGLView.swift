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
    private var currentExample: OpaquePointer?
    private var currentExampleMetadata: ExampleMetadata?
    
    override func loadView() {
        let pixelFormatAttributes: [NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAColorSize), 24,
            UInt32(NSOpenGLPFAAlphaSize), 8,
            UInt32(NSOpenGLPFADepthSize), 24,
            UInt32(NSOpenGLPFAStencilSize), 8,
            UInt32(NSOpenGLPFADoubleBuffer),
            UInt32(NSOpenGLPFAOpenGLProfile), UInt32(NSOpenGLProfileVersion4_1Core),
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
            print("OpenGL context created successfully")
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
        if let example = currentExample {
            if let context = glView.openGLContext {
                context.makeCurrentContext()
                resizeExample(example, Int32(glView.bounds.width), Int32(glView.bounds.height))
            }
        }
    }
    
    private func render() {
        guard let context = glView.openGLContext else { 
            print("OpenGL Error: No OpenGL context available")
            return 
        }
        
        context.makeCurrentContext()
        
        // Render current example if available
        if let example = currentExample {
            renderExample(example)
            checkOpenGLError("Example render")
        } else {
            // 默认清屏
            glClearColor(0.2, 0.3, 0.3, 1.0)
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
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
    
    func setExample(_ metadata: ExampleMetadata?) {
        // Clean up current example
        if let example = currentExample {
            destroyExample(example)
            currentExample = nil
        }
        
        // Set new example
        if let metadata = metadata {
            currentExample = ExampleManager.shared.createCppExample(metadata)
            currentExampleMetadata = metadata
            
            if let example = currentExample {
                if let context = glView.openGLContext {
                    context.makeCurrentContext()
                    initializeExample(example)
                    resizeExample(example, Int32(glView.bounds.width), Int32(glView.bounds.height))
                    print("Switched to example: \(metadata.title)")
                } else {
                    print("Failed to make OpenGL context current for example initialization")
                }
            } else {
                print("Failed to create example: \(metadata.title)")
            }
        } else {
            currentExampleMetadata = nil
        }
    }
    
    deinit {
        if let example = currentExample {
            destroyExample(example)
        }
    }
}

struct OpenGLView: NSViewControllerRepresentable {
    let exampleMetadata: ExampleMetadata?
    
    init(exampleMetadata: ExampleMetadata? = nil) {
        self.exampleMetadata = exampleMetadata
    }
    
    func makeNSViewController(context: Context) -> OpenGLViewController {
        let controller = OpenGLViewController()
        return controller
    }
    
    func updateNSViewController(_ nsViewController: OpenGLViewController, context: Context) {
        // Update example when metadata changes
        nsViewController.setExample(exampleMetadata)
    }
}
