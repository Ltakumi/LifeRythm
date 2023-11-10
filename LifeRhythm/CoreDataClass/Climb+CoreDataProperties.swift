//
//  Climb+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/10.
//
//

import Foundation
import CoreData


extension Climb {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Climb> {
        return NSFetchRequest<Climb>(entityName: "Climb")
    }

    @NSManaged public var grade: String?
    @NSManaged public var id: String?
    @NSManaged public var tags: String?
    @NSManaged public var type: String?
    @NSManaged public var attempts: NSSet?
    @NSManaged public var inSet: Set?

}

// MARK: Generated accessors for attempts
extension Climb {

    @objc(addAttemptsObject:)
    @NSManaged public func addToAttempts(_ value: Attempt)

    @objc(removeAttemptsObject:)
    @NSManaged public func removeFromAttempts(_ value: Attempt)

    @objc(addAttempts:)
    @NSManaged public func addToAttempts(_ values: NSSet)

    @objc(removeAttempts:)
    @NSManaged public func removeFromAttempts(_ values: NSSet)

}

extension Climb : Identifiable {

}
