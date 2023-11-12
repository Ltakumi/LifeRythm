import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Generate Locations
        for i in 1...3 {
            let location = Location(context: viewContext)
            location.id = UUID()
            location.name = "Location \(i)"
            location.city = "City \(i)"
            location.locationType = "Type \(i)"
            
            // Generate Sets for each Location
            for j in 1...2 {
                let set = Set(context: viewContext)
                set.id = UUID()
                set.period_start = Date()
                set.period_end = Calendar.current.date(byAdding: .month, value: 1, to: set.period_start!)
                set.additional = "Additional Info \(j) for Location \(i)"
                location.addToContainsSet(set)
                
                // Generate Climbs for each Set
                for k in 1...5 {
                    let climb = Climb(context: viewContext)
                    climb.id = "Climb \(k)"
                    climb.grade = "Grade \(k)"
                    climb.tags = "Tags \(k)"
                    climb.type = "Boulder"
                    set.addToContainsClimb(climb)
                }

                // Generate Sessions for each Set
                for l in 1...2 {
                    let session = Session(context: viewContext)
                    session.id = UUID()
                    session.start = Date()
                    session.end = Calendar.current.date(byAdding: .hour, value: 3, to: session.start!)
                    session.additional = "Additional Info \(l) for Set \(j)"
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
                let exercise = Exercice(context: viewContext)
                exercise.name = "\(type.capitalized) Exercise \(i)"
                exercise.type = type
                exercise.detail = "Details for \(type.capitalized) Exercise \(i)"
            }
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
