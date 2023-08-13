
import Foundation

struct AssignmentProvider {
    
    private let storage: UserDefaultsHelper
    
    init(
        storage: UserDefaultsHelper
    ) {
        self.storage = storage
    }
    
    func getList() -> [Assignment] {
        guard let assignments: [Assignment] = storage.retrieveArray() else { return [] }
        return assignments
    }
    
    func add(_ assignment: Assignment) {
        storage.appendArray(assignment)
    }
}

extension AssignmentProvider {
    static func make() -> AssignmentProvider {
        .init(storage: UserDefaultsHelper(key: "assignment_key"))
    }
}
