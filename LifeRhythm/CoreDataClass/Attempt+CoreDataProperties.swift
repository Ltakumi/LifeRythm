//
//  Attempt+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/10.
//
//

import Foundation
import CoreData


extension Attempt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attempt> {
        return NSFetchRequest<Attempt>(entityName: "Attempt")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var outcome: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var idClimb: Climb?
    @NSManaged public var inSession: Session?

}

extension Attempt : Identifiable {

}
