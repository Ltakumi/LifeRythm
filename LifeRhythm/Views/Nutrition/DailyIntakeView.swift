//
//  DailyIntakeView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/14.
//

import SwiftUI

struct DailyIntakeView: View {
    let dailyIntake: DailyIntake

    var body: some View {
        List {
            Section(header: Text("Daily Intake Details")) {
                if let date = dailyIntake.date {
                    HStack {
                        Text("Date:")
                        Spacer()
                        Text(DateUtils.formatDate(date)) // Assuming DateUtils.formatDate is implemented
                    }
                }

                HStack {
                    Text("Exercise Level:")
                    Spacer()
                    Text(dailyIntake.exerciseLevel ?? "N/A")
                }

                HStack {
                    Text("Target Calories:")
                    Spacer()
                    Text("\(dailyIntake.targetCalories, specifier: "%.2f")")
                }

                HStack {
                    Text("Target Carbs (g):")
                    Spacer()
                    Text("\(dailyIntake.targetCarbs, specifier: "%.2f")")
                }

                HStack {
                    Text("Target Fats (g):")
                    Spacer()
                    Text("\(dailyIntake.targetFats, specifier: "%.2f")")
                }

                HStack {
                    Text("Target Proteins (g):")
                    Spacer()
                    Text("\(dailyIntake.targetProteins, specifier: "%.2f")")
                }

                if let additional = dailyIntake.additional, !additional.isEmpty {
                    HStack {
                        Text("Additional Information:")
                        Spacer()
                        Text(additional)
                    }
                }
            }
        }
        .navigationTitle("Daily Intake Details")
    }
}

//#Preview {
//    DailyIntakeView()
//}
