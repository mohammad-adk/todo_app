
class Task{
  String title;
  String taskID;
  String notes;
  String repeats;
  List<Task> tasks;
  List<DateTime> reminders;
  DateTime timeToComplete;
  DateTime deadLine;
  bool completed;

  Task({this.title, this.completed, this.taskID});
}