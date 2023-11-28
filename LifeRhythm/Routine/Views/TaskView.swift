import SwiftUI
import CoreData

struct TaskView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var task: Task
    @State private var showingEditView = false
    
    var body: some View {
        Form {
            Section(header: Text("Task info")) {
                
                Text("Task Name: \(task.name ?? "Unnamed Task")")
                Text("Frequency: \(task.frequency)")
                Text("Start Date:" + DateUtils.formatDate(task.start_date))
                Text("Next Deadline:" + DateUtils.formatDate(task.next_deadline))
                Text("End Date:" + DateUtils.formatDate(task.end_date))
            }
            
            Section(header: Text("Levels")) {
                HStack{
                    if let levelsString = task.levels, !levelsString.isEmpty {
                        let levelsArray = levelsString.split(separator: ",")
                        VStack(alignment: .leading) {
                            ForEach(levelsArray, id: \.self) {level in
                                Text(level)
                            }
                        }
                    }
                    
                    
                    Spacer()
                    
                    if let levelShortsString = task.levelshorts, !levelShortsString.isEmpty {
                        let levelShortsArray = levelShortsString.split(separator: ",")
                        VStack(alignment: .leading) {
                            ForEach(levelShortsArray, id: \.self) { levelShort in
                                Text(levelShort)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Task Details")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showingEditView = true // Open the edit view or modal
                    }) {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $showingEditView) {
                        EditTaskView(task: task)
                            .environment(\.managedObjectContext, self.viewContext)
                    }
                )
            }
        }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = PersistenceController.preview.container.viewContext

        // Initialize the Location entity using the mock context
        let newtask = Task(context: context)
        newtask.name = "task name"
        newtask.start_date = Date()
        newtask.end_date = Date()
        newtask.frequency = 1
    
        // Example data for levels and levelshorts
        let exampleLevels = ["Level 1", "Level 2", "Level 3"]
        let exampleLevelShorts = ["Short 1", "Short 2", "Short 3"]

        // Convert arrays to comma-separated strings
        newtask.levels = exampleLevels.joined(separator: ",")
        newtask.levelshorts = exampleLevelShorts.joined(separator: ",")
        
        // Return the LocationView instance
        return TaskView(task: newtask).environment(\.managedObjectContext, context)
    }
}
