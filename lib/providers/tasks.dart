import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/task.dart';

class Tasks with ChangeNotifier {
  List<Task> _tasks = [];
  String authToken;
  String userId;

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
      extractedData.forEach((String taskId, taskData) => loadedTasks.add(
            Task(
              taskID: taskId,
              title: taskData['title'],
              deadLine: DateTime.parse(taskData['deadLine']),
              repeats: taskData['repeats'],
              notes: taskData['notes'],
              completed: taskData['completed'],
            ),
          ));
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
            'deadLine': task.deadLine.toIso8601String(),
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

  Future<void> updateTask(String id, Task task) async {
    var prodIndex = _tasks.indexWhere((tsk) => tsk.taskID == id);
    if (prodIndex >= 0) {
      final url =
          'https://todo-cfb1d.firebaseio.com/tasks/$userId/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': task.title,
            'notes': task.notes,
            'repeats': task.repeats,
            'deadLine': task.deadLine.toIso8601String(),
            'completed': task.completed,
          }));
      _tasks[prodIndex] = task;
      notifyListeners();
    }
  }

  List<Task> getTasksOfDay(DateTime deadLine) {
    if (tasks.isEmpty) {
      return [];
    }
    List<Task> dayTasks = [];
    int i;
    for (i = 0; i < tasks.length; i++) {
      if (tasks[i].deadLine.year == deadLine.year &&
          tasks[i].deadLine.month == deadLine.month &&
          tasks[i].deadLine.day == deadLine.day) {
        dayTasks.add(tasks[i]);
      }
    }
    return dayTasks;
  }

  int getTaskOfDayCount(DateTime day) {
    if (day != null) {
      List<Task> dayTasks = getTasksOfDay(day);
      return dayTasks.length;
    } else {
      return 0;
    }
  }
}
