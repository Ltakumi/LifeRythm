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
    @FetchRequest var sets: FetchedResults<Set>
    
    init(location: Location) {
        self.location = location
        self._sets = FetchRequest<Set>(
            entity: Set.entity(),
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
                        Text(location.climbType ?? "Missing type")
                    }

                    HStack {
                        Text(location.city ?? "Missing city")
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
                                Text(formatDate(set.period_start))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(formatDate(set.period_end))
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
    
    private func formatDate(_ date: Date?) -> String {
            guard let validDate = date else {
                return ""
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            return formatter.string(from: validDate)
        }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = PersistenceController.preview.container.viewContext

        // Initialize the Location entity using the mock context
        let location = Location(context: context)
        location.name = "Noborock"
        location.city = "Shibuya"
        location.locationType = "Gym"
        location.additional = "Additional description"
        
        let set = Set(context: context)
        set.period_start = Date()
        set.period_end = Calendar.current.date(byAdding: .month, value: 1, to: set.period_start!)
        set.additional = "Additional Info for Location"
        location.addToContainsSet(set)

        // Return the LocationView instance
        return LocationView(location: location).environment(\.managedObjectContext, context)
    }
}
