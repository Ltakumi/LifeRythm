import SwiftUI
import MobileCoreServices
import CoreData

struct ExportView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var documentPickerPresented = false
    @State private var currentFilename: String = ""

    var body: some View {
        VStack {
            Button("Export to JSON") {
                let mockJsonData = JsonUtils.mockJsonData()
                currentFilename = "mockdata.json"
                exportJsonData(jsonData: mockJsonData, filename: currentFilename)
            }

            Button("Export Sports") {
                let sportData = exportSportDataToJsonData()
                currentFilename = "sports.json"
                exportJsonData(jsonData: sportData, filename: currentFilename)
            }
            
            Button("Export Tasks") {
                let taskData = exportTaskDataToJsonData()
                currentFilename = "tasks.json"
                exportJsonData(jsonData: taskData, filename: currentFilename)
            }
            
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Export Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $documentPickerPresented) {
            DocumentPicker(document: .constant(Data()), filename: $currentFilename, onPick: handlePickedDocument)
        }
    }

    private func exportJsonData(jsonData: Data, filename: String) {
        
        // Create a file URL for `locations.json` in the temporary directory
        let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)

        do {
            // Write the JSON data to the file
            try jsonData.write(to: tempFileURL)
            // Present the document picker to the user with the new file
            documentPickerPresented = true
        } catch {
            self.alertMessage = "Failed to write JSON data to file: \(error.localizedDescription)"
            self.showingAlert = true
        }
    }

    private func fetchEntities<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching entities: \(error)")
            return []
        }
    }
    
    func exportSportDataToJsonData() -> Data {
        
        let locations = fetchEntities(Location.fetchRequest())
        let climbSets = fetchEntities(ClimbSet.fetchRequest())
        let exercises = fetchEntities(Exercise.fetchRequest())
        let climbs = fetchEntities(Climb.fetchRequest())
        let sessions = fetchEntities(Session.fetchRequest())
        let exerciseLogs = fetchEntities(ExerciseLog.fetchRequest())
        let attempts = fetchEntities(Attempt.fetchRequest())
        
        let sportData = createCombinedSportData(locations: locations, climbSets: climbSets, exercises: exercises, climbs: climbs, sessions: sessions, exerciseLogs: exerciseLogs, attempts:attempts)

        return sportData
    }
    
    func exportTaskDataToJsonData() -> Data {
        
        let tasks = fetchEntities(Task.fetchRequest())
        let taskdays = fetchEntities(TaskDay.fetchRequest())
        
        let taskData = createCombinedTaskData(tasks: tasks, taskDays: taskdays)

        return taskData
    }

    private func handlePickedDocument(url: URL) {
        // Perform any action after the document is picked, if necessary
        self.alertMessage = "Export successful."
        self.showingAlert = true
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var document: Data
    @Binding var filename: String
    var onPick: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, onPick: onPick)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        let picker = UIDocumentPickerViewController(forExporting: [tempFileURL], asCopy: true) // asCopy should be true if you want the user to export a copy
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // Not needed for this implementation
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        var onPick: (URL) -> Void

        init(_ picker: DocumentPicker, onPick: @escaping (URL) -> Void) {
            self.parent = picker
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPick(url)
        }
    }
}

#Preview {
    ExportView()
}
