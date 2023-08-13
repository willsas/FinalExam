
import Foundation
import Combine
import SwiftUI

final class ContentViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var assignments = [Assignment]()
    
    private var allAssignment = [Assignment]()
    private var cancellables = Set<AnyCancellable>()
    private let assignmentProvider: AssignmentProvider
    
    init(
        assignmentProvider: AssignmentProvider
    ) {
        self.assignmentProvider = assignmentProvider
        startObserveSearchText()
    }
    
    func loadAssignment() {
        allAssignment = assignmentProvider.getList()
        assignments = allAssignment
    }
    
    func filter(_ priority: Assignment.Priority?) {
        if let priority {
            assignments = allAssignment.filter { $0.priority == priority }
        } else {
            assignments = allAssignment
        }
    }
    
    private func startObserveSearchText() {
        $searchText.sink { [weak self] text in
            guard let self else { return }
            if text.isEmpty {
                assignments = allAssignment
            } else {
                assignments = allAssignment
                    .filter { $0.title.lowercased().contains(text.lowercased()) }
            }
        }
        .store(in: &cancellables)
    }
}

extension ContentViewModel {
    static func make() -> ContentViewModel {
        .init(assignmentProvider: .make())
    }
}
