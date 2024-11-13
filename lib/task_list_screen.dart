import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      tasks.add({
        'name': _taskController.text,
        'isCompleted': false,
        'priority': 3,
      });
      _taskController.clear();
    }
  }

  void _toggleComplete(Task task) {
    tasks.doc(task.id).update({'isCompleted': !task.isCompleted});
  }

  void _deleteTask(Task task) {
    tasks.doc(task.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(hintText: 'Enter task name'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasks.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final taskDocs = snapshot.data!.docs;
                final taskList = taskDocs.map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

                return ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    return ListTile(
                      title: Text(
                        task.name,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleComplete(task),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(task),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
