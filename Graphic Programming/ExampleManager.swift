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
        
        // Function to load JSON files directly from Resources directory
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
        
        // Scan Resources directory for JSON files (flat structure due to Xcode build system)
        let fileManager = FileManager.default
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: bundlePath)
            
            for item in contents {
                if item.hasSuffix(".json") {
                    let fullPath = bundlePath + "/" + item
                    loadExampleFromFile(fullPath)
                }
            }
        } catch {
            print("Failed to scan bundle resources: \(error)")
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
    
    
    func getGroupedExamples() -> [String: [ExampleMetadata]] {
        return Dictionary(grouping: examples) { $0.chapter }
    }
    
    func createCppExample(_ metadata: ExampleMetadata) -> OpaquePointer? {
        return createExampleByClassName(metadata.cppClass)
    }
}