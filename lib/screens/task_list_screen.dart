// lib/screens/task_list_screen.dart
import 'package:flutter/material.dart';
import '../models/task.dart';  // Import the Task model

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();
  String selectedPriority = 'Low';

  void addTask() {
    setState(() {
      tasks.add(Task(name: taskController.text, priority: selectedPriority));
      tasks.sort((a, b) {
        const priorityMap = {'High': 1, 'Medium': 2, 'Low': 3};
        return priorityMap[a.priority]!.compareTo(priorityMap[b.priority]!);
      });
      taskController.clear();
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(hintText: 'Enter task name'),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedPriority,
                  items: ['Low', 'Medium', 'High'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPriority = newValue!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('Add Task'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: tasks[index].isCompleted,
                    onChanged: (value) {
                      toggleTaskCompletion(index);
                    },
                  ),
                  title: Text(
                    '${tasks[index].name} - ${tasks[index].priority}',
                    style: TextStyle(
                      decoration: tasks[index].isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeTask(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
