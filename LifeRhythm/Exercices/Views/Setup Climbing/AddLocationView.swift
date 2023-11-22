import SwiftUI

struct AddLocationView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var climbType: String = "Boulder"
    @State private var locationType: String = "Gym"
    @State private var address: String = ""
    @State private var locationName: String = ""
    @State private var additional: String = ""
    @State private var showingAlert = false


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Details")) {
                    Picker("Type", selection: $climbType) {
                        Text("Boulder").tag("Boulder")
                        Text("Lead").tag("Lead")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Picker("Type", selection: $locationType) {
                        Text("Gym").tag("Gym")
                        Text("Outdoor").tag("Outdoor")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextField("address", text: $address)
                    TextField("Name", text: $locationName)
                    TextField("Additional", text:$additional)
                }

                Button("Add") {
                    if address.isEmpty || locationName.isEmpty {
                        showingAlert = true
                    } else {
                        addLocation()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text("All fields are required."), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Add Location", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func addLocation() {
        let newLocation = Location(context: viewContext)
        newLocation.id = UUID()
        newLocation.locationType = locationType
        newLocation.climbType = climbType
        newLocation.address = address
        newLocation.name = locationName
        newLocation.additional = additional

        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

#Preview {
    AddLocationView()
}
