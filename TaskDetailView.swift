import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TaskViewModel()
    @State private var task: Task
    @State private var isEditing = false
    
    init(task: Task) {
        _task = State(initialValue: task)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                if isEditing {
                    TextField("Title", text: $task.title)
                    TextEditor(text: $task.description)
                        .frame(height: 100)
                } else {
                    Text(task.title)
                    Text(task.description)
                }
            }
            
            Section(header: Text("Status")) {
                Toggle("Completed", isOn: $task.isCompleted)
                    .onChange(of: task.isCompleted) { _ in
                        Task {
                            await viewModel.updateTask(task)
                        }
                    }
            }
            
            if let dueDate = task.dueDate {
                Section(header: Text("Due Date")) {
                    Text(dueDate, style: .date)
                }
            }
        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        Task {
                            await viewModel.updateTask(task)
                        }
                    }
                    isEditing.toggle()
                }
            }
        }
    }
} 