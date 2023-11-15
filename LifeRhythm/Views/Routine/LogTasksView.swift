import SwiftUI
import CoreData

struct LogTasksView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: TaskLogDay.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskLogDay.date, ascending: true)])
    private var taskLogDays: FetchedResults<TaskLogDay>
    
    @State private var showingAddDay = false

    var body: some View {
        List(taskLogDays, id: \.self) { taskLogDay in
            NavigationLink(destination: TaskLogDayView(taskLogDay: taskLogDay)) {
                Text("\(DateUtils.formatDate(taskLogDay.date))")
            }
        }
        .navigationBarTitle("Task Log Days")
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

