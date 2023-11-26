//
//  SetView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/11.
//

import SwiftUI

struct LocationView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    let location: Location

    @State private var showingAddSetView = false
    
    // Dynamic FetchRequest for sets
    @FetchRequest var sets: FetchedResults<ClimbSet>
    
    init(location: Location) {
        self.location = location
        self._sets = FetchRequest<ClimbSet>(
            entity: ClimbSet.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "inLocation == %@", location)
        )
    }

    var body: some View {
            List {
                Section {
                    HStack {
                        Text(location.locationType ?? "Missing type")
                    }
                    HStack {
                        Text((location.climbType ?? "Missing type") + " " + (location.locationType ?? "Missing type"))
                    }

                    HStack {
                        Text(location.address ?? "Missing address")
                    }

                    HStack {
                        Text(location.additional ?? "No additional info")
                    }
                }

                // Assuming 'containsSet' is a Set of Set entities
                Section(header: Text("Sets")) {
                    ForEach(sets, id: \.self) { set in
                        NavigationLink(destination: SetView(set: set)) {
                            HStack() {
                                Text(set.name ?? "Unnamed set")
                                Spacer()
                                Text(DateUtils.formatDate(set.period_start))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(DateUtils.formatDate(set.period_end))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text(location.name ?? "Unknown"))
            .navigationBarItems(trailing: Button(action: {
                showingAddSetView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddSetView) {
                            AddSetView(location: location)
                                .environment(\.managedObjectContext, self.viewContext)
            }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = PersistenceController.preview.container.viewContext

        // Initialize the Location entity using the mock context
        let location = Location(context: context)
        location.name = "Noborock"
        location.address = "Shibuya"
        location.locationType = "Gym"
        location.climbType = "Boulder"
        location.additional = "Additional description"
        
        let set = ClimbSet(context: context)
        set.name = "Winter"
        set.period_start = Date()
        set.period_end = Calendar.current.date(byAdding: .month, value: 1, to: set.period_start!)
        set.additional = "Additional Info for Location"
        location.addToContainsSet(set)

        // Return the LocationView instance
        return LocationView(location: location).environment(\.managedObjectContext, context)
    }
}
