import SwiftUI
import CoreData

struct ClimbingExercisesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)],
        predicate: NSPredicate(format: "type == %@", "climbing")
    ) var climbingExercises: FetchedResults<Exercise>

    @State private var showingAddExerciseView = false

    var body: some View {
        List {
            ForEach(climbingExercises, id: \.self) { exercise in
                NavigationLink(destination: ExerciseView(exercise: exercise)) {
                    Text(exercise.name ?? "Unknown Exercise")
                }
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

struct ClimbingExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return ClimbingExercisesView().environment(\.managedObjectContext, context)
    }
}
