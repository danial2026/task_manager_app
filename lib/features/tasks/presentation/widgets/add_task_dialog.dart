import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../bloc/tasks_cubit.dart';
import '../../../../core/constants/app_constants.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController(text: 'Title');
  final _descriptionController = TextEditingController(text: 'Description');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    return null;
  }

  void _onAddPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<TasksCubit>().addTask(
            _titleController.text,
            _descriptionController.text,
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      title: const Text('Add Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformTextFormField(
              controller: _titleController,
              validator: _validateTitle,
              textInputAction: TextInputAction.next,
              material: (_, __) => MaterialTextFormFieldData(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            PlatformTextFormField(
              controller: _descriptionController,
              validator: _validateDescription,
              textInputAction: TextInputAction.done,
              maxLines: 3,
              material: (_, __) => MaterialTextFormFieldData(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PlatformDialogAction(
          onPressed: _onAddPressed,
          cupertino: (_, __) => CupertinoDialogActionData(
            isDefaultAction: true,
          ),
          material: (_, __) => MaterialDialogActionData(
            icon: const Icon(Icons.add),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
