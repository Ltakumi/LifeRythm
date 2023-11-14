//
//  Ingredients+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/14.
//
//

import Foundation
import CoreData


extension Ingredients {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredients> {
        return NSFetchRequest<Ingredients>(entityName: "Ingredients")
    }

    @NSManaged public var additional: String?
    @NSManaged public var calories: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fats: Double
    @NSManaged public var name: String?
    @NSManaged public var proteins: Double
    @NSManaged public var unit: String?
    @NSManaged public var inMeal: Meal?

}

extension Ingredients : Identifiable {

}
