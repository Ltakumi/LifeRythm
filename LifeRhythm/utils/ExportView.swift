import SwiftUI
import MobileCoreServices

struct ExportView: View {
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var documentPickerPresented = false

    var body: some View {
        Button("Export to JSON") {
            exportToJSON()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Export Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $documentPickerPresented) {
            DocumentPicker(document: .constant(Data()), onPick: handlePickedDocument)
        }
    }

    private func exportToJSON() {
        let jsonString = """
        {
            "locations": [
                {
                    "city": "Tokyo",
                    "neighborhood": "NeighborhoodName",
                    "phoneNumber": "1234567890"
                }
            ]
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            self.alertMessage = "Error converting JSON to Data."
            self.showingAlert = true
            return
        }

        // Create a file URL for `locations.json` in the temporary directory
        let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("locations.json")

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

    private func handlePickedDocument(url: URL) {
        // Perform any action after the document is picked, if necessary
        self.alertMessage = "Export successful."
        self.showingAlert = true
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var document: Data
    var onPick: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, onPick: onPick)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("locations.json")
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
