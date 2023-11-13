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
    
    @NSManaged public var id: UUID?
    @NSManaged public var rep: String?
    @NSManaged public var rest: String?
    @NSManaged public var effort: String?
    @NSManaged public var additional: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var idExercise: Exercise?
    @NSManaged public var inSession: Session?
    
    func formatExercise() -> String {
        let formattedTime = DateUtils.formatTime(timestamp)
        let exerciseName = idExercise?.name ?? "Unknown Exercise"
        return "\(formattedTime) - \(exerciseName)"
    }

}

extension ExerciseLog : Identifiable {
}
