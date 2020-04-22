import 'package:flutter/foundation.dart';

class Task {
  String title;
  String taskID;
  String notes;
  List<String> repeats;
  DateTime deadLine;
  bool completed;

  Task(
      {@required this.title,
      @required this.deadLine,
      @required this.notes,
      @required this.repeats,
      this.completed = false,
      });
}
