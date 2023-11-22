import SwiftUI
import CoreData

struct DailyIntakeView: View {
    let dailyIntake: DailyIntake
    
    @FetchRequest var meals: FetchedResults<Meal>
    @State private var showingAddMealView = false

    init(dailyIntake: DailyIntake) {
        self.dailyIntake = dailyIntake
        self._meals = FetchRequest<Meal>(
            entity: Meal.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Meal.timestamp, ascending: true)],
            predicate: NSPredicate(format: "inDay == %@", dailyIntake)
        )
    }

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
            Section(header: Text("Meals")) {
                ForEach(meals, id: \.self) { meal in
                    NavigationLink(destination: MealView(meal: meal)) {
                        Text(meal.name ?? "Unknown Meal")
                    }
                }
            }
        }
        .navigationTitle("Daily Intake Details")
        .navigationBarItems(trailing: Button(action: {
            showingAddMealView = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingAddMealView) {
            AddMealView(dailyIntake: dailyIntake)
        }
    }
}

struct DailyIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSPersistentContainer(name: "LifeRythm").viewContext
        let mockDailyIntake = DailyIntake.mock(with: context)
        DailyIntakeView(dailyIntake: mockDailyIntake)
    }
}
