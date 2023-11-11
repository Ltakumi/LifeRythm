//
//  AddLocationView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/11.
//

import SwiftUI

struct AddLocationView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var locationType: String = "Boulder Gym"
    @State private var cityName: String = ""
    @State private var locationName: String = ""
    @State private var showingAlert = false


    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Location Details")) {
                        Picker("Type", selection: $locationType) {
                            Text("Boulder Gym").tag("Boulder Gym")
                            Text("Lead Gym").tag("Lead Gym")
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        TextField("City", text: $cityName)
                        TextField("Name", text: $locationName)
                    }

                    Button("Add") {
                        if cityName.isEmpty || locationName.isEmpty {
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
        newLocation.type = locationType
        newLocation.city = cityName
        newLocation.name = locationName

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
