//
//  BoulderView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/12.
//

import SwiftUI

struct ClimbView: View {
    let climb: Climb
    @State private var showingEditClimbView = false

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Grade:")
                    Spacer()
                    Text(climb.grade ?? "Unknown")
                }
                HStack {
                    Text("Name:")
                    Spacer()
                    Text(climb.name ?? "Unknown")
                }
                HStack {
                    Text("Tags:")
                    Spacer()
                    Text(climb.tags ?? "None")
                }
            }
        }
        .navigationTitle("Boulder Details")
        .navigationBarItems(trailing: Button(action: {
            showingEditClimbView = true
        }) {
            Image(systemName: "pencil")
        })
        .sheet(isPresented: $showingEditClimbView) {
            EditClimbView(climb: climb)
        }
    }
}

struct ClimbView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = PersistenceController.preview.container.viewContext
        
        let location = Location(context: context)
        location.name = "Noborock"
        location.address = "Shibuya"
        location.locationType = "Gym"
        location.additional = "Additional description"
        
        let set = ClimbSet(context: context)
        set.period_start = Date()
        set.period_end = Calendar.current.date(byAdding: .month, value: 1, to: set.period_start!)
        set.additional = "Additional Info for Location"
        location.addToContainsSet(set)
        
        let climb = Climb(context: context)
        climb.name = "yellow lion"
        climb.grade = "1 kyu"
        climb.inSet = set
        
        return ClimbView(climb: climb).environment(\.managedObjectContext, context)
    }
}
