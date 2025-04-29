import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

void showToastification({
  required BuildContext context,
  required String message,
  ToastificationType type = ToastificationType.warning,
  Duration autoCloseDuration = const Duration(seconds: 2),
}) {
  toastification.show(
    context: context,
    title: Text(message),
    type: type,
    autoCloseDuration: autoCloseDuration,
  );
}
