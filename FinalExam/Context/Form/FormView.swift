
import SwiftUI
import MapKit

struct FormView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var imagePickerPresented = false
    @StateObject private var viewModel = FormViewModel.make()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Detail")) {
                    TextField("Title", text: $viewModel.title)
                    TextEditor(text: $viewModel.description)
                    Picker("Prioritas", selection: $viewModel.selectedPriority) {
                        ForEach(viewModel.listPriorities, id: \.self) {
                            Text($0)
                        }
                    }
                    DatePicker(
                        "Deadline",
                        selection: $viewModel.deadline,
                        in: Date()...,
                        displayedComponents: .date
                    )
                }
                
                Section(header: Text("Gambar")) {
                    if viewModel.selectedImage != nil {
                        Image(uiImage: viewModel.selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                    }
                    Button("Pilih Gambar") {
                        imagePickerPresented = true
                    }
                }
                
                Section(header: Text("Lokasi"), footer: Text("Tap di map untuk menentukan lokasi")) {
                    MapView(selectedLocation: $viewModel.selectedLocation).frame(height: 200)
                }
                
                Button("Konfirmasi") {
                    viewModel.save()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding(.init(top: 6, leading: 0, bottom: 6, trailing: 0))
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            
            .sheet(isPresented: $imagePickerPresented) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
            .navigationBarTitle("Tambah Tugas", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FormView_Preview: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
