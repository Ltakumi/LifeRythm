import SwiftUI
import CoreData

struct ClimbingExercisesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Exercice.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercice.name, ascending: true)],
        predicate: NSPredicate(format: "type == %@", "climbing")
    ) var climbingExercises: FetchedResults<Exercice>

    @State private var showingAddExerciseView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(climbingExercises, id: \.self) { exercise in
                    Text(exercise.name ?? "Unknown Exercise")
                }
            }
            .navigationTitle("Climbing Exercises")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddExerciseView) {
                AddExerciseView(type: "climbing")
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

struct ClimbingExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return ClimbingExercisesView().environment(\.managedObjectContext, context)
    }
}
