//
//  ContentView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/09.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            ExercisesView()
                .tabItem {
                    Label("Exercices", systemImage: "dumbbell.fill")
                }
            
            SessionsView()
                .tabItem {
                    Label("Sessions", systemImage: "timer")
                }
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "leaf")
                }
            
            DailiesView()
                .tabItem {
                    Label("Dailies", systemImage: "calendar")
                }
            
            ExportView()
                .tabItem {
                    Label("Data", systemImage:"chart.bar")
                }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
