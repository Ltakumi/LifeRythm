//
//  TaskLogDay+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/16.
//
//

import Foundation
import CoreData


extension TaskLogDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskLogDay> {
        return NSFetchRequest<TaskLogDay>(entityName: "TaskLogDay")
    }

    @NSManaged public var date: Date?
    @NSManaged public var additional: String?
    @NSManaged public var taskAdditional: String?
    @NSManaged public var didTasks: NSSet?

}

// MARK: Generated accessors for didTasks
extension TaskLogDay {

    @objc(addDidTasksObject:)
    @NSManaged public func addToDidTasks(_ value: Task)

    @objc(removeDidTasksObject:)
    @NSManaged public func removeFromDidTasks(_ value: Task)

    @objc(addDidTasks:)
    @NSManaged public func addToDidTasks(_ values: NSSet)

    @objc(removeDidTasks:)
    @NSManaged public func removeFromDidTasks(_ values: NSSet)

}

extension TaskLogDay : Identifiable {

}
