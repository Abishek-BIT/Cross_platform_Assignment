import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;
  final Function(String) deleteTask;
  final Function(String, bool) toggleTaskStatus;

  TaskListWidget({
    required this.tasks,
    required this.deleteTask,
    required this.toggleTaskStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text('Due: ${task.dueDate.toString()}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Toggle Completion Status
              IconButton(
                icon: Icon(
                  task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                  color: task.isCompleted ? Colors.green : Colors.grey,
                ),
                onPressed: () => toggleTaskStatus(task.objectId!, task.isCompleted),
              ),
              // Delete Task
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteTask(task.objectId!),
              ),
            ],
          ),
          onTap: () {
            // Optionally, navigate to a detail screen for editing (if needed)
          },
        );
      },
    );
  }
}
