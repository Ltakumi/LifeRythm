import SwiftUI
import CoreData

struct TaskView: View {
    var task: Task
    
    var body: some View {
        VStack {
            Text("Task Name: \(task.name ?? "Unnamed Task")")
            Text("Instructions: \(task.description ?? "")")
            Text("Start Date: \(DateUtils.formatDate(task.start_date))")
        }
        .navigationBarTitle("Task Details")
    }
    
}
//
//#Preview {
//    TaskView()
//}
