import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Generate Locations
        for i in 1...2 {
            let location = Location(context: viewContext)
            location.id = UUID()
            location.name = "Location \(i)"
            location.address = "City \(i)"
            location.locationType = "Gym"
            location.climbType = "Boulder"
            
            // Generate Sets for each Location
            for j in 1...2 {
                let set = ClimbSet(context: viewContext)
                set.id = UUID()
                set.name = "Set name \(j) for Location \(i)"
                set.period_start = Date()
                set.period_end = Calendar.current.date(byAdding: .month, value: 1, to: set.period_start!)
                set.additional = "Additional Info \(j) for Location \(i)"
                location.addToContainsSet(set)
                
                // Generate Climbs for each Set
                for k in 1...5 {
                    let climb = Climb(context: viewContext)
                    climb.name = "Climb \(k)"
                    climb.grade = "Grade \(k)"
                    climb.tags = "Tags \(k)"
                    climb.id = UUID()
                    set.addToContainsClimb(climb)
                }

                // Generate Sessions for each Set
                for l in 1...2 {
                    let session = Session(context: viewContext)
                    session.id = UUID()
                    session.start = Calendar.current.date(byAdding: .day, value: -i - j - l, to: Date())
                    session.end = Calendar.current.date(byAdding: .hour, value: 3, to: session.start!)
                    session.additional = "Additional Info \(l) for Set \(j)"
                    session.type = "climbing"
                    set.addToContainsSession(session)

                    // Generate Attempts for each Session
                    for m in 1...5 {
                        let attempt = Attempt(context: viewContext)
                        attempt.id = UUID()
                        attempt.outcome = Bool.random() ? "Success" : "Fail"
                        attempt.timestamp = Calendar.current.date(byAdding: .minute, value: m * 5, to: session.start!)!
                        
                        // Randomly associate an attempt with a climb from the set
                        if let climbs = set.containsClimb?.allObjects as? [Climb], !climbs.isEmpty {
                            attempt.idClimb = climbs.randomElement()!
                        }
                        session.addToContainsAttempt(attempt)
                    }
                }
            }
        }
        
        // Generate Exercises
        let exerciseTypes = ["cardio", "climbing", "lifting"]
        for type in exerciseTypes {
            for i in 1...2 {
                let exercise = Exercise(context: viewContext)
                exercise.id = UUID()
                exercise.name = "\(type.capitalized) Exercise \(i)"
                exercise.type = type
                exercise.detail = "Details for \(type.capitalized) Exercise \(i)"
            }
        }
        
        // Generate Workout Sessions
        for i in 1...2 {
            let session = Session(context: viewContext)
            session.id = UUID()
            session.start = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            session.end = Calendar.current.date(byAdding: .hour, value: 2, to: session.start!)
            session.additional = "Workout Session Additional Info \(i)"
            session.type = "workout"

            // Generate ExerciseLogs for each Workout Session
            for j in 1...3 {
                let exerciseLog = ExerciseLog(context: viewContext)
                exerciseLog.timestamp = Calendar.current.date(byAdding: .minute, value: j * 10, to: session.start!)

                // Randomly associate an exerciseLog with an exercise
                let exerciseRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
                if let exercises = try? viewContext.fetch(exerciseRequest), !exercises.isEmpty {
                    exerciseLog.idExercise = exercises.randomElement()
                }

                exerciseLog.effort = "Effort \(j)"
                exerciseLog.rep = "Rep \(j)"
                exerciseLog.rest = "Rest \(j)"
                exerciseLog.additional = "Additional Info for ExerciseLog \(j)"
                exerciseLog.inSession = session
            }
        }
        
        // Generate Ingredients
        let ingredientNames = ["Apple", "Banana", "Chicken Breast"]
        for (index, name) in ingredientNames.enumerated() {
            let ingredient = Ingredients(context: viewContext)
            ingredient.name = name
            ingredient.calories = Double(index * 10) // Mock value
            ingredient.carbs = Double(index * 2) // Mock value
            ingredient.fats = Double(index * 3) // Mock value
            ingredient.proteins = Double(index * 4) // Mock value
            ingredient.unit = "pieces" // Mock value
            ingredient.additional = "Additional Info for \(name)"
        }

        // Generate DailyIntake
        for i in 1...3 {
            let dailyIntake = DailyIntake(context: viewContext)
            dailyIntake.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            dailyIntake.exerciseLevel = "Moderate"
            dailyIntake.targetCalories = Double(i * 2000) // Mock value
            dailyIntake.targetCarbs = Double(i * 250) // Mock value
            dailyIntake.targetFats = Double(i * 70) // Mock value
            dailyIntake.targetProteins = Double(i * 150) // Mock value
            dailyIntake.additional = "Additional Info for Day \(i)"
        }

        // Generate Meals
        let mealNames = ["Breakfast", "Lunch", "Dinner"]
        for (index, name) in mealNames.enumerated() {
            let meal = Meal(context: viewContext)
            meal.name = name
            meal.calories = Double(index * 500) // Mock value
            meal.carbs = Double(index * 50) // Mock value
            meal.fats = Double(index * 20) // Mock value
            meal.proteins = Double(index * 30) // Mock value
            meal.timestamp = Calendar.current.date(byAdding: .hour, value: index * 5, to: Date())
            meal.cheatMeal = index % 2 == 0 // Mock value
            meal.cookingType = "Grilled" // Mock value
            meal.additional = "Additional Info for \(name)"
            // Assuming containsIngredients is a to-many relationship
            let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
            if let ingredients = try? viewContext.fetch(request) {
                meal.containsIngredients = NSSet(array: ingredients)
            }
            // Randomly associate a meal with a daily intake
            let intakeRequest: NSFetchRequest<DailyIntake> = DailyIntake.fetchRequest()
            if let dailyIntakes = try? viewContext.fetch(intakeRequest), !dailyIntakes.isEmpty {
                meal.inDay = dailyIntakes.randomElement()
            }
        }
        
        for i in 1...5 {
            let task = Task(context: viewContext)
            task.id = UUID()
            task.name = "Task \(i)"
            task.levels = ["level1", "level2"].joined(separator: ",")
            task.levelshorts = ["lvl1", "lvl2"].joined(separator: ",")
            task.frequency = Int16(i)
            task.start_date = Date()
            
            // Calculate next_deadline based on frequency and start_date
            // Example: For daily tasks, the next deadline is the next day
            task.next_deadline = Calendar.current.date(byAdding: .day, value: Int(task.frequency), to: task.start_date!)
        }
        
        // Generate TaskDay objects
        for i in 1...3 {
            let taskDay = TaskDay(context: viewContext)
            taskDay.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            taskDay.additional = "Additional Info for Day \(i)"
            taskDay.tasksAdditional = "Task Additional Info for Day \(i)"
        }
        
        // Save context
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "LifeRhythm")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
