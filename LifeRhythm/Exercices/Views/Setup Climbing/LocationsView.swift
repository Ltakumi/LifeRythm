import SwiftUI

struct LocationsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.name, ascending: true)],
        animation: .default)
    private var locations: FetchedResults<Location>
    
    @State private var showingAddLocationView = false

    var body: some View {
        List(locations, id: \.self) { location in
            NavigationLink(destination: LocationView(location: location)) {
                Text(location.name ?? "Unknown")
            }
        }
        .navigationTitle("Locations")
        .navigationBarItems(trailing: Button(action: {
            showingAddLocationView = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingAddLocationView) {
            AddLocationView().environment(\.managedObjectContext, self.viewContext)
        }
//        .searchable(text: $searchText) 
//        .onChange(of: searchText) { newValue in
//            locations.nsPredicate = buildPredicate()
//        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return LocationsView().environment(\.managedObjectContext, context)
    }
}
