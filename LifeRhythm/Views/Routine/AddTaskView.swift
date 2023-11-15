import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var taskName = ""
    @State private var taskType = "Daily" // Default to "Daily"
    @State private var taskInstructions = ""
    @State private var taskStartDate = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                
                TextField("Task Name", text: $taskName)
                
                Picker("Task Type", selection: $taskType) {
                    Text("Daily").tag("Daily")
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                }
                .pickerStyle(SegmentedPickerStyle())
//                
                TextField("Instructions", text: $taskInstructions)
                
                DatePicker("Start Date", selection: $taskStartDate)
            }
            
            Button(action: {
                saveTask()
            }) {
                Text("Save Task")
            }
        }
        .navigationTitle("Add Task")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { presentationMode.wrappedValue.dismiss()}) {
                    Text("Cancel")
                }
            }
        }
    }
    
    private func isInputValid() -> Bool {
        return !taskName.isEmpty && !taskInstructions.isEmpty && taskStartDate >= Date()
    }
    
    private func saveTask() {
        guard isInputValid() else {
            // Show an error or alert here for invalid input
            return
        }
        
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.name = taskName
            newTask.type = taskType
            newTask.instructions = taskInstructions
            newTask.start_date = taskStartDate
            
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
