import 'package:flutter/foundation.dart';
import 'package:task_app/core/enum/task_filter.dart';
import 'package:task_app/core/enum/task_sort.dart';
import 'package:task_app/data/models/task_model.dart';
import 'package:task_app/data/repositories/task_repository.dart';

class TaskListViewModel with ChangeNotifier {
  final TaskRepository repository;

  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  TaskSort _sort = TaskSort.dueDate;
  bool _isLoading = false;

  TaskListViewModel(this.repository);

  List<Task> get tasks => _applyFilterAndSort(_tasks);
  TaskFilter get filter => _filter;
  TaskSort get sort => _sort;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await repository.getAllTasks();
      if (kDebugMode) {
        print('Loaded ${_tasks.length} tasks');
      }
    } catch (e) {
      _tasks = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await repository.addTask(task);
      await loadTasks(); // Refresh the list
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await repository.updateTask(task);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await repository.deleteTask(id);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSort(TaskSort sort) {
    _sort = sort;
    notifyListeners();
  }

  List<Task> _applyFilterAndSort(List<Task> tasks) {
    List<Task> filteredTasks = [...tasks];

    switch (_filter) {
      case TaskFilter.completed:
        filteredTasks =
            filteredTasks.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.active:
        filteredTasks =
            filteredTasks.where((task) => !task.isCompleted).toList();
        break;
      case TaskFilter.all:
        break;
    }

    switch (_sort) {
      case TaskSort.dueDate:
        filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case TaskSort.creationDate:
        filteredTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return filteredTasks;
  }

  @override
  void notifyListeners() {
    if (kDebugMode) {
      print('State updated in TaskListViewModel');
    }
    super.notifyListeners();
  }
}
