
import Foundation
import Combine
import SwiftUI

final class FormViewModel: ObservableObject {

    @Published var title = ""
    @Published var description = ""
    @Published var selectedPriority = Assignment.Priority.high.rawValue
    @Published var selectedImage: UIImage?
    @Published var deadline = Date()
    @Published var selectedLocation = Assignment.Location(
        lat: -6.201694491617053,
        long: 106.78215813965815
    )
    @Published var listPriorities = [
        Assignment.Priority.high.rawValue,
        Assignment.Priority.medium.rawValue,
        Assignment.Priority.low.rawValue
    ]
    
    private var cancellables = Set<AnyCancellable>()
    private let assignmentProvider: AssignmentProvider
    
    init(
        assignmentProvider: AssignmentProvider
    ) {
        self.assignmentProvider = assignmentProvider
    }
    
    func save() {
        let image = selectedImage ?? UIImage(named: "assignmentDefaultImage")!
        let newAssignment = Assignment(
            title: title,
            description: description,
            priority: .init(rawValue: selectedPriority)!,
            image: image.pngData()!,
            location: selectedLocation,
            createdAt: Date(),
            deadline: deadline
        )
        assignmentProvider.add(newAssignment)
    }
}

private extension String {
    var isNotEmpty: Bool {
        !isEmpty
    }
}

extension FormViewModel {
    static func make() -> FormViewModel {
        .init(assignmentProvider: .make())
    }
}

