//
//  ExercicesView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/13.
//

import SwiftUI

struct ExercisesView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Climbing", destination: LocationsView())
                NavigationLink("Climbing Training", destination: ClimbingExercicesView())
                NavigationLink("Lifting", destination: LiftingExercicesView())
                NavigationLink("Cardio", destination: CardioExercicesView())
            }
            .navigationBarTitle("Exercises")
        }
    }
}

#Preview {
    ExercisesView()
}
