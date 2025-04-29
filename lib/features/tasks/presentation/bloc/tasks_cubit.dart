import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/task.dart';

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
      // Generate demo tasks for today and tomorrow
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 12, 42);
      final tomorrow = DateTime(now.year, now.month, now.day + 1, 12, 42);

      final tasks = [
        // Today's tasks
        Task(
          id: '1',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 1',
          createdAt: today,
          dueDate: today,
          isCompleted: false,
        ),
        Task(
          id: '2',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 2',
          createdAt: today,
          dueDate: today,
          isCompleted: false,
        ),
        Task(
          id: '3',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 3',
          createdAt: today,
          dueDate: today,
          isCompleted: false,
        ),
        Task(
          id: '4',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 4',
          createdAt: today,
          dueDate: today,
          isCompleted: true,
        ),
        Task(
          id: '5',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 5',
          createdAt: today,
          dueDate: today,
          isCompleted: true,
        ),

        // Tomorrow's tasks
        Task(
          id: '6',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 6',
          createdAt: tomorrow,
          dueDate: tomorrow,
          isCompleted: false,
        ),
        Task(
          id: '7',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 7',
          createdAt: tomorrow,
          dueDate: tomorrow,
          isCompleted: false,
        ),
        Task(
          id: '8',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 8',
          createdAt: tomorrow,
          dueDate: tomorrow,
          isCompleted: false,
        ),
        Task(
          id: '9',
          title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          description: 'Description 9',
          createdAt: tomorrow,
          dueDate: tomorrow,
          isCompleted: false,
        ),
      ];

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

  Future<void> addTask(String title, String description, [DateTime? dueDate]) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      final now = DateTime.now();
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: now,
        dueDate: dueDate ?? now,
        isCompleted: false,
      );
      final updatedTasks = [...state.tasks, task];
      emit(state.copyWith(
        status: TasksStatus.success,
        tasks: updatedTasks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TasksStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final taskIndex = state.tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final updatedTask = state.tasks[taskIndex].copyWith(
      isCompleted: !state.tasks[taskIndex].isCompleted,
    );
    final updatedTasks = List<Task>.from(state.tasks);
    updatedTasks[taskIndex] = updatedTask;

    emit(state.copyWith(tasks: updatedTasks));
  }

  Future<void> deleteTask(String taskId) async {
    final updatedTasks = state.tasks.where((task) => task.id != taskId).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }
}
