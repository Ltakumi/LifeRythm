//
//  AddClimbSessionView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/12.
//

import SwiftUI

struct AddClimbSessionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(
        entity: Location.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.name, ascending: true)])
    private var locations: FetchedResults<Location>

    @State private var selectedLocationIndex: Int = 0
    @State private var selectedSetIndex: Int = 0

    var sets: [Set] {
        let setsArray = locations[selectedLocationIndex].containsSet?.allObjects as? [Set] ?? []
        return setsArray.sorted { $0.displayName() < $1.displayName() }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Location", selection: $selectedLocationIndex) {
                        ForEach(0 ..< locations.count, id: \.self) {
                            Text(self.locations[$0].name ?? "Unknown Location")
                        }
                    }

                    Picker("Set", selection: $selectedSetIndex) {
                        ForEach(0 ..< sets.count, id: \.self) {
                            Text(self.sets[$0].displayName())
                        }
                    }
                }

                Button("Add") {
                    addSession()
                    presentationMode.wrappedValue.dismiss()
                }

                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitle("Add Climb Session", displayMode: .inline)
        }
    }

    private func addSession() {
        let newSession = Session(context: viewContext)
        newSession.id = UUID()
        newSession.start = Date() // Set the start date as current date, or use a DatePicker to let user choose
        newSession.end = Calendar.current.date(byAdding: .hour, value: 1, to: newSession.start!) // Example end date
        newSession.inSet = sets[selectedSetIndex]

        do {
            try viewContext.save()
        } catch {
            print("Error saving session: \(error)")
        }
    }
}


#Preview {
    AddClimbSessionView()
}
