// lib/models/task.dart
class Task {
  String name;
  bool isCompleted;
  String priority;

  Task({required this.name, this.isCompleted = false, this.priority = 'Low'});
}
