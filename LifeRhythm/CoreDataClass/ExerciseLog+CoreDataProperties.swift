//
//  ExerciseLog+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/13.
//
//

import Foundation
import CoreData


extension ExerciseLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseLog> {
        return NSFetchRequest<ExerciseLog>(entityName: "ExerciseLog")
    }

    @NSManaged public var rep: NSObject?
    @NSManaged public var rest: NSObject?
    @NSManaged public var effort: NSObject?
    @NSManaged public var additional: String?
    @NSManaged public var exercise: Exercise?
    @NSManaged public var inSession: Session?

}

extension ExerciseLog : Identifiable {

}
