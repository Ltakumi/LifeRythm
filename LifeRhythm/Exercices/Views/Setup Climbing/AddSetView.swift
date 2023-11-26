import SwiftUI

struct AddSetView: View {
    let location: Location
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var periodStart: Date = Date()
    @State private var periodEnd: Date = Date()
    @State private var additional: String = ""
    @State private var name: String = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header : Text("Set details")) {
                    if location.locationType == "Gym" {
                        DatePicker("Period Start", selection: $periodStart, displayedComponents: .date)
                        DatePicker("Period End", selection: $periodEnd, displayedComponents: .date)
                    }
                    TextField("Name", text: $name)
                    TextField("Additional", text: $additional)
                }

                Button("Add") {
                    if location.locationType == "Gym" && periodEnd <= periodStart {
                        showingAlert = true
                    } else {
                        addSet()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Invalid Dates"),
                        message: Text("Period End must be after Period Start."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationBarTitle("Add Set", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func addSet() {
        let newSet = ClimbSet(context: viewContext)
        newSet.id = UUID()
        newSet.name = name
        newSet.additional = additional
        if location.locationType == "Gym" {
            newSet.period_start = periodStart
            newSet.period_end = periodEnd
        }
        newSet.inLocation = location

        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

struct AddSetView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = PersistenceController.preview.container.viewContext

        // Create a mock Location entity
        let mockLocation = Location(context: context)
        mockLocation.name = "Mock Location"
        mockLocation.address = "Mock City"
        mockLocation.locationType = "Gym"

        // Return the AddSetView instance
        return AddSetView(location: mockLocation).environment(\.managedObjectContext, context)
    }
}
