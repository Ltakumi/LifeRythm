//
//  Location+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/12.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var locationType: String?
    @NSManaged public var climbType: String?
    @NSManaged public var additional: String?
    @NSManaged public var containsSet: NSSet?

}

// MARK: Generated accessors for containsSet
extension Location {

    @objc(addContainsSetObject:)
    @NSManaged public func addToContainsSet(_ value: Set)

    @objc(removeContainsSetObject:)
    @NSManaged public func removeFromContainsSet(_ value: Set)

    @objc(addContainsSet:)
    @NSManaged public func addToContainsSet(_ values: NSSet)

    @objc(removeContainsSet:)
    @NSManaged public func removeFromContainsSet(_ values: NSSet)

}

extension Location : Identifiable {

}
