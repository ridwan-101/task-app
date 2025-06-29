import 'package:hive/hive.dart';
import '../../data/models/task_model.dart';

abstract class LocalTaskDataSource {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<List<Task>> getAllTasks();
}

class LocalTaskDataSourceImpl implements LocalTaskDataSource {
  final Box<Task> taskBox;

  LocalTaskDataSourceImpl(this.taskBox);

  @override
  Future<void> addTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    return taskBox.values.toList();
  }
}
