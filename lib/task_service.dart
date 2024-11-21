import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'task_model.dart';

class TaskService {
  // Fetch tasks from the Back4App database, including the due date
  Future<List<Task>> fetchTasks() async {
    final query = QueryBuilder(ParseObject('Task'))
      ..orderByDescending('dueDate'); // Order by dueDate

    final response = await query.query();

    if (response.success && response.results != null) {
      // Correct method call here: Task.fromParse instead of Task.fromParseObject
      return response.results!.map((e) => Task.fromParse(e)).toList();
    } else {
      return [];
    }
  }

  // Add a new task to the database, including due date
  Future<void> addTask(Task task) async {
  final ParseObject taskObject = task.toParseObject();
  final response = await taskObject.save();
  if (response.success) {
    print("Task added successfully");
  } else {
    print("Failed to add task: ${response.error?.message}");
  }
}

  // Update an existing task, including due date
  Future<void> updateTask(Task task) async {
    final ParseObject taskObject = task.toParseObject();
    taskObject.objectId = task.objectId; // Assign the objectId to update the existing task
    final response = await taskObject.save();
    if (!response.success) {
      throw Exception('Failed to update task');
    }
  }

  // Delete a task from the database
  Future<void> deleteTask(String objectId) async {
    final taskObject = ParseObject('Task')..objectId = objectId;
    final response = await taskObject.delete();
    if (!response.success) {
      throw Exception('Failed to delete task');
    }
  }

  // Toggle task completion status
  Future<void> toggleTaskStatus(String objectId, bool currentStatus) async {
    final taskObject = ParseObject('Task')..objectId = objectId;
    taskObject.set('isCompleted', !currentStatus);
    final response = await taskObject.save();
    if (!response.success) {
      throw Exception('Failed to update task status');
    }
  }
}
