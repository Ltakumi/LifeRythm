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

    @NSManaged public var rep: String?
    @NSManaged public var rest: String?
    @NSManaged public var effort: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var additional: String?
    @NSManaged public var exercise: Exercise?
    @NSManaged public var inSession: Session?
    @NSManaged public var id: UUID?
    
    func formatExercise() -> String {
        let formattedTime = DateUtils.formatTime(timestamp)
        let exerciseName = exercise?.name ?? "Unknown Exercise"
        return "\(formattedTime) - \(exerciseName)"
    }

}

extension ExerciseLog : Identifiable {
}
