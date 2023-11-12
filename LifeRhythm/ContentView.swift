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
        LocationsView()
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
