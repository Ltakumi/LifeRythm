import SwiftUI

struct AddIngredientView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var calories: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""
    @State private var proteins: String = ""
    @State private var unit: String = ""
    @State private var additional: String = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ingredient Details")) {
                    TextField("Name", text: $name)
                    TextField("Unit", text: $unit)

                    HStack {
                        Text("Calories (kcal)")
                        TextField("Calories", text: $calories)
                            .keyboardType(.decimalPad)
                    }

                    HStack {
                        Text("Carbs (g)")
                        TextField("Carbs", text: $carbs)
                            .keyboardType(.decimalPad)
                    }

                    HStack {
                        Text("Fats (g)")
                        TextField("Fats", text: $fats)
                            .keyboardType(.decimalPad)
                    }

                    HStack {
                        Text("Proteins (g)")
                        TextField("Proteins", text: $proteins)
                            .keyboardType(.decimalPad)
                    }

                    TextField("Additional", text: $additional)
                }

                Button("Add") {
                    if isValidInput() {
                        addIngredient()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text("Please fill all required fields correctly."), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Add Ingredient", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func isValidInput() -> Bool {
        guard !name.isEmpty, !unit.isEmpty,
              let _ = Double(calories),
              let _ = Double(carbs),
              let _ = Double(fats),
              let _ = Double(proteins) else {
            return false
        }
        return true
    }
    
    private func addIngredient() {
        let newIngredient = Ingredients(context: viewContext)
        newIngredient.name = name
        newIngredient.unit = unit
        newIngredient.calories = Double(calories) ?? 0
        newIngredient.carbs = Double(carbs) ?? 0
        newIngredient.fats = Double(fats) ?? 0
        newIngredient.proteins = Double(proteins) ?? 0
        newIngredient.additional = additional

        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// Preview
struct AddIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientView()
    }
}
