//
//  SetView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/11.
//

import SwiftUI

struct SetView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingAddSetView = false

    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SetView()
}
