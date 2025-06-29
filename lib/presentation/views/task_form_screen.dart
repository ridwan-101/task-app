import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/presentation/view_models/task_form_view_model.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  void _loadTaskData() {
    final viewModel = Provider.of<TaskFormViewModel>(context, listen: false);
    final task = viewModel.editingTask;

    if (task != null) {
      _titleController.text = task.title;
      _noteController.text = task.note ?? '';
      _dueDate = task.dueDate;
      _isCompleted = task.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskFormViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.editingTask == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(DateFormat.yMMMd().format(_dueDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              if (viewModel.editingTask != null) ...[
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Completed'),
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value!;
                    });
                  },
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _saveTask(context),
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<TaskFormViewModel>(context, listen: false);

      final saved = await viewModel.saveTask(
        title: _titleController.text,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        dueDate: _dueDate,
        isCompleted: _isCompleted,
      );

      if (saved && mounted) {
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save task')));
      }
    }
  }
}
