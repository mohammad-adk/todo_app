import 'package:flutter/foundation.dart';

class Task {
  String title;
  String taskID;
  String notes;
  List<dynamic> repeats;
  DateTime deadLine;
  bool completed;

  Task({
    @required this.title,
    @required this.deadLine,
    @required this.notes,
    @required this.repeats,
    this.taskID,
    this.completed = false,
  });

  @override
  String toString() {
    return "title: $title, taskId : $taskID";
  }
}
