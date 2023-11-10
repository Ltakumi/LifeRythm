//
//  Session+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/10.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var additional: String?
    @NSManaged public var comment: String?
    @NSManaged public var end: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var start: Date?
    @NSManaged public var inSet: Set?
    @NSManaged public var containsAttempt: NSSet?

}

// MARK: Generated accessors for containsAttempt
extension Session {

    @objc(addContainsAttemptObject:)
    @NSManaged public func addToContainsAttempt(_ value: Attempt)

    @objc(removeContainsAttemptObject:)
    @NSManaged public func removeFromContainsAttempt(_ value: Attempt)

    @objc(addContainsAttempt:)
    @NSManaged public func addToContainsAttempt(_ values: NSSet)

    @objc(removeContainsAttempt:)
    @NSManaged public func removeFromContainsAttempt(_ values: NSSet)

}

extension Session : Identifiable {

}
