class Task {
  String title;
  String taskID;
  String notes;
  String repeats;
  DateTime deadLine;
  bool completed;

  Task({this.title, this.deadLine, this.completed = false, this.notes,});
}
