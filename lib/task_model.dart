import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String? objectId;
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task({
    this.objectId,
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Convert a task to a Map to send it to Parse
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dueDate': dueDate.toIso8601String(), // Store as ISO string
      'isCompleted': isCompleted,
    };
  }

  // Converts Task to Parse Object for storing on Back4App
  ParseObject toParseObject() {
    final taskObject = ParseObject('Task')
      ..set('title', title)
      ..set('dueDate', dueDate)  // Directly set DateTime (Back4App handles it)
      ..set('isCompleted', isCompleted);
    if (objectId != null) {
      taskObject.objectId = objectId;
    }
    return taskObject;
  }

  // Create a Task from Parse response
  factory Task.fromParse(ParseObject parseObject) {
    return Task(
      objectId: parseObject.objectId,
      title: parseObject.get<String>('title') ?? '',
      // If 'dueDate' field in Back4App is of type Date, just retrieve it directly as DateTime
      dueDate: parseObject.get<DateTime>('dueDate') ?? DateTime.now(),
      isCompleted: parseObject.get<bool>('isCompleted') ?? false,
    );
  }
}
