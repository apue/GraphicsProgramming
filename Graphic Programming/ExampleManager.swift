//
//  ExampleManager.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import Foundation

// C++接口声明
struct CExampleInfo {
    let id: UnsafePointer<CChar>?
    let title: UnsafePointer<CChar>?
    let chapter: UnsafePointer<CChar>?
    let description: UnsafePointer<CChar>?
    let order: Int32
}

// C++桥接函数
@_silgen_name("cppGetExampleCount")
func cppGetExampleCount() -> Int32

@_silgen_name("cppGetExampleInfo")
func cppGetExampleInfo(_ index: Int32, _ info: UnsafeMutablePointer<CExampleInfo>?)

@_silgen_name("createExampleById")
func createExampleById(_ id: UnsafePointer<CChar>?) -> OpaquePointer?

class ExampleManager: ObservableObject {
    @Published var examples: [ExampleMetadata] = []
    
    static let shared = ExampleManager()
    
    private init() {
        loadExamplesFromRegistry()
    }
    
    func loadExamplesFromRegistry() {
        let count = cppGetExampleCount()
        var loadedExamples: [ExampleMetadata] = []
        
        for i in 0..<Int(count) {
            var cInfo = CExampleInfo(id: nil, title: nil, chapter: nil, description: nil, order: 0)
            withUnsafeMutablePointer(to: &cInfo) { ptr in
                cppGetExampleInfo(Int32(i), ptr)
            }
            
            guard let idPtr = cInfo.id,
                  let titlePtr = cInfo.title,
                  let chapterPtr = cInfo.chapter,
                  let descPtr = cInfo.description else {
                continue
            }
            
            let id = String(cString: idPtr)
            let title = String(cString: titlePtr)
            let chapter = String(cString: chapterPtr)
            let description = String(cString: descPtr)
            let orderIndex = Int(cInfo.order)
            
            let metadata = ExampleMetadata(
                id: id,
                title: title,
                chapter: chapter,
                description: description,
                orderIndex: orderIndex,
                cppClass: id // 使用id作为类名
            )
            
            loadedExamples.append(metadata)
        }
        
        DispatchQueue.main.async {
            self.examples = loadedExamples
        }
    }
    
    func getGroupedExamples() -> [String: [ExampleMetadata]] {
        return Dictionary(grouping: examples) { $0.chapter }
    }
    
    func createCppExample(_ metadata: ExampleMetadata) -> OpaquePointer? {
        return metadata.id.withCString { idPtr in
            createExampleById(idPtr)
        }
    }
}