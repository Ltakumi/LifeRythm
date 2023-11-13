import SwiftUI
import CoreData


struct ExerciseView: View {
    var exercise: Exercise

    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(exercise.id ?? "Unknown")")
            Text("Type: \(exercise.type ?? "Unknown")")
            Text("Detail: \(exercise.detail ?? "No details")")
        }
        .navigationBarTitle("Exercise Details")
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
