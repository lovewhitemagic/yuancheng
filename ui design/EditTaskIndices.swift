import Foundation

struct EditTaskIndices: Identifiable {
    let id = UUID()
    let sectionIndex: Int
    let taskIndex: Int
} 