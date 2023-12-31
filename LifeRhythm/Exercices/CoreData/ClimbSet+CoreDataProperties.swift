//
//  ClimbSet+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/22.
//
//

import Foundation
import CoreData


extension ClimbSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClimbSet> {
        return NSFetchRequest<ClimbSet>(entityName: "ClimbSet")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var period_end: Date?
    @NSManaged public var period_start: Date?
    @NSManaged public var additional: String?
    
    @NSManaged public var inLocation: Location?
    @NSManaged public var containsClimb: NSSet?
    @NSManaged public var containsSession: NSSet?
    
    func displayName() -> String {
        return self.name ?? "Unnamed set"
    }
}

// MARK: Generated accessors for containsClimb
extension ClimbSet {

    @objc(addContainsClimbObject:)
    @NSManaged public func addToContainsClimb(_ value: Climb)

    @objc(removeContainsClimbObject:)
    @NSManaged public func removeFromContainsClimb(_ value: Climb)

    @objc(addContainsClimb:)
    @NSManaged public func addToContainsClimb(_ values: NSSet)

    @objc(removeContainsClimb:)
    @NSManaged public func removeFromContainsClimb(_ values: NSSet)

}

// MARK: Generated accessors for containsSession
extension ClimbSet {

    @objc(addContainsSessionObject:)
    @NSManaged public func addToContainsSession(_ value: Session)

    @objc(removeContainsSessionObject:)
    @NSManaged public func removeFromContainsSession(_ value: Session)

    @objc(addContainsSession:)
    @NSManaged public func addToContainsSession(_ values: NSSet)

    @objc(removeContainsSession:)
    @NSManaged public func removeFromContainsSession(_ values: NSSet)

}

extension ClimbSet : Identifiable {

}
