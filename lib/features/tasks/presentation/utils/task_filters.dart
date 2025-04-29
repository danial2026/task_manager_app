import '../../domain/task.dart';
import 'time_utils.dart';

class TaskFilters {
  /// Filters tasks for today that match the completed filter
  static List<Task> getTodayTasks(List<Task> tasks, bool hideCompleted) {
    return tasks
        .where(
            (task) => task.dueDate != null && TimeUtils.isToday(task.dueDate!) && (!hideCompleted || task.status != TaskStatus.completed))
        .toList();
  }

  /// Filters tasks for tomorrow that match the completed filter
  static List<Task> getTomorrowTasks(List<Task> tasks, bool hideCompleted) {
    return tasks
        .where((task) =>
            ((task.dueDate != null && TimeUtils.isTomorrow(task.dueDate!)) || task.dueDate == null) &&
            (!hideCompleted || task.status != TaskStatus.completed))
        .toList();
  }
}
