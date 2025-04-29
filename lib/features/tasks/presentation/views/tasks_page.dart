import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:task_manager_app/shared/utils/platform_utils.dart';
import '../bloc/tasks_cubit.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_form.dart';
import '../utils/task_filters.dart';
import '../../../../shared/utils/ui_constants.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool _hideCompleted = false;

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().loadTasks();
  }

  void _showAddTaskDialog() {
    if (isCupertinoCustom(context)) {
      _showCupertinoAddTaskDialog();
    } else {
      _showMaterialAddTaskDialog();
    }
  }

  void _showCupertinoAddTaskDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPageScaffold(
          backgroundColor: Colors.white,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.grey[200],
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.back,
                    color: CupertinoColors.activeBlue,
                    size: 20,
                  ),
                  Text(
                    'Close',
                    style: TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              onPressed: () => Navigator.pop(context),
            ),
            middle: const Text(
              'Task',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          child: Scaffold(
            body: Padding(
              padding: UiConstants.defaultPadding,
              child: AddTaskForm(
                onClose: () => Navigator.pop(context),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMaterialAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return AnimatedPadding(
          // This animates the shift when the keyboard appears
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate,
          child: SafeArea(
            top: false,
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: UiConstants.defaultPadding,
                    child: AddTaskForm(
                      onClose: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.white,
      appBar: PlatformAppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: Text(
            FirebaseAuth.instance.currentUser?.displayName ?? '',
            style: UiConstants.subHeaderStyle,
          ),
        ),
        trailingActions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser?.photoURL ?? '',
                ),
                radius: 24,
              ),
            ),
          ),
        ],
        material: (_, __) => MaterialAppBarData(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: Colors.white,
          border: const Border(bottom: BorderSide(color: Colors.transparent)),
          automaticallyImplyLeading: false,
        ),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.status == TasksStatus.loading) {
            return Center(child: PlatformCircularProgressIndicator());
          }

          if (state.status == TasksStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'An error occurred'),
            );
          }

          // Use our task filter utility
          final todayTasks = TaskFilters.getTodayTasks(state.tasks, _hideCompleted);
          final tomorrowTasks = TaskFilters.getTomorrowTasks(state.tasks, _hideCompleted);

          return ListView(
            padding: UiConstants.horizontalPadding,
            children: [
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today',
                    style: UiConstants.headerStyle,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _hideCompleted = !_hideCompleted;
                      });
                    },
                    child: Text(
                      'Hide completed',
                      style: UiConstants.buttonTextStyle.copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              if (todayTasks.isNotEmpty) ...[
                ...todayTasks.map((task) => TaskItem(
                      task: task,
                      isToday: true,
                    )),
              ] else ...[
                const SizedBox(height: 20),
                const Center(child: Text('No tasks for today')),
              ],

              const SizedBox(height: 32),

              const Text(
                'Tomorrow',
                style: UiConstants.headerStyle,
              ),

              if (tomorrowTasks.isNotEmpty) ...[
                ...tomorrowTasks.map((task) => TaskItem(
                      task: task,
                      isToday: false,
                    )),
              ] else ...[
                const SizedBox(height: 20),
                const Center(child: Text('No tasks for tomorrow')),
              ],

              const SizedBox(height: 80), // Extra space for FAB
            ],
          );
        },
      ),
      material: (_, __) => MaterialScaffoldData(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          backgroundColor: UiConstants.buttonColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      cupertino: (_, __) => CupertinoPageScaffoldData(
        backgroundColor: Colors.white,
      ),
    );
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
