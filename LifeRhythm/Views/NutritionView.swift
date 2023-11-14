import SwiftUI

struct NutritionView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: IngredientSetupView()) {
                    Text("Ingredient Setup")
                }

                NavigationLink(destination: IntakeLoggingView()) {
                    Text("Intake Logging")
                }
            }
            .navigationTitle("Nutrition")
        }
    }
}

// Preview
struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
