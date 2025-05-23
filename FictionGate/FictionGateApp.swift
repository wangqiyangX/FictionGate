//
// FictionGateApp.swift.swift
// FictionGate
//
// Copyright © 2025 wangqiyangX.
// All Rights Reserved.
//


import SwiftUI
import SwiftData

@main
struct FictionGateApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            ItemListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
