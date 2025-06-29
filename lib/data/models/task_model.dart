import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? note;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  final DateTime createdAt;

  Task({
    String? id,
    required this.title,
    this.note,
    required this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? title,
    String? note,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
