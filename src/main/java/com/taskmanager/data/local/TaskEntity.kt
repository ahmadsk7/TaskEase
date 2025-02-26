import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "tasks")
data class TaskEntity(
    @PrimaryKey
    val id: String,
    val title: String,
    val description: String,
    val dueDate: Long,
    val isCompleted: Boolean,
    val priority: Priority
)

fun TaskEntity.toTask() = Task(id, title, description, dueDate, isCompleted, priority)
fun Task.toEntity() = TaskEntity(id, title, description, dueDate, isCompleted, priority) 