//
//  Graphic_ProgrammingApp.swift
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/21.
//

import SwiftUI
import SwiftData

@main
struct Graphic_ProgrammingApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            OpenGLExample.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
