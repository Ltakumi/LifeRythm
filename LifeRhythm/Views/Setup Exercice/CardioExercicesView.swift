import SwiftUI
import CoreData

struct CardioExercisesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)],
        predicate: NSPredicate(format: "type == %@", "cardio")
    ) var cardioExercises: FetchedResults<Exercise>

    @State private var showingAddExerciseView = false

    var body: some View {
        List {
            ForEach(cardioExercises, id: \.self) { exercise in
                NavigationLink(destination: ExerciseView(exercise: exercise)) {
                    Text(exercise.name ?? "Unknown Exercise")
                }
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

struct CardioExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return CardioExercisesView().environment(\.managedObjectContext, context)
    }
}
