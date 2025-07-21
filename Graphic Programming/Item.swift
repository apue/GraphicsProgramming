//
//  OpenGLExample.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import Foundation
import SwiftData

@Model
final class OpenGLExample {
    var id: UUID
    var title: String
    var chapter: String
    var exampleDescription: String
    var sourceCode: String
    var createdAt: Date
    var orderIndex: Int
    
    init(title: String, chapter: String, description: String, sourceCode: String = "", orderIndex: Int = 0) {
        self.id = UUID()
        self.title = title
        self.chapter = chapter
        self.exampleDescription = description
        self.sourceCode = sourceCode
        self.createdAt = Date()
        self.orderIndex = orderIndex
    }
}
