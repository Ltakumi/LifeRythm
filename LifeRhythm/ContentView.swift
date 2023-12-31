import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            ExercisesView()
                .tabItem {
                    Label("Exercices", systemImage: "dumbbell.fill")
                }
            
            SessionsView()
                .tabItem {
                    Label("Sessions", systemImage: "timer")
                }
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "leaf")
                }
            
            RoutineView()
                .tabItem {
                    Label("Routine", systemImage: "calendar")
                }
            
            ExportView()
                .tabItem {
                    Label("Data", systemImage:"chart.bar")
                }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
