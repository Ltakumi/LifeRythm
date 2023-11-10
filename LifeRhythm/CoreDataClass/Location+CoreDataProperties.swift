//
//  Location+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/10.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var city: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
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
