//
//  MealView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/15.
//

import SwiftUI

import SwiftUI

struct MealView: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(meal.name ?? "Unknown Meal")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Calories: \(meal.calories, specifier: "%.2f")")
            Text("Carbs: \(meal.carbs, specifier: "%.2f")g")
            Text("Fats: \(meal.fats, specifier: "%.2f")g")
            Text("Proteins: \(meal.proteins, specifier: "%.2f")g")
            Text("Cheat Meal: \(meal.cheatMeal ? "Yes" : "No")")
            
            if let cookingType = meal.cookingType {
                Text("Cooking Type: \(cookingType)")
            }
            
            if let additional = meal.additional {
                Text("Additional Info: \(additional)")
            }
        }
    }
}

//
//#Preview {
//    MealView()
//}
