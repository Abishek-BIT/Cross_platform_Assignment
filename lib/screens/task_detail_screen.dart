import 'package:flutter/material.dart';
import '/task_service.dart';
import '/task_model.dart';

class TaskDetailScreen extends StatefulWidget {
  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime _dueDate = DateTime.now(); // Default to current date

  final TaskService _taskService = TaskService();

  // Function to pick due date using Date Picker
  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate, // Initially set to the current date
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked; // Update the _dueDate when the user selects a date
      });
    }
  }

  // Function to handle task submission
  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        title: _titleController.text.trim(),
        dueDate: _dueDate,
      );
      _taskService.addTask(task); // Add the task to the backend
      Navigator.of(context).pop('task_added'); // Notify the Home Screen to refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _pickDueDate(context),
                    child: Text('Pick Date'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTask,
                child: Text('Save Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
