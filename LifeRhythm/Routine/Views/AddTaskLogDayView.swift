//import SwiftUI
//import CoreData
//import Foundation
//
//struct TaskWithAdditionalInfo {
//    var task: Task
//    var additionalInfo: String
//}
//
//struct AddTaskDayView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.presentationMode) private var presentationMode
//    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Task.next_deadline, ascending: true)])
//    private var tasks: FetchedResults<Task>
//
//    @State private var date = Date()
//    @State private var additional = ""
//    
//    @State private var completedTasks : [Task] = []
//    @State private var tasksAdditional : [String] = []
//    @State private var tasksLevel : [String] = []
//    
//    @State private var taskStatus: [Task: String] = [:]
//    @State private var taskAdditionalInfo: [Task: String] = [:]
//
//    var body: some View {
//        NavigationView{
//            Form {
//                Section(header: Text("Task Log Day Details")) {
//                    DatePicker("Date", selection: $date)
//                    TextField("Additional", text: $additional)
//                }
//                
//                Section(header: Text("Tasks")) {
//                    ForEach(tasks, id: \.id) { task in
//                        VStack {
//                            let levelShortsArray = task.levelshorts?.components(separatedBy: ",") ?? []
//                            let pickerOptions = ["uncomplete", "not done"] + levelShortsArray
//                            let daysDiff = Calendar.current.dateComponents([.day], from: date, to: task.next_deadline ?? Date()).day ?? 0
//                            
//                            // Task introduction
//                            HStack{
//                                Text(task.name ?? "Unnamed Task")
//                                Spacer()
//                                Text("Days to Deadline : " + String(daysDiff))
//                            }
//                            
//                            // Picker for style
//                            Picker("Status", selection: Binding(
//                                get: {taskStatus[task] ?? "uncomplete" },
//                                set: {newValue in taskStatus[task] = newValue}
//                            )) {
//                                ForEach(pickerOptions, id: \.self) { option in
//                                    Text(option).tag(option)
//                                }
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//                            
//                            // Text field for additional
//                            if taskStatus[task] != "uncomplete" {
//                                TextField("Additional Info", text: Binding(
//                                    get: { taskAdditionalInfo[task] ?? "" },
//                                    set: { newValue in taskAdditionalInfo[task] = newValue }
//                                ))
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                            }
//                        }
//                    }
//                }
//                .onAppear {
//                    tasks.forEach { task in
//                        taskStatus[task] = "uncomplete"
//                    }
//                }
//                
//                Button(action: {
//                    saveTaskLogDay()
//                }) {
//                    Text("Save Task Log Day")
//                }
//            }
//            .navigationBarTitle("Add TaskLogDay", displayMode: .inline)
//            .navigationBarItems(trailing: Button("Cancel") {
//                presentationMode.wrappedValue.dismiss()
//            })
//        }
//    }
//
//    private func saveTaskLogDay() {
//        withAnimation {
//            let newTaskDay = TaskDay(context: viewContext)
//            newTaskDay.date = date
//            newTaskDay.additional = additional
//
//            // Initialize dictionaries to store additional and levels
//            var tasksAdditionalDict: [String: String] = [:]
//            var tasksLevelDict: [String: String] = [:]
//
//            for task in tasks {
//                
//                // save info and if completed add to relationship
//                tasksLevelDict[task.name ?? "Unnamed Task"] = taskStatus[task]
//                if let status = taskStatus[task], !["uncomplete", "not done"].contains(status) {
//                    newTaskDay.addToDidTasks(task)
//                }
//                
//                // Check additional info
//                if let additionalInfo = taskAdditionalInfo[task] {
//                    tasksAdditionalDict[task.name ?? "Unnamed Task"] = additionalInfo
//                }
//            }
//
//            // Convert the dictionary to a JSON string
//            if let jsonData = try? JSONSerialization.data(withJSONObject: tasksAdditionalDict, options: []) {
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print(jsonString)
//                    newTaskDay.tasksAdditional = jsonString
//                }
//            }
//            // Convert the dictionary to a JSON string
//            if let jsonData = try? JSONSerialization.data(withJSONObject: tasksLevelDict, options: []) {
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print(jsonString)
//                    newTaskDay.tasksLevels = jsonString
//                }
//            }
//            
//            print((newTaskDay.didTasks ?? []).count)
//
//            do {
//                try viewContext.save()
//                presentationMode.wrappedValue.dismiss()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//struct AddTaskLogDayView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.preview.container.viewContext
//        return AddTaskDayView()
//            .environment(\.managedObjectContext, context)
//    }
//}

import SwiftUI
import CoreData
import Foundation

struct AddTaskDayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var date = Date()
    @State private var additional = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Log Day Details")) {
                    DatePicker("Date", selection: $date)
                    TextField("Additional", text: $additional)
                }
                
                Button(action: saveTaskLogDay) {
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
            let newTaskDay = TaskDay(context: viewContext)
            newTaskDay.date = date
            newTaskDay.additional = additional
            
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
