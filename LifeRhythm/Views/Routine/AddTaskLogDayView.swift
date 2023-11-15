//
//  AddTaskLogDayView.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/16.
//

import SwiftUI

struct AddTaskLogDayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var date = Date()
    @State private var additional = ""
    @State private var taskAdditional = ""

    var body: some View {
        Form {
            Section(header: Text("Task Log Day Details")) {
                DatePicker("Date", selection: $date)
                TextField("Additional", text: $additional)
                TextField("Task Additional", text: $taskAdditional)
            }
            
            Button(action: {
                saveTaskLogDay()
            }) {
                Text("Save Task Log Day")
            }
        }
        .navigationBarTitle("Add Task Log Day")
    }

    private func saveTaskLogDay() {
        withAnimation {
            let newTaskLogDay = TaskLogDay(context: viewContext)
            newTaskLogDay.date = date
            newTaskLogDay.additional = additional
            newTaskLogDay.taskAdditional = taskAdditional
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    AddTaskLogDayView()
}
