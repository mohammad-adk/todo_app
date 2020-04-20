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

  Future<void> addTasks(Task task) async {
    final url =
        'https://todo-cfb1d.firebaseio.com/tasks/$userId.json?auth=$authToken';
    try {
      final respond = await http.post(
        url,
        body: json.encode(
          {
            'title': task.title,
            'taskID': task.taskID,
            'notes': task.notes,
            'repeats': task.repeats,
            'timeToComplete': task.timeToComplete,
            'deadLine': task.deadLine.toIso8601String(),
            'completed': task.completed,
          },
        ),
      );
//      final extractedResponse = json.decode(respond.body);
      if(json.decode(respond.body)['error'] != null){
        throw Exception(json.decode(respond.body)['error']);
      }
      _tasks.add(task);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
