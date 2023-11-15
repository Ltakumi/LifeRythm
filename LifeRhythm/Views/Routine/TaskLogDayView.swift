//
//  TaskLogDayView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/16.
//

import SwiftUI

struct TaskLogDayView: View {
    var taskLogDay: TaskLogDay
    
    var body: some View {
        VStack {
            Text("Date: \(taskLogDay.date ?? Date(), formatter: dateFormatter)")
            Text("Additional: \(taskLogDay.additional ?? "")")
            Text("Task Additional: \(taskLogDay.taskAdditional ?? "")")
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
