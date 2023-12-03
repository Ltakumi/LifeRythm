import SwiftUI
import CoreData

struct ClimbSessionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var session: Session

    @State private var additional: String = ""
    @State private var start_time: Date
    @State private var end_time: Date
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedClimbID: String = ""
    @State private var climbs: [Climb] = []
    
    @State private var selectedLevel: String = "All Levels"
    @State private var levels: [String] = []
    
    // Add FetchRequest for Attempts
    @FetchRequest var attempts: FetchedResults<Attempt>
    init(session: Session) {
        self.session = session
        self._attempts = FetchRequest<Attempt>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Attempt.timestamp, ascending: false)],  // Sort by timestamp, latest first
            predicate: NSPredicate(format: "inSession == %@", session)  // Filter by the current session
        )
        self._start_time = State(initialValue: session.start ?? Date())
        self._end_time = State(initialValue: session.end ?? Date())
    }
    
    var body: some View {
        Form {
            // Top Section
            Section(header: Text("Session Info")) {
                HStack {
                    DatePicker("Start", selection: $start_time, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                }

                HStack {
                    DatePicker("End", selection: $end_time, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
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
                HStack {
                    Picker("Level", selection: $selectedLevel) {
                        Text("All Levels").tag("All Levels")
                        ForEach(levels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }

                    Picker("Climb", selection: $selectedClimbID) {
                        ForEach(filteredClimbs(), id: \.id) { climb in
                            Text(climb.name ?? "Unknown Climb").tag(climb.name ?? "")
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Button(action: { recordAttempt(outcome: "No start") }) {
                            Text("No Start")
                                .buttonStyle(backgroundColor: Color.customPink)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: { recordAttempt(outcome: "Practice") }) {
                            Text("Practice")
                                .buttonStyle(backgroundColor: Color.lightPink)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: { recordAttempt(outcome: "Few moves") }) {
                            Text("Few moves")
                                .buttonStyle(backgroundColor: Color.palePink)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .frame(maxWidth: .infinity)

                    HStack {
                        Button(action: { recordAttempt(outcome: "Most moves") }) {
                            Text("Most moves")
                                .buttonStyle(backgroundColor: Color.lightTeal)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: { recordAttempt(outcome: "Very close") }) {
                            Text("Very close")
                                .buttonStyle(backgroundColor: Color.mediumTeal)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: { recordAttempt(outcome: "Send") }) {
                            Text("Send")
                                .buttonStyle(backgroundColor: Color.darkTeal)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
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
            self.levels = extractLevels(from: climbs)
        }
    }
    
    private func filteredClimbs() -> [Climb] {
            selectedLevel == "All Levels" ? climbs : climbs.filter { $0.grade == selectedLevel }
    }
    
    private func extractLevels(from climbs: [Climb]) -> [String] {
            var uniqueLevels = Set(climbs.compactMap { $0.grade })
            uniqueLevels.insert("All Levels")
            return Array(uniqueLevels).sorted()
    }

    private func recordAttempt(outcome: String) {
        print(outcome)
        let newAttempt = Attempt(context: viewContext)
        newAttempt.id = UUID()
        newAttempt.timestamp = Date()
        newAttempt.outcome = outcome
        newAttempt.inSession = session
        newAttempt.idClimb = climbs.first {$0.name == selectedClimbID}

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

extension Text {
    func buttonStyle(backgroundColor: Color) -> some View {
        self
            .font(.headline.weight(.bold))
            .foregroundColor(.white)
            .frame(minWidth: 100, idealWidth: 150, maxWidth: .infinity, minHeight: 40)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.1), Color.clear]), startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
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
