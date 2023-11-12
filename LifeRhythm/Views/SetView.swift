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

    @State private var showingAddSetView = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = PersistenceController.preview.container.viewContext
        
        let set = Set(context: context)
        set.period_start = Date()
        set.period_end = Calendar.current.date(byAdding: .month, value: 1, to: set.period_start!)
        set.additional = "Additional Info for Location"

        // Return the LocationView instance
        return SetView(set: set).environment(\.managedObjectContext, context)
    }
}
