//
//  SetupTasksView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/16.
//

import SwiftUI

struct SetupTasksView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.start_date, ascending: true)]) private var tasks: FetchedResults<Task>

    @State private var isAddingTask = false

    var body: some View {
        NavigationView {
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
                    isAddingTask = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isAddingTask) {
                AddTaskView()
                    .environment(\.managedObjectContext, viewContext)
            }
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
