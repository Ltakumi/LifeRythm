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
    @ObservedObject var set: Set

    // Temporary state for editing
    @State private var periodStart: Date
    @State private var periodEnd: Date
    @State private var additional: String

    init(set: Set) {
        self.set = set
        _periodStart = State(initialValue: set.period_start ?? Date())
        _periodEnd = State(initialValue: set.period_end ?? Date())
        _additional = State(initialValue: set.additional ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
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
        }
    }

    private func saveChanges() {
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
