import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_manager_app/shared/utils/platform_utils.dart';
import '../../../../shared/utils/ui_constants.dart';

class TimePickerRow extends StatelessWidget {
  final int hour;
  final int minute;
  final bool isAM;
  final Function(int) onHourChanged;
  final Function(int) onMinuteChanged;
  final Function(bool) onAMPMChanged;

  const TimePickerRow({
    Key? key,
    required this.hour,
    required this.minute,
    required this.isAM,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onAMPMChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isIOS = isCupertinoCustom(context);

    if (isIOS) {
      return Row(
        children: [
          // Hour picker
          GestureDetector(
            onTap: () => _showIosHourPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                hour.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Text(
            ' : ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Minute picker
          GestureDetector(
            onTap: () => _showIosMinutePicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                minute.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // AM/PM toggle
          GestureDetector(
            onTap: () => onAMPMChanged(!isAM),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                isAM ? 'AM' : 'PM',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          GestureDetector(
            onTap: () => _showAndroidTimePicker(context),
            child: Container(
              padding: UiConstants.timePickerPadding,
              decoration: BoxDecoration(
                color: UiConstants.timePickerBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isAM ? 'AM' : 'PM',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  void _showIosHourPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    onHourChanged(index + 1);
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: hour - 1,
                  ),
                  children: List<Widget>.generate(12, (int index) {
                    return Center(
                      child: Text(
                        '${index + 1}'.padLeft(2, '0'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showIosMinutePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    onMinuteChanged(index);
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: minute,
                  ),
                  children: List<Widget>.generate(60, (int index) {
                    return Center(
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAndroidTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: isAM ? hour : hour + 12, minute: minute),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    ).then((time) {
      if (time != null) {
        final newHour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
        final newIsAM = time.period == DayPeriod.am;

        onHourChanged(newHour);
        onMinuteChanged(time.minute);
        onAMPMChanged(newIsAM);
      }
    });
  }
}
