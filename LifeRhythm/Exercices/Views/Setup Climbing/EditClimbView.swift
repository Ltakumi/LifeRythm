//
//  EditClimbView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/22.
//

import SwiftUI

struct EditClimbView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var climb: Climb

    // Temporary state for editing
    @State private var grade: String
    @State private var name: String
    @State private var tags: String

    init(climb: Climb) {
        self.climb = climb
        _grade = State(initialValue: climb.grade ?? "")
        _name = State(initialValue: climb.name ?? "")
        _tags = State(initialValue: climb.tags ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Climb Details")) {
                    TextField("Grade", text: $grade)
                    TextField("Name", text: $name)
                    TextField("Tags", text: $tags)
                }

                Section {
                    Button("Save Changes") {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Edit Climb")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveChanges() {
        climb.grade = grade
        climb.name = name
        climb.tags = tags

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error saving context: \(error)")
        }
    }
}


//#Preview {
//    EditClimbView()
//}
