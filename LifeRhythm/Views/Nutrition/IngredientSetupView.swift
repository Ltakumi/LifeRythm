//
//  IngredientSetupView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/14.
//

import SwiftUI

struct IngredientSetupView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Ingredients.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Ingredients.name, ascending: true)]
    ) var ingredients: FetchedResults<Ingredients>

    @State private var showingAddIngredientView = false

    var body: some View {
        List(ingredients, id: \.self) { ingredient in
            NavigationLink(destination: IngredientView(ingredient: ingredient)) {
                Text(ingredient.name ?? "Unknown Ingredient")
            }
        }
        .navigationTitle("Ingredients")
        .navigationBarItems(trailing: Button(action: {
            showingAddIngredientView = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingAddIngredientView) {
            AddIngredientView()
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
}

#Preview {
    IngredientSetupView()
}
