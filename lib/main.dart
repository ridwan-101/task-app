import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_app/data/data_sources/local_task_data_source.dart';
import 'package:task_app/data/models/task_model.dart';
import 'package:task_app/data/repositories/task_repository.dart';
import 'package:task_app/presentation/view_models/task_form_view_model.dart';
import 'package:task_app/presentation/view_models/task_list_view_model.dart';
import 'package:task_app/presentation/views/task_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with a valid directory
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  // Open the tasks box
  final taskBox = await Hive.openBox<Task>('tasks');

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalTaskDataSource>(
          create: (_) => LocalTaskDataSourceImpl(taskBox),
        ),
        Provider<TaskRepository>(
          create:
              (context) =>
                  TaskRepositoryImpl(context.read<LocalTaskDataSource>()),
        ),
        ChangeNotifierProvider<TaskListViewModel>(
          create:
              (context) =>
                  TaskListViewModel(context.read<TaskRepository>())
                    ..loadTasks(),
        ),
        ChangeNotifierProvider<TaskFormViewModel>(
          create:
              (context) => TaskFormViewModel(context.read<TaskRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Tasks',
      themeMode: ThemeMode.system,
      home: const TaskListScreen(),
    );
  }
}
