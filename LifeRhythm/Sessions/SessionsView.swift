//
//  SessionsView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/12.
//

import SwiftUI

struct SessionsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.start, ascending: false)],
        animation: .default)
    private var sessions: FetchedResults<Session>

    @State private var showingAddSessionView = false

    var body: some View {
        NavigationView {
            List(sessions, id: \.self) { session in
                NavigationLink(destination: SessionView(session: session)) {
                    Text(session.sessionInfo())
                }
            }
            .navigationTitle("Sessions")
            .navigationBarItems(trailing: Button(action: {
                showingAddSessionView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddSessionView) {
                AddSessionView().environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

struct SessionsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return SessionsView().environment(\.managedObjectContext, context)
    }
}

