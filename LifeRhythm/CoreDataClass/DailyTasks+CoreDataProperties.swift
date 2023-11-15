//
//  DailyTasks+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/16.
//
//

import Foundation
import CoreData


extension DailyTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTasks> {
        return NSFetchRequest<DailyTasks>(entityName: "DailyTasks")
    }

    @NSManaged public var date: Date?
    @NSManaged public var additional: String?
    @NSManaged public var taskAdditional: String?
    @NSManaged public var didTasks: NSSet?

}

// MARK: Generated accessors for didTasks
extension DailyTasks {

    @objc(addDidTasksObject:)
    @NSManaged public func addToDidTasks(_ value: Task)

    @objc(removeDidTasksObject:)
    @NSManaged public func removeFromDidTasks(_ value: Task)

    @objc(addDidTasks:)
    @NSManaged public func addToDidTasks(_ values: NSSet)

    @objc(removeDidTasks:)
    @NSManaged public func removeFromDidTasks(_ values: NSSet)

}

extension DailyTasks : Identifiable {

}
