import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: Date?
    var isCompleted: Bool
    var priority: TaskPriority
    var createdAt: Date
    var updatedAt: Date
    
    enum TaskPriority: String, Codable {
        case low
        case medium
        case high
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        priority: TaskPriority = .medium,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
} 