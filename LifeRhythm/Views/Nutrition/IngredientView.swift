import SwiftUI

struct IngredientView: View {
    let ingredient: Ingredients

    var body: some View {
        List {
            Section(header: Text("Details")) {
                HStack {
                    Text("Name:")
                    Spacer()
                    Text(ingredient.name ?? "Unknown")
                }

                HStack {
                    Text("Calories:")
                    Spacer()
                    Text("\(ingredient.calories, specifier: "%.2f")")
                }

                HStack {
                    Text("Carbs (g):")
                    Spacer()
                    Text("\(ingredient.carbs, specifier: "%.2f")")
                }

                HStack {
                    Text("Fats (g):")
                    Spacer()
                    Text("\(ingredient.fats, specifier: "%.2f")")
                }

                HStack {
                    Text("Proteins (g):")
                    Spacer()
                    Text("\(ingredient.proteins, specifier: "%.2f")")
                }

                HStack {
                    Text("Unit:")
                    Spacer()
                    Text(ingredient.unit ?? "N/A")
                }

                HStack {
                    Text("Additional:")
                    Spacer()
                    Text(ingredient.additional ?? "None")
                }
            }
        }
        .navigationTitle("Ingredient")
    }
}

// Preview
struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        // Replace with a preview context or mock data
        IngredientView(ingredient: Ingredients())
    }
}
