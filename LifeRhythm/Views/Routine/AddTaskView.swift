import SwiftUI
import CoreData

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var taskName = ""
    @State private var taskType = "Daily" // Default to "Daily"
    @State private var taskInstructions = ""
    @State private var taskStartDate = Date()
    @State private var showAlert = false

    var body: some View {
        NavigationView{
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
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Missing Information"),
                        message: Text("Please fill in all necessary fields."),
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
    
    private func isInputValid() -> Bool {
        return !taskName.isEmpty && !taskInstructions.isEmpty
    }
    
    private func saveTask() {
        guard isInputValid() else {
            showAlert = true
            return
        }
                
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.name = taskName
            newTask.levels = taskInstructions
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
