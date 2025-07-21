//
//  ContentView.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var exampleManager = ExampleManager.shared
    @State private var selectedExample: ExampleMetadata?
    
    var body: some View {
        NavigationSplitView {
            ExampleListView(selectedExample: $selectedExample)
        } detail: {
            detailView
        }
        .onAppear {
            // Load examples from configuration files
            exampleManager.loadExamplesFromConfig()
        }
    }
    
    @ViewBuilder
    private var detailView: some View {
        if let example = selectedExample {
            ExampleDetailView(example: example)
        } else {
            VStack {
                Image(systemName: "cube.transparent")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                Text("选择一个OpenGL示例开始学习")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}