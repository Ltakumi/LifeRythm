import SwiftUI
import CoreData

struct SetupTasksView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.start_date, ascending: true)]) var tasks: FetchedResults<Task>

    @State private var showingAddTask = false

    var body: some View {
        List {
            ForEach(tasks, id: \.id) { task in
                NavigationLink(destination: TaskView(task: task)) {
                    Text(task.name ?? "Unnamed Task")
                }
            }
        }
        .navigationBarTitle("Tasks")
        .navigationBarItems(trailing:
            Button(action: {
                showingAddTask = true
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct SetupTasksView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return SetupTasksView()
            .environment(\.managedObjectContext, context)
    }
}
