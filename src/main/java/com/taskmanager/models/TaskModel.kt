data class Task(
    val id: String,
    val title: String,
    val description: String,
    val dueDate: Long,
    val isCompleted: Boolean = false,
    val priority: Priority = Priority.MEDIUM
)

enum class Priority {
    LOW,
    MEDIUM,
    HIGH
} 