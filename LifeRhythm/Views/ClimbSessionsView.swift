//
//  SessionsView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/12.
//

import SwiftUI

struct ClimbSessionsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.start, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<Session>

    @State private var showingAddSessionView = false

    var body: some View {
        NavigationView {
            List(sessions, id: \.self) { session in
                NavigationLink(destination: ClimbSessionView(session: session)) {
                    Text(session.sessionInfo()) // Display formatted session info
                }
            }
            .navigationTitle("Sessions")
            .navigationBarItems(trailing: Button(action: {
                showingAddSessionView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddSessionView) {
                AddClimbSessionView().environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

struct ClimbSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return ClimbSessionsView().environment(\.managedObjectContext, context)
    }
}

