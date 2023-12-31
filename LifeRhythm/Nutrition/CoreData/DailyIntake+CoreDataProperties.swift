//
//  DailyIntake+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/14.
//
//

import Foundation
import CoreData


extension DailyIntake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyIntake> {
        return NSFetchRequest<DailyIntake>(entityName: "DailyIntake")
    }

    @NSManaged public var additional: String?
    @NSManaged public var date: Date?
    @NSManaged public var exerciseLevel: String?
    @NSManaged public var targetCalories: Double
    @NSManaged public var targetCarbs: Double
    @NSManaged public var targetFats: Double
    @NSManaged public var targetProteins: Double
    @NSManaged public var containsMeal: Meal?
    
    public var formattedDate: String {
        guard let date = date else { return "N/A" }
        return DateUtils.formatDate(date)
    }

}

extension DailyIntake {
    static func mock(with context: NSManagedObjectContext) -> DailyIntake {
        let dailyIntake = DailyIntake(context: context)
        dailyIntake.date = Date()
        dailyIntake.exerciseLevel = "Moderate"
        dailyIntake.targetCalories = 2000
        dailyIntake.targetCarbs = 250
        dailyIntake.targetFats = 70
        dailyIntake.targetProteins = 150
        dailyIntake.additional = "Sample additional information"
        // Add more properties if needed
        return dailyIntake
    }
}

extension DailyIntake : Identifiable {

}
