import SwiftUI
import CoreData
import Foundation

struct AddTaskDayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var date = Date()
    @State private var additional = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Log Day Details")) {
                    DatePicker("Date", selection: $date)
                    TextField("Additional", text: $additional)
                }
                
                Button(action: saveTaskLogDay) {
                    Text("Save Task Log Day")
                }
            }
            .navigationBarTitle("Add TaskLogDay", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveTaskLogDay() {
        withAnimation {
            let newTaskDay = TaskDay(context: viewContext)
            newTaskDay.date = date
            newTaskDay.additional = additional
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
