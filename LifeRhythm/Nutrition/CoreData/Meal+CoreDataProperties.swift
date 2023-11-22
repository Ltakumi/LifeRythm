//
//  Meal+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/14.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var additional: String?
    @NSManaged public var calories: Double
    @NSManaged public var carbs: Double
    @NSManaged public var cheatMeal: Bool
    @NSManaged public var cookingType: String?
    @NSManaged public var fats: Double
    @NSManaged public var ingredientunits: String?
    @NSManaged public var name: String?
    @NSManaged public var proteins: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var containsIngredients: NSSet?
    @NSManaged public var inDay: DailyIntake?

}

// MARK: Generated accessors for containsIngredients
extension Meal {

    @objc(addContainsIngredientsObject:)
    @NSManaged public func addToContainsIngredients(_ value: Ingredients)

    @objc(removeContainsIngredientsObject:)
    @NSManaged public func removeFromContainsIngredients(_ value: Ingredients)

    @objc(addContainsIngredients:)
    @NSManaged public func addToContainsIngredients(_ values: NSSet)

    @objc(removeContainsIngredients:)
    @NSManaged public func removeFromContainsIngredients(_ values: NSSet)

}

extension Meal : Identifiable {

}
