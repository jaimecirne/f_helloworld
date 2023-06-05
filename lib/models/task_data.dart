import 'package:flutter/foundation.dart';
import 'package:fluttertest/models/tasks.dart';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy milk'),
    Task(name: 'Buy eggs'),
    Task(name: 'Buy bread'),
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle, String randomJoke) {
    final task = Task(name: newTaskTitle, joke: randomJoke);

    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task, bool bool) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  Future<String> fetchRandomJoke() async {
    final response =
        await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body); // Corrija esta linha
      return data['value'];
    } else {
      throw Exception('Failed to fetch random joke');
    }
  }
}
