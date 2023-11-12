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
                NavigationLink("Climbing Training", destination: ClimbingExercisesView())
                NavigationLink("Lifting", destination: LiftingExercisesView())
                NavigationLink("Cardio", destination: CardioExercisesView())
            }
            .navigationBarTitle("Exercises")
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
