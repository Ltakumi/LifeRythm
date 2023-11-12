//
//  Exercice+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/13.
//
//

import Foundation
import CoreData


extension Exercice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercice> {
        return NSFetchRequest<Exercice>(entityName: "Exercice")
    }

    @NSManaged public var name: String?
    @NSManaged public var detail: String?
    @NSManaged public var type: String?
    @NSManaged public var instances: NSSet?

}

// MARK: Generated accessors for instances
extension Exercice {

    @objc(addInstancesObject:)
    @NSManaged public func addToInstances(_ value: ExerciceLog)

    @objc(removeInstancesObject:)
    @NSManaged public func removeFromInstances(_ value: ExerciceLog)

    @objc(addInstances:)
    @NSManaged public func addToInstances(_ values: NSSet)

    @objc(removeInstances:)
    @NSManaged public func removeFromInstances(_ values: NSSet)

}

extension Exercice : Identifiable {

}
