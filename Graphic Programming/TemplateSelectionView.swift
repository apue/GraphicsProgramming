//
//  TemplateSelectionView.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import SwiftUI

struct TemplateSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedTemplate: ExampleTemplate?
    @State private var customTitle = ""
    @State private var customChapter = ""
    
    var body: some View {
        VStack {
            Text("选择模板")
                .font(.title)
                .padding()
            
            List(ExampleTemplate.templates) { template in
                VStack(alignment: .leading, spacing: 8) {
                    Text(template.title)
                        .font(.headline)
                    Text(template.chapter)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(template.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedTemplate?.id == template.id ? Color.accentColor.opacity(0.1) : Color.clear)
                )
                .onTapGesture {
                    selectedTemplate = template
                    customTitle = template.title
                    customChapter = template.chapter
                }
            }
            
            if selectedTemplate != nil {
                Form {
                    TextField("标题", text: $customTitle)
                    TextField("章节", text: $customChapter)
                }
                .padding()
            }
            
            HStack {
                Button("取消") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("使用模板创建") {
                    if let template = selectedTemplate {
                        let example = TemplateManager.createExampleFromTemplate(
                            template,
                            title: customTitle,
                            chapter: customChapter
                        )
                        modelContext.insert(example)
                        try? modelContext.save()
                        dismiss()
                    }
                }
                .keyboardShortcut(.defaultAction)
                .disabled(selectedTemplate == nil || customTitle.isEmpty || customChapter.isEmpty)
            }
            .padding()
        }
        .frame(width: 500, height: 600)
    }
}