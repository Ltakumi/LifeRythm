import SwiftUI
import CoreData
import UIKit

struct AddTaskView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var taskName = ""
    @State private var taskLevels : [String] = [""]
    @State private var taskLevelShorts : [String] = [""]
    @State private var taskFrequency : String = ""
    @State private var taskStartDate = Date()
    @State private var isEndDateSet = false
    @State private var taskEndDate = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    

    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Task Details")) {
                    
                    TextField("Task Name", text: $taskName)
                                        
                    DatePicker("Start Date", selection: $taskStartDate)
                    
                    Toggle("Set End Date", isOn: $isEndDateSet)
                    // Conditionally display the DatePicker based on the toggle
                    if isEndDateSet {
                        DatePicker("End Date", selection: $taskEndDate)
                    }
                    
                    TextField("Frequency (in days)", text: $taskFrequency)
                                            .keyboardType(.numberPad)
                }
                
                Section(header: Text("Task Levels")) {
                    List {
                        ForEach(taskLevels.indices, id: \.self) { index in
                            TextField("Level \(index + 1)", text: $taskLevels[index])
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
                            TextField("Short desc \(index + 1)", text: $taskLevelShorts[index])
                        }
                        .onDelete(perform: deleteShortDesc)

                        Button(action: addShortDesc) {
                            Text("Add level short desc")
                        }
                    }
                }
                
                Button(action: {
                    saveTask()
                }) {
                    Text("Save Task")
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Could not save task"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationBarTitle("Add Task", displayMode: .inline)
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
    
    private func saveTask() {
        
        guard isInputValid() else { return }
                
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.name = taskName
            newTask.levels = taskLevels.joined(separator: ",")
            newTask.levelshorts = taskLevelShorts.joined(separator: ",")
            newTask.start_date = taskStartDate
            newTask.end_date = isEndDateSet ? taskEndDate : nil
            newTask.frequency = Int16(taskFrequency) ?? 1
            
            // Calculate the next date by adding taskFrequency days
            if let frequency = Int(taskFrequency), let nextDate = Calendar.current.date(byAdding: .day, value: frequency, to: taskStartDate) {
                newTask.next_deadline = nextDate
            }
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    AddTaskView()
}
