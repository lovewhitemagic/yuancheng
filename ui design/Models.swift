import SwiftUI
import Foundation

struct CleaningTask: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool
    var tools: [String]
    var date: Date?
    var imageData: Data?
    var completedDate: Date?
}

struct TaskSection: Identifiable {
    let id = UUID()
    let title: String
    var tasks: [CleaningTask]
    var isExpanded: Bool
}

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    var tasks: [CleaningTask]
}

enum StockStatus {
    case sufficient, low, empty
    
    var color: Color {
        switch self {
        case .sufficient: return .green
        case .low: return .yellow
        case .empty: return .red
        }
    }
}

struct ChecklistItem: Identifiable {
    let id = UUID()
    let name: String
    let frequency: String
    let lastPurchaseDate: Date
    var stock: Int
    var price: Double
    
    var stockStatus: StockStatus {
        switch stock {
        case 3...: return .sufficient
        case 1...2: return .low
        default: return .empty
        }
    }
} 