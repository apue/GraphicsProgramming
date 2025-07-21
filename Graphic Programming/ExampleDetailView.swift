//
//  ExampleDetailView.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import SwiftUI

struct ExampleDetailView: View {
    let example: ExampleMetadata
    @State private var showSourceCode = false
    
    var body: some View {
        VStack {
            HStack {
                Text(example.title)
                    .font(.largeTitle)
                Spacer()
                Button("查看描述") {
                    showSourceCode = true
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
            Divider()
            
            ZStack {
                OpenGLView(exampleMetadata: example)
                    .border(Color.gray)
                    .padding()
                
                if showSourceCode {
                    SourceCodeView(example: example) {
                        showSourceCode = false
                    }
                }
            }
            
            Text(example.description)
                .font(.body)
                .padding()
        }
        .navigationTitle(example.title)
    }
}

struct SourceCodeView: View {
    let example: ExampleMetadata
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("示例信息")
                    .font(.headline)
                Spacer()
                Button("关闭") {
                    onDismiss()
                }
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        Text("标题: \(example.title)")
                        Text("章节: \(example.chapter)")
                        Text("描述: \(example.description)")
                        Text("C++ 类名: \(example.cppClass)")
                        Text("顺序: \(example.orderIndex)")
                    }
                    .font(.system(.body, design: .monospaced))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black.opacity(0.1))
            }
        }
        .frame(width: 600, height: 400)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }
}