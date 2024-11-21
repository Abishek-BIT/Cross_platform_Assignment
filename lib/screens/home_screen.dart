import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '/task_model.dart'; // Task model
import '/task_service.dart'; // Task service
import 'task_detail_screen.dart'; // Add/Edit Task Screen
import 'auth_screen.dart'; // Auth Screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when screen is initialized
  }

  // Fetch tasks from the backend
  void _loadTasks() async {
    List<Task> tasks = await _taskService.fetchTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  // Navigate to Task Detail Screen to add a new task
  void _goToAddTaskScreen() async {
    // Wait for the task to be added and return to this screen
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => TaskDetailScreen()),
    );
    _loadTasks(); // Reload tasks after adding a new task
  }

  // Log out functionality
  void _logout() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      await currentUser.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => AuthScreen()),
      );
    }
  }

  // Delete a task
  void _deleteTask(String objectId) async {
    await _taskService.deleteTask(objectId);
    _loadTasks(); // Reload tasks after deletion
  }

  // Toggle task completion status
  void _toggleTaskStatus(String objectId, bool currentStatus) async {
    await _taskService.toggleTaskStatus(objectId, currentStatus);
    _loadTasks(); // Reload tasks after status toggle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: _logout, // Log out functionality
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator when tasks are being fetched
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (ctx, index) {
                        final task = _tasks[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text('Due: ${task.dueDate.toLocal().toString().split(' ')[0]}'), // Display the date in a user-friendly format
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Toggle task completion status
                                IconButton(
                                  icon: Icon(
                                    task.isCompleted
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: task.isCompleted ? Colors.green : Colors.grey,
                                  ),
                                  onPressed: () => _toggleTaskStatus(task.objectId!, task.isCompleted),
                                ),
                                // Delete task
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteTask(task.objectId!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTaskScreen, // Navigate to task detail screen for adding a task
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
