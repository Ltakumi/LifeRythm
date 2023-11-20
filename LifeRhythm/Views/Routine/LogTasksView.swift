import SwiftUI
import CoreData

struct LogTasksView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: TaskDay.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskDay.date, ascending: true)])
    private var taskDays: FetchedResults<TaskDay>
    
    @State private var showingAddDay = false

    var body: some View {
        List(taskDays, id: \.self) { taskDay in
            NavigationLink(destination: TaskDayView(taskDay: taskDay)) {
                Text("\(DateUtils.formatDate(taskDay.date))")
            }
        }
        .navigationBarTitle("Task Days")
        .navigationBarItems(trailing:
            Button(action: {
                showingAddDay = true
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $showingAddDay) {
            AddTaskLogDayView()
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct LogTasksView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return LogTasksView()
            .environment(\.managedObjectContext, context)
    }
}

