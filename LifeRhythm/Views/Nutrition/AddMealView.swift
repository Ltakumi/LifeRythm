import SwiftUI
import CoreData

struct AddMealView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    // Input dailyintake we will attach meal to
    let dailyIntake: DailyIntake
    
    // Meal properties
    @State private var name: String = ""
    @State private var additional: String = ""
    @State private var cheatMeal: Bool = false
    @State private var timestamp: Date = Date()
    @State private var cookingType: String = "home"
    let cookingTypes = ["home", "restaurant", "takeout", "drinks"]

    // Ingredient selection and quantities
    @State private var selectedIngredientIndex: Int = 0
    var selectedIngredientID: UUID? {
        guard ingredients.indices.contains(selectedIngredientIndex) else {
            return nil
        }
        return ingredients[selectedIngredientIndex].id
    }
    @State private var ingredientQuantity: String = ""
    @State private var selectedIngredients: [Ingredients] = []
    @State private var ingredientQuantities: [String] = []
    @State private var showingAlert = false
    @State private var alertmessage = ""
    @State private var selectedIngredientDetails: String = ""
    
    @State private var overrideMealDetails: Bool = false
    @State private var mealCalories: String = ""
    @State private var mealProteins: String = ""
    @State private var mealCarbs: String = ""
    @State private var mealFats: String = ""

    // Fetch all ingredients
    @FetchRequest(
        entity: Ingredients.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Ingredients.name, ascending: true)]
    ) var ingredients: FetchedResults<Ingredients>
    
    var body: some View {
        Form {
            Section(header: Text("Meal Details")) {
                TextField("Name", text: $name)
                Picker("Cooking Type", selection: $cookingType) {
                    ForEach(cookingTypes, id: \.self) {type in
                        Text(type.capitalized)
                    }
                }
                    DatePicker("Timestamp", selection: $timestamp,
                               displayedComponents: [.date, .hourAndMinute])
                    Toggle(isOn: $cheatMeal) {Text("Cheat Meal")}
                    TextField("Additional", text: $additional)
            }
            
            Section(header: Text("Add Ingredients")) {
                Picker("Select Ingredient", selection: $selectedIngredientIndex) {
                    ForEach(0..<ingredients.count, id: \.self) { index in
                        Text(ingredients[index].name ?? "Unknown").tag(index)
                    }
                }
                .onChange(of: selectedIngredientIndex) { _ in
                    updateSelectedIngredientName()
                }
                if !selectedIngredientDetails.isEmpty {
                    Text(selectedIngredientDetails)
                }
                HStack {
                    TextField("Quantity", text: $ingredientQuantity)
                        .keyboardType(.decimalPad)
                    Button("Add Ingredient") {
                        addIngredientToList()
                        if !overrideMealDetails {
                            // Calculate meal details
                            calculateMealDetails()
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"),
                                  message: Text(alertmessage), dismissButton: .default(Text("OK")))
                        }
                }
                
//                 List to display selected ingredients and their quantities
                ForEach(Array(selectedIngredients.indices), id: \.self) { index in
                    HStack {
                        Text(selectedIngredients[index].name ?? "Unknown")
                        Spacer()
                        Text("Quantity: \(ingredientQuantities[index])")
                    }
                }
            }
            
            Section(header: Text("Meal Details")) {
                Toggle("Override", isOn: $overrideMealDetails)
                TextField("Calories", text: $mealCalories)
                    .keyboardType(.decimalPad) // Allows decimal input
                TextField("Proteins", text: $mealProteins)
                    .keyboardType(.decimalPad)
                TextField("Carbs", text: $mealCarbs)
                    .keyboardType(.decimalPad)
                TextField("Fats", text: $mealFats)
                    .keyboardType(.decimalPad)
            }

            
//
            Button("Save Meal") {
                saveMeal()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertmessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle("Add Meal", displayMode: .inline)
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func updateSelectedIngredientName() {
        selectedIngredientDetails = ingredients[selectedIngredientIndex].formatDetails()
    }

    private func addIngredientToList() {
        // Check if the quantity is a valid number
        guard let quantity = Double(ingredientQuantity) else {
            alertmessage = "ERROR: Invalid quantity. Please enter a valid number."
            showingAlert = true
            return
        }
        
        let ingredient = ingredients[selectedIngredientIndex]
        selectedIngredients.append(ingredient)
        ingredientQuantities.append("\(quantity)") // Convert quantity back to string
    }
        
    // Function to calculate meal details based on ingredients and quantities
    private func calculateMealDetails() {

        // Calculate the meal details based on selected ingredients and quantities
        var totalCalories = 0.0
        var totalProteins = 0.0
        var totalCarbs = 0.0
        var totalFats = 0.0

        for (index, ingredient) in selectedIngredients.enumerated() {
            if let quantity = Double(ingredientQuantities[index]) {
                totalCalories += ingredient.calories * quantity
                totalProteins += ingredient.proteins * quantity
                totalCarbs += ingredient.carbs * quantity
                totalFats += ingredient.fats * quantity
            }
        }

        // Update the meal detail @State properties
        mealCalories = "\(totalCalories)"
        mealProteins = "\(totalProteins)"
        mealCarbs = "\(totalCarbs)"
        mealFats = "\(totalFats)"
    }

    private func saveMeal() {
        print("SAVE MEAL")
        // Validation for meal details
        guard !name.isEmpty,
              let mealCalories = Double(mealCalories),
              let mealFats = Double(mealFats),
              let mealProteins = Double(mealProteins),
              let mealCarbs = Double(mealCarbs) else {
            showingAlert = true
            alertmessage = "Must have name and valid numbers for macros"
            return
        }

        let newMeal = Meal(context: viewContext)
        newMeal.name = name
        newMeal.calories = mealCalories
        newMeal.fats = mealFats
        newMeal.proteins = mealProteins
        newMeal.carbs = mealCarbs
        newMeal.inDay = dailyIntake
        newMeal.additional = additional
        newMeal.timestamp = timestamp
        newMeal.cheatMeal = cheatMeal
        newMeal.cookingType = cookingType

        // Add selected ingredients to the meal
        for ingredient in selectedIngredients {
            newMeal.addToContainsIngredients(ingredient)
        }
        newMeal.ingredientunits = ingredientQuantities.joined(separator: ", ")
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let mockDailyIntake = DailyIntake.mock(with: context)
        AddMealView(dailyIntake: mockDailyIntake).environment(\.managedObjectContext, context)
    }
}
