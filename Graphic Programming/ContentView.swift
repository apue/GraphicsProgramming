//
//  ContentView.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var examples: [OpenGLExample]
    
    @State private var selectedExample: OpenGLExample?
    @State private var showAddExample = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailView
        }
        .sheet(isPresented: $showAddExample) {
            AddExampleView()
        }
        .onAppear {
            // 如果没有任何示例，加载默认示例
            if examples.isEmpty {
                loadDefaultExamples()
            }
        }
    }
    
    private var sidebar: some View {
        List(selection: $selectedExample) {
            ForEach(groupedExamples.keys.sorted(), id: \.self) { chapter in
                Section(header: Text(chapter).font(.headline)) {
                    ForEach(groupedExamples[chapter] ?? []) { example in
                        NavigationLink(value: example) {
                            VStack(alignment: .leading) {
                                Text(example.title)
                                    .font(.body)
                                Text(example.exampleDescription)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("OpenGL学习")
        .toolbar {
            ToolbarItem {
                Button(action: { showAddExample = true }) {
                    Label("添加示例", systemImage: "plus")
                }
            }
            ToolbarItem {
                Button(action: loadDefaultExamples) {
                    Label("加载默认示例", systemImage: "arrow.clockwise")
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    private var detailView: some View {
        if let example = selectedExample {
            return AnyView(ExampleDetailView(example: example))
        } else {
            return AnyView(
                VStack {
                    Image(systemName: "cube.transparent")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("选择一个OpenGL示例开始学习")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            )
        }
    }
    
    private var groupedExamples: [String: [OpenGLExample]] {
        let filtered = examples.filter { example in
            if searchText.isEmpty {
                return true
            }
            return example.title.localizedCaseInsensitiveContains(searchText) ||
                   example.exampleDescription.localizedCaseInsensitiveContains(searchText)
        }
        
        let sorted = filtered.sorted { $0.orderIndex < $1.orderIndex }
        return Dictionary(grouping: sorted) { $0.chapter }
    }
    
    private func loadDefaultExamples() {
        let defaultExamples = [
            OpenGLExample(
                title: "三角形",
                chapter: "第1章：基础渲染",
                description: "绘制一个简单的三角形",
                sourceCode: """
                // 顶点着色器
                #version 330 core
                layout (location = 0) in vec3 aPos;
                void main() {
                    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
                }
                
                // 片段着色器
                #version 330 core
                out vec4 FragColor;
                void main() {
                    FragColor = vec4(1.0, 0.5, 0.2, 1.0);
                }
                """,
                orderIndex: 0
            ),
            OpenGLExample(
                title: "彩色三角形",
                chapter: "第1章：基础渲染",
                description: "使用顶点颜色的三角形",
                sourceCode: """
                // 顶点着色器
                #version 330 core
                layout (location = 0) in vec3 aPos;
                layout (location = 1) in vec3 aColor;
                out vec3 vertexColor;
                void main() {
                    gl_Position = vec4(aPos, 1.0);
                    vertexColor = aColor;
                }
                
                // 片段着色器
                #version 330 core
                in vec3 vertexColor;
                out vec4 FragColor;
                void main() {
                    FragColor = vec4(vertexColor, 1.0);
                }
                """,
                orderIndex: 1
            ),
            OpenGLExample(
                title: "3D立方体",
                chapter: "第2章：3D变换",
                description: "使用矩阵变换绘制3D立方体",
                sourceCode: """
                // 示例代码将在这里添加
                """,
                orderIndex: 2
            ),
            OpenGLExample(
                title: "纹理映射",
                chapter: "第3章：纹理",
                description: "加载和应用纹理",
                sourceCode: """
                // 示例代码将在这里添加
                """,
                orderIndex: 3
            ),
            OpenGLExample(
                title: "光照模型",
                chapter: "第4章：光照",
                description: "实现基础光照模型",
                sourceCode: """
                // 示例代码将在这里添加
                """,
                orderIndex: 4
            )
        ]
        
        // 清除现有示例并添加默认示例
        examples.forEach { modelContext.delete($0) }
        defaultExamples.forEach { modelContext.insert($0) }
        
        try? modelContext.save()
    }
}

struct ExampleDetailView: View {
    let example: OpenGLExample
    @State private var showSourceCode = false
    
    var body: some View {
        VStack {
            HStack {
                Text(example.title)
                    .font(.largeTitle)
                Spacer()
                Button("查看源码") {
                    showSourceCode = true
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
            Divider()
            
            ZStack {
                OpenGLView {
                    renderExample()
                }
                .border(Color.gray)
                .padding()
                .onAppear {
                    OpenGLExampleManager.shared.loadExample(example)
                }
                .onDisappear {
                    OpenGLExampleManager.shared.cleanup()
                }
                
                if showSourceCode {
                    SourceCodeView(code: example.sourceCode) {
                        showSourceCode = false
                    }
                }
            }
            
            Text(example.exampleDescription)
                .font(.body)
                .padding()
        }
        .navigationTitle(example.title)
    }
    
    private func renderExample() {
        OpenGLExampleManager.shared.renderCurrentExample()
    }
}

struct SourceCodeView: View {
    let code: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("源代码")
                    .font(.headline)
                Spacer()
                Button("关闭") {
                    onDismiss()
                }
            }
            .padding()
            
            ScrollView {
                Text(code)
                    .font(.system(.body, design: .monospaced))
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

struct AddExampleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var showTemplateSelection = false
    @State private var title = ""
    @State private var chapter = ""
    @State private var description = ""
    @State private var sourceCode = ""
    
    var body: some View {
        VStack {
            Text("添加新示例")
                .font(.title)
                .padding()
            
            Form {
                TextField("标题", text: $title)
                TextField("章节", text: $chapter)
                TextField("描述", text: $description)
                
                VStack(alignment: .leading) {
                    Text("源代码")
                        .font(.headline)
                    HStack {
                        Button("使用模板") {
                            showTemplateSelection = true
                        }
                        .buttonStyle(.bordered)
                        Spacer()
                    }
                    TextEditor(text: $sourceCode)
                        .font(.system(.body, design: .monospaced))
                        .frame(minHeight: 200)
                        .border(Color.gray.opacity(0.2))
                }
            }
            .padding()
            
            HStack {
                Button("取消") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("添加") {
                    let example = OpenGLExample(
                        title: title,
                        chapter: chapter,
                        description: description,
                        sourceCode: sourceCode
                    )
                    modelContext.insert(example)
                    try? modelContext.save()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(title.isEmpty || chapter.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(width: 500, height: 400)
        .sheet(isPresented: $showTemplateSelection) {
            TemplateSelectionView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: OpenGLExample.self, inMemory: true)
}
