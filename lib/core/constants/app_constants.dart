class AppConstants {
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultSpacing = 16.0;

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Validation
  static const int minPasswordLength = 6;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}
