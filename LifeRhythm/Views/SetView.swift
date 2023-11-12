//
//  SetView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/12.
//

import SwiftUI

struct SetView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    let set: Set
    
    @FetchRequest var climbs: FetchedResults<Climb>
    
    init(set: Set) {
        self.set = set
        self._climbs = FetchRequest<Climb>(
            entity: Climb.entity(),
            sortDescriptors: [], // Add sort descriptors if needed
            predicate: NSPredicate(format: "inSet == %@", set)
        )
    }
    
    @State private var showingAddBoulderView = false
    
    var body: some View {
        List{
            Section{
                // Display Set information
                if set.inLocation?.locationType == "Gym" {
                    Text(DateUtils.formatSetDate(set.period_start))
                    Text(DateUtils.formatSetDate(set.period_end))
                }
                
                Text(set.additional ?? "No additional info")
            }
            
            Section(header: Text("Climbs")) {
                ForEach(climbs, id: \.self) { climb in
                    NavigationLink(destination: ClimbView(climb: climb)) {
                        Text(climb.id ?? "Unknown Climb")
                    }
                }
            }
        }
        .navigationTitle("Set Details")
        .navigationBarItems(
            trailing: Button(action: {
                showingAddBoulderView = true
            }) {
                Image(systemName: "plus")
            }
                .sheet(isPresented: $showingAddBoulderView) {
                    AddClimbView(set: set)
                        .environment(\.managedObjectContext, self.viewContext)
                }
        )
    }
}

struct DateUtils {
    static func formatSetDate(_ date: Date?) -> String {
        guard let validDate = date else {
            return ""  // Or return a placeholder string if you prefer
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: validDate)
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = PersistenceController.preview.container.viewContext
        
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
        
        let climb = Climb(context: context)
        climb.id = "yellow lion"
        climb.grade = "1 kyu"
        climb.inSet = set
        
        return SetView(set: set).environment(\.managedObjectContext, context)
    }
}
