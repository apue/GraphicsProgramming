//
//  ExampleMetadata.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import Foundation

struct ExampleMetadata: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let chapter: String
    let description: String
    let orderIndex: Int
    let cppClass: String
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ExampleMetadata, rhs: ExampleMetadata) -> Bool {
        return lhs.id == rhs.id
    }
}