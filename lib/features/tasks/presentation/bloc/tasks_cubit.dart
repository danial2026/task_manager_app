import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/task.dart';
import '../controllers/firestore_controller.dart';

enum TasksStatus { initial, loading, success, error }

class TasksState {
  final List<Task> tasks;
  final TasksStatus status;
  final String? errorMessage;

  const TasksState({
    this.tasks = const [],
    this.status = TasksStatus.initial,
    this.errorMessage,
  });

  TasksState copyWith({
    List<Task>? tasks,
    TasksStatus? status,
    String? errorMessage,
  }) =>
      TasksState(
        tasks: tasks ?? this.tasks,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksState());

  Future<void> loadTasks() async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      final tasks = await TaskController.fetchTasks();
      emit(state.copyWith(
        status: TasksStatus.success,
        tasks: tasks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TasksStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> addTask(String title, String description, {DateTime? dueDate}) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      final task = await TaskController.addTask(title, description, dueDate: dueDate);
      if (task != null) {
        final updatedTasks = [...state.tasks, task];
        emit(state.copyWith(
          status: TasksStatus.success,
          tasks: updatedTasks,
        ));
      } else {
        emit(state.copyWith(
          status: TasksStatus.error,
          errorMessage: "Failed to add task",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TasksStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      final taskIndex = state.tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return;

      final updatedTask = state.tasks[taskIndex].copyWith(
        status: state.tasks[taskIndex].status == TaskStatus.pending ? TaskStatus.completed : TaskStatus.pending,
      );
      final updatedTasks = List<Task>.from(state.tasks);
      updatedTasks[taskIndex] = updatedTask;

      final success = await TaskController.updateTaskStatus(taskId, updatedTask.status);
      if (success) {
        emit(state.copyWith(tasks: updatedTasks, status: TasksStatus.success));
      } else {
        emit(state.copyWith(
          status: TasksStatus.error,
          errorMessage: "Failed to update task status",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TasksStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> deleteTask(String taskId) async {
    final updatedTasks = state.tasks.where((task) => task.id != taskId).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }
}
