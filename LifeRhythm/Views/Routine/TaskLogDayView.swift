//
//  TaskLogDayView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/16.
//

import SwiftUI

struct TaskDayView: View {
    var taskDay: TaskDay
    
    var body: some View {
        VStack {
            Text("Date: \(taskDay.date ?? Date(), formatter: dateFormatter)")
            Text("Additional: \(taskDay.additional ?? "")")
            Text("Task Additional: \(taskDay.tasksAdditional ?? "")")
        }
        .navigationBarTitle("Task Log Day")
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

//#Preview {
//    TaskLogDayView()
//}
