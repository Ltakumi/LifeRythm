//
//  SessionView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/13.
//

import SwiftUI

struct SessionView: View {
    var session: Session  // Assume Session is a Core Data entity or a struct

    var body: some View {
        Group {
            if session.type == "climbing" {
                ClimbSessionView(session: session)
            } else if session.type == "workout" {
                WorkoutSessionView(session: session)
            } else {
                Text("Session type not recognized")
            }
        }
    }
}

//struct SessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Mock Session object for preview
//        let mockSession = Session()
//        mockSession.type = "climbing"
//
//        return SessionView(session: mockSession)
//    }
//}
