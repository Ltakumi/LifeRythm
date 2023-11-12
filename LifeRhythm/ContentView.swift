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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Location>
    
    var body: some View {
        TabView {
            LocationsView()
                .tabItem {
                    Label("Setup", systemImage: "list.dash")
                }
            
            ClimbSessionsView()
                .tabItem {
                    Label("Session", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
