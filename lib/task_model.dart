class Task {
  String id;
  String name;
  bool isCompleted;
  int priority;

  Task({required this.id, required this.name, this.isCompleted = false, this.priority = 3});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'priority': priority,
    };
  }

  static Task fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      name: map['name'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      priority: map['priority'] ?? 3,
    );
  }
}
