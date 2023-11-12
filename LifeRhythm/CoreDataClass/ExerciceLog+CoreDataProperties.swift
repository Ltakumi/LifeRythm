//
//  ExerciceLog+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/13.
//
//

import Foundation
import CoreData


extension ExerciceLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciceLog> {
        return NSFetchRequest<ExerciceLog>(entityName: "ExerciceLog")
    }

    @NSManaged public var rep: NSObject?
    @NSManaged public var rest: NSObject?
    @NSManaged public var effort: NSObject?
    @NSManaged public var additional: String?
    @NSManaged public var exercice: Exercice?
    @NSManaged public var inSession: Session?

}

extension ExerciceLog : Identifiable {

}
