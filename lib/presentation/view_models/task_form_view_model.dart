import 'package:flutter/foundation.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

class TaskFormViewModel with ChangeNotifier {
  final TaskRepository repository;
  Task? _editingTask;

  TaskFormViewModel(this.repository);

  Task? get editingTask => _editingTask;

  void setEditingTask(Task? task) {
    _editingTask = task;
    notifyListeners();
  }

  Future<bool> saveTask({
    required String title,
    required DateTime dueDate,
    String? note,
    bool isCompleted = false,
  }) async {
    try {
      final task = Task(
        id: _editingTask?.id,
        title: title,
        note: note,
        dueDate: dueDate,
        isCompleted: isCompleted,
      );

      if (_editingTask != null) {
        await repository.updateTask(task);
      } else {
        await repository.addTask(task);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving task: $e');
      }
      return false;
    }
  }

  @override
  void notifyListeners() {
    if (kDebugMode) {
      print('State updated in TaskFormViewModel');
    }
    super.notifyListeners();
  }
}
