import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/data/models/task_model.dart';
import 'package:task_app/presentation/view_models/task_form_view_model.dart';
import 'package:task_app/presentation/view_models/task_list_view_model.dart';
import 'package:task_app/presentation/views/task_form_screen.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Slidable(
            key: Key(task.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _editTask(context),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (_) => _deleteTask(context, viewModel),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              child: CheckboxListTile(
                key: Key('checkbox_${task.id}'),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    color:
                        task.isCompleted
                            ? Colors.grey
                            : Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.note != null && task.note!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          task.note!,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    Text(
                      'Due: ${DateFormat.yMMMd().format(task.dueDate)}',
                      style: TextStyle(
                        color:
                            task.dueDate.isBefore(DateTime.now()) &&
                                    !task.isCompleted
                                ? Colors.red
                                : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                value: task.isCompleted,
                onChanged:
                    (value) => _toggleComplete(context, viewModel, value!),
                secondary: const Icon(Icons.drag_handle),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleComplete(
    BuildContext context,
    TaskListViewModel viewModel,
    bool isCompleted,
  ) async {
    final updatedTask = task.copyWith(isCompleted: isCompleted);
    await viewModel.updateTask(updatedTask);
  }

  Future<void> _deleteTask(
    BuildContext context,
    TaskListViewModel viewModel,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      await viewModel.deleteTask(task.id);
    }
  }

  void _editTask(BuildContext context) {
    final formViewModel = Provider.of<TaskFormViewModel>(
      context,
      listen: false,
    );
    formViewModel.setEditingTask(task);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskFormScreen()),
    );
  }
}
