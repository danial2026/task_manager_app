import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/shared/utils/platform_utils.dart';
import '../../domain/models/task.dart';
import '../bloc/tasks_cubit.dart';
import '../utils/time_utils.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final bool isToday;

  const TaskItem({
    super.key,
    required this.task,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          context.read<TasksCubit>().toggleTaskCompletion(task.id);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isToday) _buildCheckbox(context) else _buildDot(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: task.isCompleted ? Colors.grey : Colors.black,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    TimeUtils.formatTime12Hour(task.createdAt),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    final bool isIOS = isCupertinoCustom(context);

    if (isIOS) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: task.isCompleted ? null : Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
          color: task.isCompleted ? Colors.black : Colors.transparent,
        ),
        child: task.isCompleted
            ? const Icon(
                CupertinoIcons.check_mark,
                size: 16,
                color: Colors.white,
              )
            : null,
      );
    } else {
      return SizedBox(
        width: 24,
        height: 24,
        child: Checkbox(
          value: task.isCompleted,
          activeColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onChanged: (_) {
            // NOTE: This won't be called directly since the parent is handling the tap
          },
        ),
      );
    }
  }

  Widget _buildDot() {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      ),
    );
  }
}
