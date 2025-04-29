import 'package:equatable/equatable.dart';

enum TaskStatus {
  pending,
  completed,
  cancelled,
}

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final TaskStatus status;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.dueDate,
    this.status = TaskStatus.pending,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    TaskStatus? status,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        dueDate: dueDate ?? this.dueDate,
        status: status ?? this.status,
      );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        dueDate: json['due_date'] != null ? DateTime.tryParse(json['due_date'] as String) : null,
        status: TaskStatus.values.byName(json['status'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'created_at': createdAt.toIso8601String(),
        'due_date': dueDate?.toIso8601String(),
        'status': status.name,
      };

  @override
  List<Object?> get props => [id, title, description, createdAt, dueDate, status];
}
