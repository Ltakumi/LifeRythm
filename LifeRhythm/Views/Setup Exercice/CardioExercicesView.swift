import SwiftUI
import CoreData

struct CardioExercisesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Exercice.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercice.name, ascending: true)],
        predicate: NSPredicate(format: "type == %@", "cardio")
    ) var cardioExercises: FetchedResults<Exercice>

    @State private var showingAddExerciseView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(cardioExercises, id: \.self) {exercise in
                    Text(exercise.name ?? "Unknown Exercise")
                }
            }
            .navigationTitle("Cardio Exercises")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddExerciseView) {
                AddExerciseView(type: "cardio")
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

struct CardioExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return CardioExercisesView().environment(\.managedObjectContext, context)
    }
}
