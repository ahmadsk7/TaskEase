import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.stateIn

class TaskViewModel(
    private val repository: TaskRepository
) : ViewModel() {
    val tasks = repository.tasks.stateIn(
        viewModelScope,
        SharingStarted.WhileSubscribed(5000),
        emptyList()
    )

    private val _selectedTask = MutableStateFlow<Task?>(null)
    val selectedTask: StateFlow<Task?> = _selectedTask

    private val _uiState = MutableStateFlow<UiState>(UiState.Success)
    val uiState: StateFlow<UiState> = _uiState

    fun createTask(title: String, description: String, dueDate: Long, priority: Priority) {
        viewModelScope.launch {
            try {
                _uiState.value = UiState.Loading
                repository.createTask(title, description, dueDate, priority)
                _uiState.value = UiState.Success
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "Unknown error")
            }
        }
    }

    fun updateTask(task: Task) {
        viewModelScope.launch {
            try {
                _uiState.value = UiState.Loading
                repository.updateTask(task)
                _uiState.value = UiState.Success
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "Unknown error")
            }
        }
    }

    fun selectTask(task: Task) {
        _selectedTask.value = task
    }

    sealed class UiState {
        object Success : UiState()
        object Loading : UiState()
        data class Error(val message: String) : UiState()
    }
} 