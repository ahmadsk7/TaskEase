import SwiftUI
import SwiftData

@main
struct TaskManagerApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: TaskEntity.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
        .modelContainer(modelContainer)
    }
} 