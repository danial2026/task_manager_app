class TimeUtils {
  /// Converts the current hour to 12-hour format
  static int getCurrentHour12() {
    final hour = DateTime.now().hour;
    if (hour > 12) {
      return hour - 12;
    } else if (hour == 0) {
      return 12;
    }
    return hour;
  }

  /// Checks if the current time is AM
  static bool isAM() {
    return DateTime.now().hour < 12;
  }

  /// Formats time in 12-hour format with AM/PM
  static String formatTime12Hour(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  /// Returns whether a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Returns whether a date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }
}
