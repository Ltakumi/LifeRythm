//
//  Exercise+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/13.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var detail: String?
    @NSManaged public var type: String?
    @NSManaged public var instances: NSSet?

}

// MARK: Generated accessors for instances
extension Exercise {

    @objc(addInstancesObject:)
    @NSManaged public func addToInstances(_ value: ExerciseLog)

    @objc(removeInstancesObject:)
    @NSManaged public func removeFromInstances(_ value: ExerciseLog)

    @objc(addInstances:)
    @NSManaged public func addToInstances(_ values: NSSet)

    @objc(removeInstances:)
    @NSManaged public func removeFromInstances(_ values: NSSet)

}

extension Exercise : Identifiable {

}
