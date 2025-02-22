import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TaskViewModel()
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority = Task.TaskPriority.medium
    @State private var dueDate: Date = Date()
    @State private var hasDueDate = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        Text("Low").tag(Task.TaskPriority.low)
                        Text("Medium").tag(Task.TaskPriority.medium)
                        Text("High").tag(Task.TaskPriority.high)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Due Date")) {
                    Toggle("Set Due Date", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                    }
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addTask() {
        let task = Task(
            title: title,
            description: description,
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority
        )
        
        Task {
            await viewModel.addTask(task)
            dismiss()
        }
    }
} 