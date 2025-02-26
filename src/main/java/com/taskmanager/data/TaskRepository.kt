import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.util.UUID

class TaskRepository(private val taskDao: TaskDao) {
    val tasks: Flow<List<Task>> = taskDao.getAllTasks().map { entities ->
        entities.map { it.toTask() }
    }

    suspend fun createTask(title: String, description: String, dueDate: Long, priority: Priority): Task {
        val task = Task(
            id = UUID.randomUUID().toString(),
            title = title,
            description = description,
            dueDate = dueDate,
            priority = priority
        )
        taskDao.insertTask(task.toEntity())
        return task
    }

    suspend fun updateTask(task: Task) {
        taskDao.updateTask(task.toEntity())
    }

    suspend fun deleteTask(task: Task) {
        taskDao.deleteTask(task.toEntity())
    }

    suspend fun getTask(taskId: String): Task? {
        return taskDao.getTaskById(taskId)?.toTask()
    }
} 