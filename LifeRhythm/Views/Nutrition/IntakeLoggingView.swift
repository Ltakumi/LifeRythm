import SwiftUI

struct IntakeLoggingView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: DailyIntake.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyIntake.date, ascending: false)]
    ) var dailyIntakes: FetchedResults<DailyIntake>

    @State private var showingAddDailyIntakeView = false

    var body: some View {
        List(dailyIntakes, id: \.self) { intake in
            NavigationLink(destination: DailyIntakeView(dailyIntake: intake)) {
                Text(intake.formattedDate)
            }
        }
        .navigationTitle("Daily Intake")
        .navigationBarItems(trailing: Button(action: {
            showingAddDailyIntakeView = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingAddDailyIntakeView) {
            AddDailyIntakeView()
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
}



// Preview
struct IntakeLoggingView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeLoggingView()
    }
}


#Preview {
    IntakeLoggingView()
}
