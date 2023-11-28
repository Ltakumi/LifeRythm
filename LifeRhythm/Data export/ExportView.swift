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

            Button("Export locations") {
                let locationData = exportLocationsToJsonData()
                currentFilename = "locations.json"
                exportJsonData(jsonData: locationData, filename: currentFilename)
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
    
    private func fetchLocations() -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        do {
            let locations = try viewContext.fetch(fetchRequest)
            return locations
        } catch {
            print("Error fetching locations: \(error)")
            return []
        }
    }
    
    func exportLocationsToJsonData() -> Data {
        let locations = fetchLocations()
        let exportableLocations = convertToExportable(locations: locations)
        return encodeToJson(locations: exportableLocations) ?? Data()
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
