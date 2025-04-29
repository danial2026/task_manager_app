import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/shared/utils/platform_utils.dart';
import '../bloc/tasks_cubit.dart';
import '../utils/time_utils.dart';
import 'time_picker_row.dart';
import '../../../../shared/utils/ui_constants.dart';

class AddTaskForm extends StatefulWidget {
  final Function onClose;

  const AddTaskForm({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController nameController = TextEditingController();

  // Time selection values
  int hour = TimeUtils.getCurrentHour12();
  int minute = DateTime.now().minute;
  bool isAM = TimeUtils.isAM();
  bool isToday = true;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _submitTask() {
    if (nameController.text.isEmpty) return;

    // Calculate time for the task
    final now = DateTime.now();
    DateTime taskDateTime;

    // Convert to 24-hour format
    int taskHour = hour;
    if (!isAM && hour < 12) {
      taskHour += 12;
    } else if (isAM && hour == 12) {
      taskHour = 0;
    }

    if (isToday) {
      taskDateTime = DateTime(now.year, now.month, now.day, taskHour, minute);
    } else {
      taskDateTime = DateTime(now.year, now.month, now.day + 1, taskHour, minute);
    }

    context.read<TasksCubit>().addTask(
          nameController.text,
          '',
          taskDateTime,
        );
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = isCupertinoCustom(context);

    if (isIOS) {
      // iOS specific layout - exactly as seen in the screenshot
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large title at the top
          _header('Add a task'),
          const SizedBox(height: 24),
          // Name field
          Row(
            children: [
              _subHeader('Name'),
              Expanded(
                child: CupertinoTextField(
                  controller: nameController,
                  placeholder: 'Lorem ipsum dolor',
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Hour selector
          Row(
            children: [
              _subHeader('Hour'),
              TimePickerRow(
                hour: hour,
                minute: minute,
                isAM: isAM,
                onHourChanged: (h) => setState(() => hour = h),
                onMinuteChanged: (m) => setState(() => minute = m),
                onAMPMChanged: (am) => setState(() => isAM = am),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Today toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _subHeader('Today'),
              CupertinoSwitch(
                value: isToday,
                onChanged: (value) {
                  setState(() {
                    isToday = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Done button - black button with white text
          GestureDetector(
            onTap: _submitTask,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Help text
          Text(
            'If you disable today, the task will be considered as tomorrow',
            style: UiConstants.hintTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      // Android layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large title at the top
          _header('Add a task'),
          const SizedBox(height: 24),
          // Name field
          Row(
            children: [
              _subHeader('Name'),
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Task name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Hour selector
          Row(
            children: [
              _subHeader('Hour'),
              TimePickerRow(
                hour: hour,
                minute: minute,
                isAM: isAM,
                onHourChanged: (h) => setState(() => hour = h),
                onMinuteChanged: (m) => setState(() => minute = m),
                onAMPMChanged: (am) => setState(() => isAM = am),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Today toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _subHeader('Today'),
              Switch(
                value: isToday,
                activeColor: UiConstants.activeToggleColor,
                onChanged: (value) {
                  setState(() {
                    isToday = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Add Task button
          ElevatedButton(
            onPressed: _submitTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: UiConstants.buttonColor,
              minimumSize: const Size(double.infinity, UiConstants.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiConstants.buttonBorderRadius),
              ),
            ),
            child: const Text(
              'Done',
              style: UiConstants.buttonTextStyle,
            ),
          ),
          const SizedBox(height: 16),
          // Help text
          Text(
            'If you disable today, the task will be considered as tomorrow',
            style: UiConstants.hintTextStyle,
            textAlign: TextAlign.center,
          ),
          // Bottom padding - to prevent ui from being cut off
          const SizedBox(height: 24 + 54),
        ],
      );
    }
  }

  Widget _header(String title) {
    return Text(
      title,
      style: UiConstants.headerStyle,
    );
  }

  Widget _subHeader(String title) {
    return SizedBox(
      width: 76,
      child: Text(
        title,
        style: UiConstants.subHeaderStyle,
      ),
    );
  }
}
