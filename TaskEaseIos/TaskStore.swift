import SwiftUI
import SwiftData

@Model
final class TaskEntity {
    var id: UUID
    var title: String
    var taskDescription: String
    var dueDate: Date?
    var isCompleted: Bool
    var priority: String
    var createdAt: Date
    var updatedAt: Date
    var userId: String?
    var syncStatus: SyncStatus
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        priority: Task.TaskPriority = .medium,
        userId: String? = nil
    ) {
        self.id = id
        self.title = title
        self.taskDescription = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.priority = priority.rawValue
        self.createdAt = Date()
        self.updatedAt = Date()
        self.userId = userId
        self.syncStatus = .notSynced
    }
    
    enum SyncStatus: String, Codable {
        case synced
        case notSynced
        case deleted
    }
}

extension TaskEntity {
    var toTask: Task {
        Task(
            id: id,
            title: title,
            description: taskDescription,
            dueDate: dueDate,
            isCompleted: isCompleted,
            priority: Task.TaskPriority(rawValue: priority) ?? .medium,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
} 