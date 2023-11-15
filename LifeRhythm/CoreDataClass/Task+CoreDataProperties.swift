//
//  Task+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/16.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var type: String?
    @NSManaged public var instructions: String?
    @NSManaged public var start_date: Date?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var didOnDay: NSSet?

}

// MARK: Generated accessors for didOnDay
extension Task {

    @objc(addDidOnDayObject:)
    @NSManaged public func addToDidOnDay(_ value: DailyTasks)

    @objc(removeDidOnDayObject:)
    @NSManaged public func removeFromDidOnDay(_ value: DailyTasks)

    @objc(addDidOnDay:)
    @NSManaged public func addToDidOnDay(_ values: NSSet)

    @objc(removeDidOnDay:)
    @NSManaged public func removeFromDidOnDay(_ values: NSSet)

}

extension Task : Identifiable {

}
