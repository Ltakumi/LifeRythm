//
//  EditSetView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/22.
//

import SwiftUI

struct EditSetView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var set: ClimbSet

    // Temporary state for editing
    @State private var periodStart: Date
    @State private var periodEnd: Date
    @State private var additional: String
    @State private var name: String

    init(set: ClimbSet) {
        self.set = set
        _periodStart = State(initialValue: set.period_start ?? Date())
        _periodEnd = State(initialValue: set.period_end ?? Date())
        _additional = State(initialValue: set.additional ?? "")
        _name = State(initialValue: set.name ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header : Text("Name")) {
                    TextField("Name", text: $name)
                }
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $periodStart, displayedComponents: .date)
                    DatePicker("End Date", selection: $periodEnd, displayedComponents: .date)
                }

                Section(header: Text("Additional Information")) {
                    TextField("Additional Information", text: $additional)
                }

                Section {
                    Button("Save Changes") {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Edit Set")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveChanges() {
        set.name = name
        set.period_start = periodStart
        set.period_end = periodEnd
        set.additional = additional

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error saving context: \(error)")
        }
    }
}

//#Preview {
//    EditSetView()
//}
