import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/task.dart';

class Tasks with ChangeNotifier {
  List<Task> _tasks = [];
  String authToken;
  String userId;
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  void update(String token, String id, tasks) {
    authToken = token;
    userId = id;
    _tasks = tasks;
  }

  List<Task> get tasks {
    return [..._tasks];
  }

  Future<void> fetchAndSetTasks() async {
    final url =
        'https://todo-cfb1d.firebaseio.com/tasks/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Task> loadedTasks = [];
      extractedData.forEach(
        (String taskId , taskData) => loadedTasks.add(
            Task(
              taskID: taskId,
              title: taskData['title'],
              deadLine: taskData['deadline'],
              repeats: taskData['repeats'] ,
              notes: taskData['notes'],
              completed: taskData['completed'],
            ),
          )
      );
      _tasks = loadedTasks;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addTasks(Task task) async {
    final url =
        'https://todo-cfb1d.firebaseio.com/tasks/$userId.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': task.title,
            'notes': task.notes,
            'repeats': task.repeats,
            'deadLine': task.deadLine.toString(),
            'completed': task.completed,
          },
        ),
      );
      final extractedResponse = json.decode(response.body);
      if (json.decode(response.body)['error'] != null) {
        throw Exception(json.decode(response.body)['error']);
      }
      task.taskID = extractedResponse['name'];
      _tasks.add(task);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteTask(String id) async {
    final url =
        'https://todo-cfb1d.firebaseio.com/tasks/$userId/$id.json?auth=$authToken';
    final existingTaskIndex = _tasks.indexWhere((task) => task.taskID == id);
    var existingTask = _tasks[existingTaskIndex];
    _tasks.removeWhere((task) => task.taskID == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _tasks.insert(existingTaskIndex, existingTask);
      notifyListeners();
    }
    existingTask = null;
  }
}
