//
//  exporter_routine.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/29.
//

import Foundation

struct TaskExport: Codable {
    var frequency: Int16
    var id: UUID?
    var levels: String?
    var levelshorts: String?
    var name: String?
    var nextDeadline: Date?
    var startDate: Date?
    var endDate: Date?

    init(from task: Task) {
        self.frequency = task.frequency
        self.id = task.id
        self.levels = task.levels
        self.levelshorts = task.levelshorts
        self.name = task.name
        self.nextDeadline = task.next_deadline
        self.startDate = task.start_date
        self.endDate = task.end_date
    }
}

struct TaskDayExport: Codable {
    var additional: String?
    var date: Date?
    var tasksAdditional: String?
    var tasksLevels: String?
    var didTasksIDs: [UUID]

    init(from taskDay: TaskDay) {
        self.additional = taskDay.additional
        self.date = taskDay.date
        self.tasksAdditional = taskDay.tasksAdditional
        self.tasksLevels = taskDay.tasksLevels
        self.didTasksIDs = (taskDay.didTasks as? Set<Task>)?.compactMap { $0.id } ?? []
    }
}
