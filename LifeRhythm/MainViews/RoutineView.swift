//
//  DailiesView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/13.
//

import SwiftUI
import CoreData

struct RoutineView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SetupTasksView()) {
                    Text("Setup Tasks")
                }
                NavigationLink(destination: LogTasksView()) {
                    Text("Log Tasks")
                }
            }
            .navigationTitle("Routine")
        }
    }
}

struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return RoutineView()
            .environment(\.managedObjectContext, context)
    }
}
