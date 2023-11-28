//
//  EditTaskView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/28.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var task: Task

    @State private var taskName: String
    @State private var taskLevels: [String]
    @State private var taskLevelShorts: [String]
    @State private var taskFrequency: String
    @State private var taskStartDate: Date
    @State private var taskEndDate: Date
    @State private var isEndDateSet: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(task: Task) {
        self.task = task
        self._taskName = State(initialValue: task.name ?? "")
        self._taskLevels = State(initialValue: task.levels?.components(separatedBy: ",") ?? [String]())
        self._taskLevelShorts = State(initialValue: task.levelshorts?.components(separatedBy: ",") ?? [String]())
        self._taskFrequency = State(initialValue: String(task.frequency))
        self._taskStartDate = State(initialValue: task.start_date ?? Date())
        self._taskEndDate = State(initialValue: task.end_date ?? Date())
        self._isEndDateSet = State(initialValue: task.end_date != nil)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $taskName)
                    DatePicker("Start Date", selection: $taskStartDate, displayedComponents: .date)
                    Toggle("Set End Date", isOn: $isEndDateSet)
                    if isEndDateSet {
                        DatePicker("End Date", selection: $taskEndDate, displayedComponents: .date)
                    }
                    TextField("Frequency", text: $taskFrequency)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Task Levels")) {
                    List {
                        ForEach(taskLevels.indices, id: \.self) { index in
                            TextField("Level \(index + 1)", text: Binding(
                                get: { self.taskLevels[index] },
                                set: { self.taskLevels[index] = $0 }
                            ))
                        }
                        .onDelete(perform: deleteLevel)

                        Button(action: addLevel) {
                            Text("Add Level")
                        }
                    }
                }
                
                Section(header: Text("Task Keywords")) {
                    List {
                        ForEach(taskLevelShorts.indices, id: \.self) { index in
                            TextField("Short desc \(index + 1)", text: Binding(
                                get: { self.taskLevelShorts[index] },
                                set: { self.taskLevelShorts[index] = $0 }
                            ))
                        }
                        .onDelete(perform: deleteShortDesc)

                        Button(action: addShortDesc) {
                            Text("Add level short desc")
                        }
                    }
                }

                Section(header: Text("Task Level Short Descriptions")) {
                    // Similar to AddTaskView
                }

                Button("Save Changes") {
                    if isInputValid() {
                        updateTask()
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Edit Task", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func addLevel() {
        taskLevels.append("")
    }

    func deleteLevel(at offsets: IndexSet) {
        taskLevels.remove(atOffsets: offsets)
    }
    
    func addShortDesc() {
        taskLevelShorts.append("")
    }

    func deleteShortDesc(at offsets: IndexSet) {
        taskLevelShorts.remove(atOffsets: offsets)
    }

    private func isInputValid() -> Bool {
        // Check if name is filled
        guard !taskName.isEmpty else {
            alertMessage = "Task needs a name"
            showAlert = true
            return false
        }

        // Check if frequency is an integer
        guard Int(taskFrequency) != nil else {
            alertMessage = "Frequency must be an integer."
            showAlert = true
            return false
        }

        // Check if the number of levels is the same as the number of short descriptions
        guard taskLevels.count == taskLevelShorts.count else {
            alertMessage = "The number of levels must match the number of short descriptions."
            showAlert = true
            return false
        }

        return true
    }

    private func updateTask() {
        // Update task properties and save to CoreData
        withAnimation {
            task.name = taskName
            task.levels = taskLevels.joined(separator: ",")
            task.levelshorts = taskLevelShorts.joined(separator: ",")
            task.frequency = Int16(taskFrequency) ?? 1
            task.start_date = taskStartDate
            task.end_date = isEndDateSet ? taskEndDate : nil
            // Any additional logic needed for updating task

            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                alertMessage = "Failed to save task"
                showAlert = true
            }
        }
    }
}
