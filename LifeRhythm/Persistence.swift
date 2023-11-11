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
            location.type = "Type \(i)"
            
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
                    climb.id = UUID().uuidString
                    climb.grade = "Grade \(k)"
                    climb.tags = "Tags \(k)"
                    climb.type = "Boulder"
                    set.addToContainsClimb(climb)
                }
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
