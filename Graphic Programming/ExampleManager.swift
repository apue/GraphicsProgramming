//
//  ExampleManager.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import Foundation

class ExampleManager: ObservableObject {
    @Published var examples: [ExampleMetadata] = []
    
    static let shared = ExampleManager()
    
    private init() {
        loadExamplesFromConfig()
    }
    
    func loadExamplesFromConfig() {
        var loadedExamples: [ExampleMetadata] = []
        
        // Get the main bundle
        guard let bundlePath = Bundle.main.resourcePath else {
            print("Failed to get bundle resource path")
            return
        }
        
        let examplesPath = bundlePath + "/Examples"
        
        // Function to recursively scan directories for JSON files
        func scanDirectory(_ path: String) {
            let fileManager = FileManager.default
            
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: path)
                
                for item in contents {
                    let fullPath = path + "/" + item
                    
                    var isDirectory: ObjCBool = false
                    if fileManager.fileExists(atPath: fullPath, isDirectory: &isDirectory) {
                        if isDirectory.boolValue {
                            // Recursively scan subdirectories
                            scanDirectory(fullPath)
                        } else if item.hasSuffix(".json") {
                            // Load JSON configuration file
                            loadExampleFromFile(fullPath)
                        }
                    }
                }
            } catch {
                print("Failed to scan directory \(path): \(error)")
            }
        }
        
        func loadExampleFromFile(_ filePath: String) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let metadata = try JSONDecoder().decode(ExampleMetadata.self, from: data)
                loadedExamples.append(metadata)
                print("Loaded example: \(metadata.title)")
            } catch {
                print("Failed to load example from \(filePath): \(error)")
            }
        }
        
        // Check if Examples directory exists
        if FileManager.default.fileExists(atPath: examplesPath) {
            scanDirectory(examplesPath)
        } else {
            print("Examples directory not found at: \(examplesPath)")
            // Fallback to hardcoded examples for now
            loadHardcodedExamples()
            return
        }
        
        // Sort examples by chapter and order index
        loadedExamples.sort { example1, example2 in
            if example1.chapter != example2.chapter {
                return example1.chapter < example2.chapter
            }
            return example1.orderIndex < example2.orderIndex
        }
        
        DispatchQueue.main.async {
            self.examples = loadedExamples
        }
    }
    
    private func loadHardcodedExamples() {
        // Fallback hardcoded examples
        let hardcodedExamples = [
            ExampleMetadata(
                id: "chapter1_triangle",
                title: "基础三角形",
                chapter: "第1章：基础渲染",
                description: "绘制一个简单的三角形，演示最基础的OpenGL渲染流程",
                orderIndex: 1,
                cppClass: "TriangleExample"
            ),
            ExampleMetadata(
                id: "chapter2_raster_shader",
                title: "彩色光栅着色器",
                chapter: "第2章：着色器基础",
                description: "演示顶点颜色插值和片段着色器的基础用法",
                orderIndex: 1,
                cppClass: "RasterShaderExample"
            )
        ]
        
        DispatchQueue.main.async {
            self.examples = hardcodedExamples
        }
    }
    
    func getGroupedExamples() -> [String: [ExampleMetadata]] {
        return Dictionary(grouping: examples) { $0.chapter }
    }
    
    func createCppExample(_ metadata: ExampleMetadata) -> OpaquePointer? {
        return createExampleByClassName(metadata.cppClass)
    }
}