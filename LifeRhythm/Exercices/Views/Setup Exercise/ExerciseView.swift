import SwiftUI
import CoreData


struct ExerciseView: View {
    var exercise: Exercise
    
    @Environment(\.managedObjectContext) var viewContext
    @State private var showingEditView = false

    var body: some View {
        Section(header: Text("Information")){
            Text("Name: \(exercise.name ?? "Unknown")")
            Text("Type: \(exercise.type ?? "Unknown")")
        }
        
        Section(header : Text("Details")) {
            Text(exercise.detail ?? "No details")
        }
        .navigationBarTitle("Exercise Details")
        .navigationBarItems(
            trailing:
                Button(action: {
                    showingEditView = true // Open the edit view or modal
                }) {
                    Image(systemName: "pencil")
                }
                .sheet(isPresented: $showingEditView) {
                    EditExerciseView(exercise: exercise)
                        .environment(\.managedObjectContext, self.viewContext)
                }
            )
        }
}

//struct ExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create a mock managed object context
//        let context = PersistenceController.preview.container.viewContext
//        
//        // Create a mock Exercise entity
//        let exercise = Exercise(context: context)
//        exercise.name = "Mock Name"
//        exercise.type = "Cardio"
//        exercise.detail = "This is for additional stuff"
//
//        // Return the ExerciseView with the mock exercise
//        return ExerciseView(exercise: exercise)
//            .environment(\.managedObjectContext, context)
//    }
//}
