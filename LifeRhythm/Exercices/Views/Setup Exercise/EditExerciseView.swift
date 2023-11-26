//
//  SwiftUIView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/26.
//

import SwiftUI

struct EditExerciseView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var exercise: Exercise
    
    // Temporary state for editing
    @State private var name: String
    @State private var details: String

    init(exercise: Exercise) {
        self.exercise = exercise
        _details = State(initialValue: exercise.detail ?? "")
        _name = State(initialValue: exercise.name ?? "")
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header : Text("Name")) {
                    TextField("Name", text: $name)
                }
                Section(header : Text("Details")) {
                    TextField("Details", text: $details)
                }
                Section {
                    Button("Save Changes") {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Edit Exercise")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveChanges() {
        exercise.name = name
        exercise.detail = details

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error saving context: \(error)")
        }
    }
}

