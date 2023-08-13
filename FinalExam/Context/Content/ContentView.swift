
import SwiftUI

struct ContentView: View {
    typealias Priority = Assignment.Priority
    
    @State private var formViewPresented = false
    @StateObject private var viewModel = ContentViewModel.make()
    
    var body: some View {
        NavigationStack {
            List(viewModel.assignments, id: \.self) { data in
                NavigationLink {
                    DetailView(assignment: data)
                } label: {
                    HStack(spacing: 6) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(data.title).font(.headline)
                            Text(data.description).font(.subheadline)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Prio: \(data.priority.rawValue)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Text("Deadline: \(data.deadline.toHumanReadable())")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        VStack {
                            Image(uiImage: UIImage(data: data.image)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                            
                        }
                        
                    }
                }
            }
            
            .navigationTitle("List Tugas")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        formViewPresented = true
                    } label: {
                        Text("Tambah")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Semua", action: { viewModel.filter(nil) })
                        Button(Priority.high.rawValue, action: { viewModel.filter(.high) })
                        Button(Priority.medium.rawValue, action: { viewModel.filter(.medium) })
                        Button(Priority.low.rawValue, action: { viewModel.filter(.low) })
                    } label: {
                        Text("Filter Prioritas")
                    }
                }
            }
        }
        .sheet(
            isPresented: $formViewPresented,
            onDismiss: { viewModel.loadAssignment() }
        ) {
            FormView()
        }
        .searchable(text: $viewModel.searchText)
     
        .onAppear {
            viewModel.loadAssignment()
        }
        .refreshable {
            viewModel.loadAssignment()
        }

        
    }
}

extension Date {
    func toHumanReadable() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
