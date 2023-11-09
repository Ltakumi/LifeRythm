//
//  LifeRhythmApp.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/09.
//

import SwiftUI

@main
struct LifeRhythmApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
