
import Foundation
import SwiftUI

struct Assignment: Codable, Hashable {
    let title: String
    let description: String
    let priority: Priority
    let image: Data
    let location: Location
    let createdAt: Date
    let deadline: Date
    
    enum Priority: String, Codable, Hashable {
        case high = "Tinggi"
        case medium = "Medium"
        case low = "Rendah"
    }
    
    struct Location: Codable, Hashable {
        var lat: Double
        var long: Double
    }
}
