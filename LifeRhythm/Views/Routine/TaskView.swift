import SwiftUI
import CoreData

struct TaskView: View {
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Task Name: \(task.name ?? "Unnamed Task")")
            Text("Frequency: \(task.frequency)")
            Text("Start Date:" + DateUtils.formatDate(task.start_date))
            Text("Next Deadline:" + DateUtils.formatDate(task.next_deadline))
            
            if let levelsString = task.levels, !levelsString.isEmpty {
                let levelsArray = levelsString.split(separator: ",")
                VStack(alignment: .leading) {
                    Text("Levels:")
                    ForEach(levelsArray, id: \.self) {level in
                        Text(level)
                    }
                }
            }
            
            if let levelShortsString = task.levelshorts, !levelShortsString.isEmpty {
                let levelShortsArray = levelShortsString.split(separator: ",")
                VStack(alignment: .leading) {
                    Text("Level Descriptions:")
                    ForEach(levelShortsArray, id: \.self) { levelShort in
                        Text(levelShort)
                    }
                }
            }
        }
        .navigationBarTitle("Task Details")
    }
}
//
//#Preview {
//    TaskView()
//}
