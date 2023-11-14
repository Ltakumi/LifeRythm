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

extension DailyIntake : Identifiable {

}
