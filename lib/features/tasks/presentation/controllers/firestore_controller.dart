import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../domain/task.dart';

class TaskController {
  static CollectionReference get taskCollection {
    final app = Firebase.app();
    return FirebaseFirestore.instanceFor(app: app).collection('Tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('user_tasks');
  }

  static Future<Task?> addTask(String title, String description, {DateTime? dueDate}) async {
    try {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        status: TaskStatus.pending,
        dueDate: dueDate,
      );

      await taskCollection.add(task.toJson());
      return task;
    } catch (e) {
      throw Exception("Failed to add task");
    }
  }

  static Future<List<Task>> fetchTasks() async {
    try {
      final snapshot = await taskCollection.get();
      return snapshot.docs.map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception("Failed to fetch tasks");
    }
  }

  static Future<bool> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    try {
      final querySnapshot = await taskCollection.where('id', isEqualTo: taskId).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await doc.reference.update({'status': newStatus.name});
        }
        return true;
      }
      return false;
    } catch (e) {
      throw Exception("Failed to update task status");
    }
  }
}
