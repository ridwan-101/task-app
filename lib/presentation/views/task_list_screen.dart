import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/core/enum/task_filter.dart';
import 'package:task_app/core/enum/task_sort.dart';
import 'package:task_app/presentation/view_models/task_list_view_model.dart';
import 'package:task_app/presentation/view_models/task_form_view_model.dart';
import 'package:task_app/presentation/views/task_form_screen.dart';
import 'package:task_app/presentation/widget/task_item.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket Tasks'),
        actions: [_buildFilterMenu(context), _buildSortMenu(context)],
      ),
      body: Consumer<TaskListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.list_alt, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first task',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.loadTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: viewModel.tasks.length,
              itemBuilder: (context, index) {
                final task = viewModel.tasks[index];
                return TaskItem(task: task);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  PopupMenuButton<TaskFilter> _buildFilterMenu(BuildContext context) {
    return PopupMenuButton<TaskFilter>(
      onSelected: (filter) {
        Provider.of<TaskListViewModel>(
          context,
          listen: false,
        ).setFilter(filter);
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: TaskFilter.all,
              child: Text('All Tasks'),
            ),
            const PopupMenuItem(
              value: TaskFilter.active,
              child: Text('Active Only'),
            ),
            const PopupMenuItem(
              value: TaskFilter.completed,
              child: Text('Completed Only'),
            ),
          ],
      icon: const Icon(Icons.filter_list),
      tooltip: 'Filter tasks',
    );
  }

  PopupMenuButton<TaskSort> _buildSortMenu(BuildContext context) {
    return PopupMenuButton<TaskSort>(
      onSelected: (sort) {
        Provider.of<TaskListViewModel>(context, listen: false).setSort(sort);
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: TaskSort.dueDate,
              child: Text('Sort by Due Date'),
            ),
            const PopupMenuItem(
              value: TaskSort.creationDate,
              child: Text('Sort by Creation Date'),
            ),
          ],
      icon: const Icon(Icons.sort),
      tooltip: 'Sort tasks',
    );
  }

  Future<void> _navigateToTaskForm(BuildContext context) async {
    final formViewModel = Provider.of<TaskFormViewModel>(
      context,
      listen: false,
    );
    formViewModel.setEditingTask(null);

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const TaskFormScreen()),
    );

    if (result == true) {
      final listViewModel = Provider.of<TaskListViewModel>(
        context,
        listen: false,
      );
      await listViewModel.loadTasks();
    }
  }
}
