import SwiftUI
import CoreData

struct TaskWithAdditionalInfo {
    var task: Task
    var additionalInfo: String
}

struct AddTaskLogDayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.start_date, ascending: true)])
    private var tasks: FetchedResults<Task>

    @State private var date = Date()
    @State private var additional = ""
    
    @State private var completedTasks : [Task] = [] // To track completed tasks
    @State private var taskAdditional : [String] = []
    @State private var taskAdditionalInfo: [Task: String] = [:]

    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Task Log Day Details")) {
                    DatePicker("Date", selection: $date)
                    TextField("Additional", text: $additional)
                }
                
                Section(header: Text("Tasks")) {
                    ForEach(tasks, id: \.id) { task in
                        HStack {
                            Text(task.name ?? "Unnamed Task")
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: {
                                    taskAdditionalInfo[task] != nil
                                },
                                set: { newValue in
                                    if newValue {
                                        // Add task to the dictionary with empty additional info
                                        taskAdditionalInfo[task] = ""
                                    } else {
                                        // Remove task from the dictionary
                                        taskAdditionalInfo[task] = nil
                                    }
                                }
                            ))
                            
                            // TextField for additional info
                            if let additionalInfo = taskAdditionalInfo[task] {
                                TextField("Additional Info", text: Binding(
                                    get: {
                                        additionalInfo
                                    },
                                    set: { newValue in
                                        taskAdditionalInfo[task] = newValue
                                    }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle()) // Optional styling
                            }
                        }
                    }
                }
                
                Button(action: {
                    saveTaskLogDay()
                }) {
                    Text("Save Task Log Day")
                }
            }
            .navigationBarTitle("Add TaskLogDay", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveTaskLogDay() {
        withAnimation {
            let newTaskLogDay = TaskLogDay(context: viewContext)
            newTaskLogDay.date = date
            newTaskLogDay.additional = additional

            // Initialize a dictionary to store taskname : taskadditional
            var taskAdditionalDict: [String: String] = [:]

            // Iterate through tasks and check if they were completed
            for task in tasks {
                if let additionalInfo = taskAdditionalInfo[task] {
                    // Add task to didTasks
                    newTaskLogDay.addToDidTasks(task)

                    // Add taskname : taskadditional to the dictionary
                    taskAdditionalDict[task.name ?? "Unnamed Task"] = additionalInfo
                }
            }

            // Convert the dictionary to a JSON string
            if let jsonData = try? JSONSerialization.data(withJSONObject: taskAdditionalDict, options: []) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    newTaskLogDay.taskAdditional = jsonString
                }
                
            }
            
            print((newTaskLogDay.didTasks ?? []).count)

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

struct AddTaskLogDayView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return AddTaskLogDayView()
            .environment(\.managedObjectContext, context)
    }
}
