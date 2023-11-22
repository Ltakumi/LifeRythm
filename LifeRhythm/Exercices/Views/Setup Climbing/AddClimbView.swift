import SwiftUI

struct AddClimbView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    let set: Set

    @State private var grade: String = ""
    @State private var name: String = ""
    @State private var tags: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    private var gradeChoices: [String] {
        get {
            return set.inLocation?.climbType == "Boulder" ? ["4kyu", "3kyu", "2kyu", "1kyu", "Shodan", "Nidan"] : ["5.11a", "5.11b", "5.11c", "5.11d", "5.12a"]
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Grade", selection: $grade) {
                        ForEach(gradeChoices, id: \.self) { gradeChoice in
                            Text(gradeChoice).tag(gradeChoice)
                        }
                    }

                    TextField("Name", text: $name)
                    TextField("Tags (separated by commas)", text: $tags)
                }

                Button("Add") {
                    if validateFields() {
                        addClimb()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showAlert = true
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Add Boulder", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func validateFields() -> Bool {
        if grade.isEmpty || name.isEmpty || tags.isEmpty {
            alertMessage = "All fields must be filled in."
            return false
        }
        if climbWithIDExists(name) {
            alertMessage = "A boulder with this ID already exists."
            return false
        }
        return true
    }

    private func climbWithIDExists(_ id: String) -> Bool {
        let request = Climb.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", id)
        let results = (try? viewContext.fetch(request)) ?? []
        return !results.isEmpty
    }

    private func addClimb() {
        let newClimb = Climb(context: viewContext)
        newClimb.id = UUID()
        newClimb.grade = grade
        newClimb.name = name
        newClimb.tags = tags
        newClimb.inSet = set

        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

struct AddClimbView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = PersistenceController.preview.container.viewContext
        
        let location = Location(context: context)
        location.name = "Noborock"
        location.address = "Shibuya"
        location.locationType = "Gym"
        location.climbType = "Boulder"
        location.additional = "Additional description"
        
        let set = Set(context: context)
        set.period_start = Date()
        set.period_end = Calendar.current.date(byAdding: .month, value: 1, to: set.period_start!)
        set.additional = "Additional Info for Location"
        location.addToContainsSet(set)
        
        return AddClimbView(set: set).environment(\.managedObjectContext, context)
    }
}
