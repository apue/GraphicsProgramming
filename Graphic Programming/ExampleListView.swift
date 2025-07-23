//
//  ExampleListView.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import SwiftUI

struct ExampleListView: View {
    @ObservedObject var exampleManager = ExampleManager.shared
    @Binding var selectedExample: ExampleMetadata?
    @State private var searchText = ""
    
    var body: some View {
        List(selection: $selectedExample) {
            ForEach(groupedExamples.keys.sorted(), id: \.self) { chapter in
                Section(header: Text(chapter).font(.headline)) {
                    ForEach(groupedExamples[chapter] ?? []) { example in
                        NavigationLink(value: example) {
                            VStack(alignment: .leading) {
                                Text(example.title)
                                    .font(.body)
                                Text(example.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("OpenGL学习")
        .searchable(text: $searchText)
    }
    
    private var groupedExamples: [String: [ExampleMetadata]] {
        let filtered = exampleManager.examples.filter { example in
            if searchText.isEmpty {
                return true
            }
            return example.title.localizedCaseInsensitiveContains(searchText) ||
                   example.description.localizedCaseInsensitiveContains(searchText)
        }
        
        let sorted = filtered.sorted { $0.orderIndex < $1.orderIndex }
        return Dictionary(grouping: sorted) { $0.chapter }
    }
}