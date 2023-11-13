import SwiftUI
import CoreData

struct ClimbSessionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var session: Session

    @State private var additional: String = ""
    @State private var start_time: Date?
    @State private var end_time: Date?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedClimbID: String = ""
    @State private var climbs: [Climb] = []
    
    // Add FetchRequest for Attempts
    @FetchRequest var attempts: FetchedResults<Attempt>
    init(session: Session) {
        self.session = session
        self._attempts = FetchRequest<Attempt>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Attempt.timestamp, ascending: false)],  // Sort by timestamp, latest first
            predicate: NSPredicate(format: "inSession == %@", session)  // Filter by the current session
        )
    }
    
    var body: some View {
        Form {
            // Top Section
            Section(header: Text("Session Info")) {
                HStack{
                    Button(action: {start_time = Date()}) {
                        Text("Start")
                    }
                    Spacer()
                    Text(DateUtils.formatTimestamp(start_time))
                }
                HStack{
                    Button(action: {end_time = Date()}) {
                        Text("End")
                    }
                    Spacer()
                    Text(DateUtils.formatTimestamp(end_time))
                }
                TextField("Additional Info", text: $additional)
                Button("Record Session") {
                    if validateSessionTimes() {
                        recordSession()
                    } else {
                        showAlert = true
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }

            // Middle Section
            Section(header: Text("Record Attempt")) {
                Picker("Select Climb", selection: $selectedClimbID) {
                    Text("None").tag(UUID?.none)
                    ForEach(climbs, id: \.id) { climb in
                        Text(climb.id ?? "Unknown ID").tag(climb.id ?? "")
                    }
                }
                
                HStack {
                    Button(action: { recordAttempt(outcome: "Send") }) {
                        Text("Send")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()

                    Button(action: { recordAttempt(outcome: "Progress") }) {
                        Text("Progress")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    Spacer()

                    Button(action: { recordAttempt(outcome: "No Progress") }) {
                        Text("No Progress")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                .frame(maxWidth: .infinity)
                }
            }

            // Bottom Section
            Section(header: Text("Previous Attempts")) {
                List {
                        ForEach(attempts, id: \.self) { attempt in
                            Text(attempt.formatAttempt())
                                .foregroundColor(attempt.outcomeColor)
                        }
                        .onDelete(perform: deleteAttempt)
                    }
            }
        }
        .onAppear {
            self.additional = session.additional ?? ""
            self.climbs = self.fetchClimbs()
        }
    }

    private func recordAttempt(outcome: String) {
        print(outcome)
        let newAttempt = Attempt(context: viewContext)
        newAttempt.id = UUID()
        newAttempt.timestamp = Date()
        newAttempt.outcome = outcome
        newAttempt.inSession = session
        newAttempt.idClimb = climbs.first {$0.id == selectedClimbID}

        do {
            try viewContext.save()
        } catch {
            print("Error saving attempt: \(error)")
        }
    }
    
    private func deleteAttempt(at offsets: IndexSet) {
        for index in offsets {
            let attempt = attempts[index]
            viewContext.delete(attempt)
        }

        do {
            try viewContext.save()
        } catch {
            print("Error deleting attempt: \(error)")
        }
    }
    
    private func validateSessionTimes() -> Bool {
        if start_time == nil || end_time == nil {
            alertMessage = "Both start and end times must be set."
            return false
        }
        return true
    }

    private func recordSession() {
        // Implement the logic to record the session
        // Update the 'session' entity with the start and end times and any additional data
        session.start = start_time
        session.end = end_time
        session.additional = additional

        do {
            try viewContext.save()
        } catch {
            print("Error saving session: \(error)")
        }
    }

    private func fetchClimbs() -> [Climb] {
        // Get the set associated with the session
        guard let set = session.inSet else {
            print("No set found for this session")
            return []
        }

        // Get the climbs associated with the set
        if let climbs = set.containsClimb?.allObjects as? [Climb] {
            return climbs
        } else {
            print("No climbs found in this set")
            return []
        }
    }
}

struct ClimbSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext

        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        let sessions = try? context.fetch(fetchRequest)

        Group {
            if let session = sessions?.randomElement() {
                ClimbSessionView(session: session)
                    .environment(\.managedObjectContext, context)
            } else {
                Text("No sessions available for preview")
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}
