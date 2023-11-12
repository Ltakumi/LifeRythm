import SwiftUI
import CoreData

struct LiftingExercisesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Exercice.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercice.name, ascending: true)],
        predicate: NSPredicate(format: "type == %@", "lifting")
    ) var liftingExercises: FetchedResults<Exercice>

    @State private var showingAddExerciseView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(liftingExercises, id: \.self) { exercise in
                    Text(exercise.name ?? "Unknown Exercise")
                }
            }
            .navigationTitle("Lifting Exercises")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddExerciseView) {
                AddExerciseView(type: "lifting")
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

struct LiftingExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return LiftingExercisesView().environment(\.managedObjectContext, context)
    }
}
