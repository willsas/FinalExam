
import SwiftUI

struct DetailView: View {
    
    let assignment: Assignment
    
    var body: some View {
        ScrollView {
            VStack {
                MapView(
                    selectedLocation: .constant(assignment.location),
                    isEnableUserSelection: false
                )
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 300)

                CircleImage(data: assignment.image)
                    .offset(y: -130)
                    .padding(.bottom, -130)

                VStack(alignment: .leading) {
                    Text(assignment.title)
                        .font(.title)

                    VStack(alignment: .leading) {
                        Text("Deadline: \(assignment.deadline.toHumanReadable())")
                        Text("Prioritas: \(assignment.priority.rawValue)")
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)

                    Divider()

                    Text(assignment.description)
                        .font(.body)
                }
                .navigationTitle("Detail")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
        
    }
}

struct CircleImage: View {
    let data: Data
    
    var body: some View {
        Image(uiImage: .init(data: data)!)
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
