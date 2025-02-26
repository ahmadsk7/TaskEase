import Foundation
import SwiftData

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiClient: APIClient
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext, apiClient: APIClient = APIClient.shared) {
        self.modelContext = modelContext
        self.apiClient = apiClient
    }
    
    func fetchTasks() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Fetch local tasks
            let descriptor = FetchDescriptor<TaskEntity>(
                sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
            )
            let localTasks = try modelContext.fetch(descriptor)
            tasks = localTasks.map { $0.toTask }
            
            // Fetch remote tasks if online
            if await NetworkMonitor.shared.isConnected {
                let remoteTasks = try await apiClient.fetchTasks()
                await syncTasks(remoteTasks)
            }
        } catch {
            self.error = error
        }
    }
    
    func addTask(_ task: Task) async {
        do {
            let taskEntity = TaskEntity(
                id: task.id,
                title: task.title,
                description: task.description,
                dueDate: task.dueDate,
                isCompleted: task.isCompleted,
                priority: task.priority
            )
            
            modelContext.insert(taskEntity)
            try modelContext.save()
            
            if await NetworkMonitor.shared.isConnected {
                try await apiClient.createTask(task)
                taskEntity.syncStatus = .synced
                try modelContext.save()
            }
            
            await fetchTasks()
        } catch {
            self.error = error
        }
    }
    
    func updateTask(_ task: Task) async {
        do {
            let descriptor = FetchDescriptor<TaskEntity>(
                predicate: #Predicate<TaskEntity> { $0.id == task.id }
            )
            
            guard let taskEntity = try modelContext.fetch(descriptor).first else { return }
            
            taskEntity.title = task.title
            taskEntity.taskDescription = task.description
            taskEntity.dueDate = task.dueDate
            taskEntity.isCompleted = task.isCompleted
            taskEntity.priority = task.priority.rawValue
            taskEntity.updatedAt = Date()
            taskEntity.syncStatus = .notSynced
            
            try modelContext.save()
            
            if await NetworkMonitor.shared.isConnected {
                try await apiClient.updateTask(task)
                taskEntity.syncStatus = .synced
                try modelContext.save()
            }
            
            await fetchTasks()
        } catch {
            self.error = error
        }
    }
    
    func deleteTask(_ task: Task) async {
        do {
            let descriptor = FetchDescriptor<TaskEntity>(
                predicate: #Predicate<TaskEntity> { $0.id == task.id }
            )
            
            guard let taskEntity = try modelContext.fetch(descriptor).first else { return }
            
            if await NetworkMonitor.shared.isConnected {
                try await apiClient.deleteTask(task.id)
                modelContext.delete(taskEntity)
            } else {
                taskEntity.syncStatus = .deleted
            }
            
            try modelContext.save()
            await fetchTasks()
        } catch {
            self.error = error
        }
    }
    
    private func syncTasks(_ remoteTasks: [Task]) async {
        // Implement sync logic here
        // Compare remote and local tasks
        // Update local tasks as needed
        // Handle conflicts
    }
}

#Preview {
    TaskDetailView(task: Task(title: "Sample Task", description: "This is a sample task"))
        .modelContainer(for: TaskEntity.self, inMemory: true)
} 