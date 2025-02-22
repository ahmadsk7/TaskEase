import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        TaskRowView(task: task)
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await viewModel.fetchTasks()
            }
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            Task {
                await viewModel.deleteTask(viewModel.tasks[index])
            }
        }
    }
}

struct TaskRowView: View {
    let task: Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            PriorityBadge(priority: task.priority)
        }
    }
}

struct PriorityBadge: View {
    let priority: Task.TaskPriority
    
    var body: some View {
        Text(priority.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priorityColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
    
    private var priorityColor: Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
} 