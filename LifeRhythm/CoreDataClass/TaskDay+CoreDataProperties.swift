//
//  TaskDay+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/21.
//
//

import Foundation
import CoreData


extension TaskDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskDay> {
        return NSFetchRequest<TaskDay>(entityName: "TaskDay")
    }

    @NSManaged public var additional: String?
    @NSManaged public var date: Date?
    @NSManaged public var tasksAdditional: String?
    @NSManaged public var tasksLevels: String?
    @NSManaged public var didTasks: NSSet?

}

// MARK: Generated accessors for didTasks
extension TaskDay {

    @objc(addDidTasksObject:)
    @NSManaged public func addToDidTasks(_ value: Task)

    @objc(removeDidTasksObject:)
    @NSManaged public func removeFromDidTasks(_ value: Task)

    @objc(addDidTasks:)
    @NSManaged public func addToDidTasks(_ values: NSSet)

    @objc(removeDidTasks:)
    @NSManaged public func removeFromDidTasks(_ values: NSSet)

}

extension TaskDay : Identifiable {

}
