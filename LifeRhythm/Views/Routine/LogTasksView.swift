//
//  LogTasksView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/16.
//

import SwiftUI

struct LogTasksView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TaskLogDay.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TaskLogDay.date, ascending: true)]) private var taskLogDays: FetchedResults<TaskLogDay>

    var body: some View {
        NavigationView {
            List(taskLogDays, id: \.self) { taskLogDay in
                NavigationLink(destination: TaskLogDayView(taskLogDay: taskLogDay)) {
                    Text("\(taskLogDay.date ?? Date(), formatter: dateFormatter)")
                }
            }
            .navigationBarTitle("Task Log Days")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTaskLogDayView()) {
                        Text("Add")
                    }
                }
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

#Preview {
    LogTasksView()
}
