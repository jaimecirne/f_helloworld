import 'package:flutter/foundation.dart';
import 'package:fluttertest/models/tasks.dart';
import 'dart:collection';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  // [
  //   Task(name: 'Buy milk'),
  //   Task(name: 'Buy eggs'),
  //   Task(name: 'Buy bread'),
  // ];

  UnmodifiableListView<Task> get tasks {
    fetchTasks();
    return UnmodifiableListView(_tasks);
  }

  Future<void> fetchTasks() async {
    _tasks = await getTasks();
    notifyListeners();
  }

  Future<List<Task>> getTasks() async {
    final db = await createDatabase();
    try {
      print("getTask");
      final List<Map<String, dynamic>> maps = await db.query('tasks');
      return List.generate(maps.length, (index) {
        return Task.fromMap(maps[index]);
      });
    } catch (e) {
      // Tratar a exceção aqui
      print('Erro ao obter as tasks: $e');
      return [];
    } finally {
      await db.close();
    }
  }

  int get taskCount {
    return _tasks.length;
  }

  // void addTask(String newTaskTitle) {
  //   final task = Task(name: newTaskTitle);

  //   _tasks.add(task);
  //   notifyListeners();
  // }

  Future<void> addTask(String newTaskTitle) async {
    final task = Task(name: newTaskTitle);
    final db = await createDatabase();
    try {
      print("add1");
      await db.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Tratar a exceção aqui
      print('Erro ao adicionar a task: $e');
    } finally {
      await db.close();
    }
  }

  void updateTask(Task task, bool bool) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  Future<Database> createDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(await getDatabasesPath(), 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE IF NOT EXISTS tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          isDone INTEGER NOT NULL
        )
      ''');
      },
    );
  }
}
