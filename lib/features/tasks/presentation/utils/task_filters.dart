import '../../domain/models/task.dart';
import 'time_utils.dart';

class TaskFilters {
  /// Filters tasks for today that match the completed filter
  static List<Task> getTodayTasks(List<Task> tasks, bool hideCompleted) {
    return tasks.where((task) => TimeUtils.isToday(task.dueDate!) && (!hideCompleted || !task.isCompleted)).toList();
  }

  /// Filters tasks for tomorrow that match the completed filter
  static List<Task> getTomorrowTasks(List<Task> tasks, bool hideCompleted) {
    return tasks.where((task) => TimeUtils.isTomorrow(task.dueDate!) && (!hideCompleted || !task.isCompleted)).toList();
  }
}
