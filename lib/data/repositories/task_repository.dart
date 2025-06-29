import '../data_sources/local_task_data_source.dart';
import '../models/task_model.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<List<Task>> getAllTasks();
}

class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTask(Task task) => localDataSource.addTask(task);

  @override
  Future<void> updateTask(Task task) => localDataSource.updateTask(task);

  @override
  Future<void> deleteTask(String id) => localDataSource.deleteTask(id);

  @override
  Future<List<Task>> getAllTasks() => localDataSource.getAllTasks();
}
