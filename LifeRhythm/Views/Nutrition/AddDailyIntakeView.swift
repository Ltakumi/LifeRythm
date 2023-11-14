import SwiftUI

struct AddDailyIntakeView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var date = Date()
    @State private var exerciseLevel: String = ""
    @State private var targetCalories: String = ""
    @State private var targetCarbs: String = ""
    @State private var targetFats: String = ""
    @State private var targetProteins: String = ""
    @State private var additional: String = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Exercise Level", text: $exerciseLevel)
                TextField("Target Calories", text: $targetCalories)
                    .keyboardType(.decimalPad)
                TextField("Target Carbs (g)", text: $targetCarbs)
                    .keyboardType(.decimalPad)
                TextField("Target Fats (g)", text: $targetFats)
                    .keyboardType(.decimalPad)
                TextField("Target Proteins (g)", text: $targetProteins)
                    .keyboardType(.decimalPad)
                TextField("Additional Information", text: $additional)

                Button("Add") {
                    if isValidInput() {
                        addDailyIntake()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text("Please fill all required fields correctly."), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Add Daily Intake", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func isValidInput() -> Bool {
        // Check if the exercise level is not empty
        // and if the date is a valid date (not in the future, for example)
        let currentDate = Date()
        return !exerciseLevel.isEmpty && date <= currentDate
    }
    
    private func addDailyIntake() {
        let newDailyIntake = DailyIntake(context: viewContext)
        newDailyIntake.date = date
        newDailyIntake.exerciseLevel = exerciseLevel
        newDailyIntake.targetCalories = Double(targetCalories) ?? 0
        newDailyIntake.targetCarbs = Double(targetCarbs) ?? 0
        newDailyIntake.targetFats = Double(targetFats) ?? 0
        newDailyIntake.targetProteins = Double(targetProteins) ?? 0
        newDailyIntake.additional = additional

        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// Preview
struct AddDailyIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        AddDailyIntakeView()
    }
}
