import SwiftUI
import CoreData

struct AddExerciseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var type: String

    @State private var name: String = ""
    @State private var detail: String = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Detail", text: $detail)
                }

                Section {
                    Button("Add") {
                        addExercise()
                    }
                }
            }
            .navigationBarTitle("Add \(type.capitalized) Exercise", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Name cannot be empty"), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func addExercise() {
        guard !name.isEmpty else {
            showAlert = true
            return
        }

        let newExercise = Exercise(context: viewContext)
        newExercise.id = UUID()
        newExercise.name = name
        newExercise.type = type
        newExercise.detail = detail

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(type: "cardio").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
