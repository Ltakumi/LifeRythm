import SwiftUI
import CoreData
import Foundation

struct TaskWithAdditionalInfo {
    var task: Task
    var additionalInfo: String
}

struct TaskDayView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.next_deadline, ascending: true)])
    private var tasks: FetchedResults<Task>
    
    @ObservedObject var taskDay: TaskDay
    @State private var date : Date
    @State private var additional : String
    @State private var taskStatus: [String: String]
    @State private var taskAdditionalInfo: [String: String]
    
    init(taskDay: TaskDay) {
        self.taskDay = taskDay
        _date = State(initialValue: taskDay.date ?? Date())
        _additional = State(initialValue: taskDay.additional ?? "")

        // Decode tasksLevels and tasksAdditional from JSON
        let tasksLevelsDict = Self.decodeJSONStringToDictionary(jsonString: taskDay.tasksLevels)
        let tasksAdditionalDict = Self.decodeJSONStringToDictionary(jsonString: taskDay.tasksAdditional)

        _taskStatus = State(initialValue: tasksLevelsDict)
        _taskAdditionalInfo = State(initialValue: tasksAdditionalDict)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Log Day Details")) {
                DatePicker("Date", selection: $date)
                TextField("Additional", text: $additional)
            }

            Section(header: Text("Tasks")) {
                ForEach(tasks, id: \.id) { task in
                    VStack {
                        let levelShortsArray = task.levelshorts?.components(separatedBy: ",") ?? []
                        let pickerOptions = ["uncomplete", "not done"] + levelShortsArray
                        let daysDiff = Calendar.current.dateComponents([.day], from: date, to: task.next_deadline ?? Date()).day ?? 0

                        // Task introduction
                        HStack{
                            Text(task.name ?? "Unnamed Task")
                            Spacer()
                            Text("Days to Deadline : " + String(daysDiff))
                        }
                        
                        let taskKey = task.name ?? "Unnamed Task"

                        Picker("Status", selection: Binding(
                            get: { self.taskStatus[taskKey] ?? "uncomplete" },
                            set: { newValue in self.taskStatus[taskKey] = newValue }
                        )) {
                            ForEach(pickerOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: taskStatus[taskKey]) {
                            _ in saveTaskLogDay()
                        }

                        if self.taskStatus[taskKey] != "uncomplete" {
                            TextField("Additional Info", text: Binding(
                                get: { self.taskAdditionalInfo[taskKey] ?? ""},
                                set: { newValue in
                                    self.taskAdditionalInfo[taskKey] = newValue
                                }
                            ), onCommit: {
                                saveTaskLogDay()
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private static func decodeJSONStringToDictionary(jsonString: String?) -> [String: String] {
        guard let jsonString = jsonString,
              let jsonData = jsonString.data(using: .utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] else {
            return [:]
        }
        return dictionary
    }
    
    private func saveTaskLogDay() {
        withAnimation {
            taskDay.date = date
            taskDay.additional = additional

            // Initialize dictionaries to store additional and levels
            var tasksAdditionalDict: [String: String] = [:]
            var tasksLevelDict: [String: String] = [:]
            
            print("entering Loop")
            print(taskStatus)
            print(taskAdditionalInfo)
            
            for task in tasks {
                // save info and if completed add to relationship
                tasksLevelDict[task.name ?? "Unnamed Task"] = taskStatus[task.name ?? "Unnamed Task"]
                if let status = taskStatus[task.name ?? "UnnamedTask"], !["uncomplete", "not done"].contains(status) {
                    taskDay.addToDidTasks(task)
                }

                // Check additional info
                if let additionalInfo = taskAdditionalInfo[task.name ?? "UnnamedTask"] {
                    tasksAdditionalDict[task.name ?? "Unnamed Task"] = additionalInfo
                }
            }

            // Convert the dictionary to a JSON string
            if let jsonData = try? JSONSerialization.data(withJSONObject: tasksAdditionalDict, options: []) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("task Additional")
                    print(jsonString)
                    taskDay.tasksAdditional = jsonString
                }
            }
            // Convert the dictionary to a JSON string
            if let jsonData = try? JSONSerialization.data(withJSONObject: tasksLevelDict, options: []) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("task Levels")
                    print(jsonString)
                    taskDay.tasksLevels = jsonString
                }
            }

            print((taskDay.didTasks ?? []).count)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//#Preview {
//    TaskLogDayView()
//}
