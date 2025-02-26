import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController

sealed class Screen(val route: String) {
    object TaskList : Screen("taskList")
    object TaskDetail : Screen("taskDetail/{taskId}") {
        fun createRoute(taskId: String) = "taskDetail/$taskId"
    }
    object CreateTask : Screen("createTask")
}

@Composable
fun TaskNavigation(
    navController: NavHostController = rememberNavController(),
    viewModel: TaskViewModel
) {
    NavHost(navController = navController, startDestination = Screen.TaskList.route) {
        composable(Screen.TaskList.route) {
            TaskListScreen(
                viewModel = viewModel,
                onTaskClick = { task ->
                    navController.navigate(Screen.TaskDetail.createRoute(task.id))
                },
                onCreateClick = {
                    navController.navigate(Screen.CreateTask.route)
                }
            )
        }

        composable(Screen.TaskDetail.route) {
            TaskDetailScreen(
                viewModel = viewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.CreateTask.route) {
            CreateTaskScreen(
                viewModel = viewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }
    }
} 