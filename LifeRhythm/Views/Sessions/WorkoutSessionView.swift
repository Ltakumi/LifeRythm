import SwiftUI
import CoreData

struct WorkoutSessionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var session: Session
    
    @State private var additional: String = ""
    @State private var start_time: Date?
    @State private var end_time: Date?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedExerciseID: String = ""
    @State private var exercises: [Exercise] = []
    @State private var effort: String = ""
    @State private var repetitions: String = ""
    @State private var rest: String = ""
        
    // Add FetchRequest for ExerciceLogs
    @FetchRequest var exerciselogs: FetchedResults<ExerciseLog>
    init(session: Session) {
        self.session = session
        self._exerciselogs = FetchRequest<ExerciseLog>(
            sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseLog.timestamp, ascending: false)],  // Sort by timestamp, latest first
            predicate: NSPredicate(format: "inSession == %@", session)  // Filter by the current session
        )
    }
    
    var body: some View {
        Form {
            
            // Top section
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
            Section(header: Text("Record Exercise")) {
                Picker("Select Exercise", selection: $selectedExerciseID) {
                    ForEach(exercises, id: \.id) { exercise in
                        Text(exercise.id ?? "Unknown").tag(exercise.id ?? "")
                    }
                }
                TextField("Effort", text: $effort)
                TextField("Repetitions", text: $repetitions)
                TextField("Rest", text: $rest)
                Button("Add Exercise Log") {
                    addExerciseLog()
                }
            }
            
            // bottom Section
            Section(header: Text("Previous Exercices")) {
                List(exerciselogs, id: \.self) { exerciselog in
                    Text(exerciselog.formatExercise())
                }
            }
        }
        .onAppear {
            self.additional = session.additional ?? ""
            self.exercises = self.fetchExercises()
        }
    }
    
    private func addExerciseLog() {
        let newLog = ExerciseLog(context: viewContext)
        newLog.id = UUID()
        newLog.timestamp = Date()
        newLog.effort = effort
        newLog.rep = repetitions
        newLog.rest = rest
        newLog.inSession = session
        newLog.idExercise = exercises.first {$0.id == selectedExerciseID}
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving exercise log: \(error)")
        }
    }
    
    private func fetchExercises() -> [Exercise] {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching exercises: \(error)")
            return []
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
        session.start = start_time
        session.end = end_time
        session.additional = additional
        do {
            try viewContext.save()
        } catch {
            print("Error saving session: \(error)")
        }
    }
}

struct WorkoutSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext

        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        let sessions = try? context.fetch(fetchRequest)

        Group {
            if let session = sessions?.randomElement() {
                WorkoutSessionView(session: session)
                    .environment(\.managedObjectContext, context)
            } else {
                Text("No sessions available for preview")
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}
